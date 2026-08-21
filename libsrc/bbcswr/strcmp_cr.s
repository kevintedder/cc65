; /*****************************************************************************/
; /*                                                                           */
; /*                        P R I N T _ L I T E ( )                            */
; /*                                                                           */
; /*    A lightweight string compare function for cc65 for BBC sideways ROM    */
; /*                                                                           */
; /*    Since BBC strings are <CR> terminated this function can compare        */
; /*    both BBC & 'C' strings. It uses <NULL>, <CR> & <DOT> as terminators    */
; /*                                                                           */
; /*                                                                           */
; /* (C) 1998  Ullrich von Bassewitz, 31.05.1998                               */
; /* (C) 2025  Kevin Tedder                                                    */
; /*                                                                           */
; /* Versions:                                                                 */
; /* 01/06/2025   v1.0    -   First release                                    */
; /*                                                                           */
; /*                                                                           */
; /*                                                                           */
; /* This software is provided 'as-is', without any expressed or implied       */
; /* warranty.  In no event will the authors be held liable for any damages    */
; /* arising from the use of this software.                                    */
; /*                                                                           */
; /* Permission is granted to anyone to use this software for any purpose,     */
; /* including commercial applications, and to alter it and redistribute it    */
; /* freely, subject to the following restrictions:                            */
; /*                                                                           */
; /* 1. The origin of this software must not be misrepresented; you must not   */
; /*    claim that you wrote the original software. If you use this software   */
; /*    in a product, an acknowledgment in the product documentation would be  */
; /*    appreciated but is not required.                                       */
; /* 2. Altered source versions must be plainly marked as such, and must not   */
; /*    be misrepresented as being the original software.                      */
; /* 3. This notice may not be removed or altered from any source              */
; /*    distribution.                                                          */
; /*                                                                           */
; /*****************************************************************************/

.setcpu		"6502"

; int strcmp (const char* s1, const char* s2);
;
	.include	"bbc/os.inc"

		.export		_strcmp_cr
		.import		popax
		.importzp	ptr1, ptr2

		.import 	_dbg_print_byte
		
_strcmp_cr:
		sta		ptr2			; Save s2
		stx		ptr2+1

		jsr		popax			; Get s1
		sta		ptr1
		stx		ptr1+1

		ldy		#0

loop:
		lda		(ptr1),y

		cmp		#$0d
		beq		L2				; <CR> end of string s1

		cmp		#$00
		beq		L2				; <NULL> end of string s1

		cmp		#'.'
		beq		L2				; <DOT> end of string s1

		cmp		(ptr2),y
		bne		L1				; Not match
		
		iny
		bne		loop

		inc		ptr1+1
		inc		ptr2+1
		bne		loop

L1:
		lda		#$FF			; Return False
		tax
		rts

L2:
		lda		#$00			; Return True
		tax
		rts
