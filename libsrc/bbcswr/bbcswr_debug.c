/*****************************************************************************/
/*                                                                           */
/*                        sideways_rom debug routine                         */
/*                                                                           */
/*    This header file contains print routines for the sole purpose to       */
/*    debug the code during development. It should be removed from the       */
/*    before being released.                                                 */
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

//  ################################################################################
//  ### THE FOLLOWING IS USED FOR DEBUGGING PURPOSES ONLY - can be commented out ###
//  ################################################################################

const char nibble[] = "0123456789ABCDEF";

#pragma optimize (off)

void dbg_print_header() {
	
	asm("pha");
	asm("lda	#'&'");				// Print BBC Hex char
	asm("jsr	OSWRCH");
	// asm("lda	#'0'");
	// asm("jsr	OSWRCH");
	// asm("lda	#'x'");
	// asm("jsr	OSWRCH");
	asm("pla");
}
void dbg_print_tailer() {
	asm("pha");
	asm("lda		#' '");
	asm("jsr		OSWRCH");
	asm("pla");
}

void dbg_nibble() {

//	On entry:    	A	=	Nibble Value

	asm("tax");
	asm("lda	_nibble,x");
	asm("jsr	OSWRCH");
}

void dbg_byte() {
	
//	On entry:    	A	=	Byte Value

	asm("pha");
	asm("lsr		a");
	asm("lsr		a");
	asm("lsr		a");
	asm("lsr		a");
	asm("jsr		_dbg_nibble");
	asm("pla");
	asm("and		#$0f");
	asm("jsr		_dbg_nibble");
}

void dbg_print_byte( byte value ) {

//	On entry:    	A = Byte value,  is also on C stack

	asm("jsr		_dbg_print_header");
	asm("jsr		_dbg_byte");
	asm("jsr		_dbg_print_tailer");
}


void dbg_print_word( unsigned int value ) {

//	On entry:    	AX = Word Value,  is also on C stack
	
	asm("pha");
	asm("jsr		_dbg_print_header");
	asm("txa");
	asm("jsr		_dbg_byte");
	asm("pla");
	asm("jsr		_dbg_byte");
	asm("jsr		_dbg_print_tailer");
}

void dbg_print_long( unsigned long value ) {
	
//	On entry:    	EAX	=	Long Value
	
	asm("pha");
	asm("txa");
	asm("pha");
	asm("jsr		_dbg_print_header");
	asm("lda		sreg+1");
	asm("jsr		_dbg_byte");			// sreg+1
	asm("lda		sreg");
	asm("jsr		_dbg_byte");			// sreg
	asm("pla");
	asm("jsr		_dbg_byte");			// X reg
	asm("pla");
	asm("jsr		_dbg_byte");			// A reg
	asm("jsr		_dbg_print_tailer");
}

#pragma optimize (on)

void dbg_print_osbyte_registers(){
    swr_print_str( " os_A:");
    dbg_print_byte( OS_Areg );
    swr_print_str( " os_X:");
    dbg_print_byte( OS_Xreg );
    swr_print_str( " os_Y:");
    dbg_print_byte( OS_Yreg );
}
void dbg_print_cpu_registers() {
    swr_print_str( "A:");
    dbg_print_byte( Areg);
    swr_print_str( "X:");
    dbg_print_byte( Xreg);
    swr_print_str( "Y:");
    dbg_print_byte( Yreg);
}
void dbg_print_workspace() {
    swr_print_str( "AWS:" );
    dbg_print_word( (word) aws );
    swr_print_str( "PWS:" );
    dbg_print_word( (word) pws );
}

void dbg_print_rom() {
    // dbg_print_cpu_registers();
    // dbg_print_workspace();
    // swr_print_newline();
    // swr_print_newline();
}

// void dbg_print_reg() {
	// swr_print_str( "a:");
	// dbg_print_byte( A );
	// swr_print_str( "x:");
	// dbg_print_byte( X );
	// swr_print_str( "y:");
	// dbg_print_byte( Y );
    // swr_print_newline();
	
	// aws->eax.a = A;
	// aws->eax.x = X;
	// aws->eax.y = Y;
	// return aws->eax;	// Return the values of A, X, Y

// }
