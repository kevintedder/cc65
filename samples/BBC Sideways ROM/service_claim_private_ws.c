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

#include <stdio.h>
#include <stdlib.h>
#include <string.h>


#include <bbcswr/bbcswr.h>
#include <bbcswr/swr_debug.h>
#include <bbcswr/types.h>

#define PWS_SIZE  sizeof(struct pws) // include code to claim Private workspace if size > 0

void service_claim_private_ws() {

//	On entry:   Areg	=	ROM Service Type requested
//				Xreg	= 	Current ROM Number
//				Yreg	= 	Any parameter required for the service

#ifdef SWR_DEBUG
	swr_print_str( "service_claim_private_ws:Begin" );
	swr_print_newline();
#endif

//	DO NOT CHANGE - No local variables declared.  This code is written so as not to use 
//					the C stack whilst the ROM initialises PWS

	if ( PWS_SIZE > 0 ) {	// code to claim Private workspace if size > 0

		pws = (struct pws *)(Yreg + ( PWS_SIZE / 256 ) + 1 );		// Struct pws declared in /include/bbcswr/swr.h
		paged_rom_ws[Xreg] = (byte)(pws);							// Save PWS pointer into Paged ROM Workspace Storage @ 0x0df0
		Yreg = (byte)pws;											// Return PWS pointer to BBC OS
		pws = (struct pws *)((byte)(pws) * 256);					// Define how many pages required for private workspace
	}

	// pws->c_stack_ptr = ( (word)pws * 256 ); //+ sizeof(pws->c_stack);
	// Now PWS is setup, initialise a persistant C stack between service calls
	asm("ldy	#%b", sizeof(pws->c_stack));						// Offset to PWS->c_stack_ptr
	asm("lda	#%b", sizeof(pws->c_stack)-1);						// Size of C Stack -1 ($7f)
	asm("sta	(_pws),y");											// Save stack point in c_stack_pointer


#ifdef SWR_DEBUG
	swr_print_str( "service_claim_private_ws:End" );
	swr_print_newline();

	swr_print_str("pws: a:");
	dbg_print_byte( Areg );
	swr_print_str(" x:");
	dbg_print_byte( Xreg );
	swr_print_str(" y:");
	dbg_print_byte( Yreg );
	swr_print_str(" ");
	dbg_print_word( (word)pws );
	dbg_print_byte( paged_rom_ws[Xreg] );
	swr_print_newline();
	dbg_print_rom();
#endif

}
