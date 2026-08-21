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

#include <bbc/swr_print_lite.h>
#include <bbc/swr.h>
#include <bbc/types.h>

//  ################################################################################
//  ### THE FOLLOWING IS USED FOR DEBUGGING PURPOSES ONLY - can be commented out ###
//  ################################################################################

void dbg_print_byte( byte value) {
    char buf[13];
    swr_print_str("0x");
    swr_print_str( inthex( value, buf ) );

}
void dbg_print_word( word value) {
    char buf[13];
    swr_print_str("0x");
    swr_print_str( inthex( value, buf ) );
}
void dbg_print_osbyte_registers(){
    swr_print_str( " os_A:");
    dbg_print_byte( OS_Areg );
    swr_print_str( " os_X:");
    dbg_print_byte( OS_Xreg );
    swr_print_str( " os_Y:");
    dbg_print_byte( OS_Yreg );
    swr_print_newline();
}
void dbg_print_cpu_registers() {
    swr_print_str( " A:");
    dbg_print_byte( Areg);
    swr_print_str( " X:");
    dbg_print_byte( Xreg);
    swr_print_str( " Y:");
    dbg_print_byte( Yreg);
    swr_print_newline();
}
// void dbg_print_workspace() {
//     swr_print_str( " AWS:" );
//     print_word( (word) &aws );
//     swr_print_str( " PWS:" );
//     print_word( (word) pws );
//     swr_print_newline();
// }


/*

; ; ------------------------------------------------------------------------
; ; THE FOLLOWING IS USED FOR DEBUGGING PURPOSES ONLY - can be commented out
; ; ------------------------------------------------------------------------

; 	.export		_print_byte, _print_word

; ; ------------------------------------------------------------------------
; _nibble:
; 	.byte	"0123456789ABCDEF"

; ; ------------------------------------------------------------------------
; _print_nibble:
; 	and		#$0F
; 	tax
; 	lda		_nibble,x
; 	jsr		OSWRCH
; 	rts

; ; ------------------------------------------------------------------------
; _print_hex:
; 	pha								; Preserve __A__
; 	ror		a
; 	ror		a
; 	ror		a
; 	ror		a
; 	jsr		_print_nibble

; 	pla								; Restore __A__
; 	jsr		_print_nibble
; 	rts

; _print_hex_header:
; 	lda		#$30					; '0'
; 	jsr		OSWRCH
; 	lda		#$78					; 'x'
; 	jsr		OSWRCH
; 	rts

; _print_hex_footer:
; 	lda		#$20					; ' '
; 	jsr		OSWRCH
; 	rts

; ; ------------------------------------------------------------------------
; _print_byte:						; Print the value held in __A__ reg
; 	sta		tmp1					; Preserve __A__
; 	stx		tmp2					; Preserve __X__
; 	sty		tmp3					; Preserve __Y__

; 	jsr		_print_hex_header

; 	lda		tmp1					; Restore __A__
; 	jsr		_print_hex				; Print it

; 	jsr		_print_hex_footer

; 	lda		tmp1					; Restore __A__
; 	ldx		tmp2					; Restore __X__
; 	ldy		tmp3					; Restore __Y__
; 	rts

; ; ------------------------------------------------------------------------
; _print_word:						; Print the value held in __AX__ reg
; 	sta		tmp1					; Preserve __A__
; 	stx		tmp2					; Preserve __X__
; 	sty		tmp3					; Preserve __Y__

; 	jsr		_print_hex_header

; 	lda		tmp2					; Restore __X__
; 	jsr		_print_hex				; Print it

; 	lda		tmp1					; Restore __A__
; 	jsr		_print_hex				; Print it

; 	jsr		_print_hex_footer

; 	lda		tmp1					; Restore __A__
; 	ldx		tmp2					; Restore __X__
; 	ldy		tmp3					; Restore __Y__
; 	rts

*/