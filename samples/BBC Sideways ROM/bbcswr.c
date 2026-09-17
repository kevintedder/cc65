/*****************************************************************************/
/*                                                                           */
/*                                sideways_rom.c                             */
/*                                                                           */
/*                Define a BBC sideways ROM framework Header                 */
/*                                                                           */
/* (C) 2025  Kevin Tedder                                                    */
/*                                                                           */
/* Versions:                                                                 */
/* 01/06/2025   v1.0    -   First release                                    */
/*                                                                           */
/*                                                                           */
/*                                                                           */
/* This software is provided 'as-is', without any expressed or implied       */
/* warranty.  In no event will the authors be held liable for any damages    */
/* arising from the use of this software.                                    */
/*                                                                           */
/* Permission is granted to anyone to use this software for any purpose,     */
/* including commercial applications, and to alter it and redistribute it    */
/* freely, subject to the following restrictions:                            */
/*                                                                           */
/* 1. The origin of this software must not be misrepresented; you must not   */
/*    claim that you wrote the original software. If you use this software   */
/*    in a product, an acknowledgment in the product documentation would be  */
/*    appreciated but is not required.                                       */
/* 2. Altered source versions must be plainly marked as such, and must not   */
/*    be misrepresented as being the original software.                      */
/* 3. This notice may not be removed or altered from any source              */
/*    distribution.                                                          */
/*                                                                           */
/*****************************************************************************/

#include <bbcswr/bbcswr.h>
#include <bbcswr/bbcswr_debug.h>
#include <bbc/types.h>


//	Use of CONST qualifier forces data in RODATA segment for Sideways ROM

//  ##################################################
//  ### ROM utility routines                       ###
//  ##################################################

void print_rom_title() {
    swr_print_str( (char*) SWR_Title );
    swr_print_space(1);
    swr_print_str( (char*) SWR_Version );
    swr_print_newline();
}

//  ##################################################

#pragma optimize (off)

void service_routine_pre_call() {
//	This routine go hand-in-hand with '_service_routine_post_call'.
//	Setup the CC65 'C' environment and prepare the A,X,Y parameter
//	on the C stack.

//	On entry:   _Areg	=	ROM Service Type requested
//				_Xreg	= 	Current ROM Number
//				_Yreg	= 	Any parameter required for the service
	
//	Claim AWS for this service call - all other ROMs shall release it
	asm("jsr	_claim_static_aws");

//	Prepare AWS pointer
	asm("lda	#$0e");					//Set pointer to Absolute workspace
 	asm("sta	%v + 1", aws);
 	asm("lda	#$00");
 	asm("sta	%v", aws);

// 	Prepare PWS pointer
	asm("ldx	%v",Xreg);				//Get ROM No
	asm("lda	_paged_rom_ws,x");		//Retrieve the PWS page address
	asm("and	#$7f");					//Mask out bit 2^7 (AWS owner)
	asm("sta	%v + 1", pws);			//Set pointer to Private workspace
	asm("lda	#$00");
	asm("sta	%v", pws);

//	Prepare C Stack pointer from PWS
	asm("ldy	#$80");					//Offset to PWS->c_stack_ptr
	asm("lda	(%v),y", pws);			//Load from PWS
	asm("sta	c_sp");					//Low Byte of C Stack
	asm("lda	%v + 1", pws);
	asm("sta	c_sp + 1");				//High Byte of C Stack
}

//  ##################################################
void service_routine_post_call() {
//	Tidy up after calling service routine and restore regs __A__, __X__, __Y__
//	with the returned value from the called service in EAX (as a long).

//	On entry:   _Areg	=	ROM Service Type requested
//				_Xreg	= 	Current ROM Number
//				_Yreg	= 	Any parameter required for the service
	
//	Save C-Stack pointer to this ROMs PWS
	asm("lda	c_sp");					//Lower Byte of C Stack
	asm("ldy	#$80");					//Offset to PWS->c_stack_ptr
	asm("sta	(%v),y", pws);			//Save in PWS->c_stack_ptr
	asm("jmp	_restore_regs");
}

//  ##################################################
void restore_regs() {

//	Restore CPU registers for next service call
	asm("lda	%v", Areg);
	asm("ldx	%v", Xreg);
	asm("ldy	%v", Yreg);
}


//  ##################################################
void issue_rom_service_call() {
//									
//	On Entry:	;	__X__ = Service Call
//				;	__Y__ = Service Argument

//	push previously saved regs & __SP__ to CPU stack. Makes service ROM re-entrant
	asm("lda	%v", Areg);
	asm("pha");
	asm("lda	%v", Xreg);
	asm("pha");
	asm("lda	%v", Yreg);
	asm("pha");
	
	asm("lda	#$8f");				//Osbyte ROM service Requests
//		ldx		#$00");				//Service Request   - Preset by calling function
//		ldy		#$00");				//Service Argument  - Preset by calling function
	asm("jsr    OSBYTE");      		//Returned value in X(low) Y(High)

//	Restore previous service call register. Makes Service ROM re-entrant
	asm("pla");
	asm("sta	%v", Yreg);
	asm("pla");
	asm("sta	%v", Xreg);
	asm("pla");
	asm("sta	%v", Areg);
}

#pragma optimize (off)

