; /*****************************************************************************/
; /*                                                                           */
; /*                        P R I N T _ L I T E ( )                            */
; /*                                                                           */
; /*    A lightweight print function for cc65 for BBC sideways ROM             */
; /*                                                                           */
; /*    A BBC sideways ROM is limited to 16KBytes in size. The printf()        */
; /*    takes up too much room so this smaller swr_print_str() function        */
; /*    hasbeen developed.                                                     */
; /*                                                                           */
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

	.importzp	sp, sreg, regsave, regbank
	.importzp	tmp1, tmp2, tmp3, tmp4, ptr1, ptr2, ptr3, ptr4

	.import		_itoa, incsp4, decsp4, pushax

	.export		_swr_print_newline, _swr_print_space, _swr_print_str
	.export		_intdec, _inthex

	.include	"bbc/os.inc"


; ===============================================================
.segment	"CODE"

.proc	_swr_print_newline: near

; ---------------------------------------------------------------
; Print a string terminated by <CR>
; ---------------------------------------------------------------
	jmp		OSNEWL

.endproc


; ===============================================================
.segment	"CODE"

.proc	_swr_print_space: near

; ---------------------------------------------------------------
; Print a string terminated by <CR>
; ---------------------------------------------------------------
	lda		#' '
	jmp		OSWRCH

.endproc


; ===============================================================
.segment	"CODE"

.proc	_swr_print_str: near

; ---------------------------------------------------------------
; void swr_print_str( char* str )
;
; Print a C string terminated by Null
;		swr_print_str( "Hello World" );

; To print numeric variables use convert to a C string using intdec/inthex
;		swr_print_str( inthex( 12, buf) );
; ---------------------------------------------------------------

	sta     ptr1
	stx     ptr1+1
	ldy     #$00
_loop:
	lda     (ptr1),y
	beq		_exit					; Is this string <NULL> terminated
	cmp		#$0d					; Is this string <CR> terminated
	beq		_exit
	
	jsr		OSWRCH
	iny
	jmp		_loop

_exit:
	rts

.endproc


; ===============================================================
.segment	"CODE"

.proc	_intdec: near

; ---------------------------------------------------------------
; char* intdec(int value, char * str ) {
;
; E.g.
;	char buf[13];
;	_swr_print_str( intdec( cmd_idx, buf ) );
; ---------------------------------------------------------------

	jsr     pushax
    lda     #$0A            ; set Base for decimal conversation
    sta     tmp1
    jmp     _itoa_conversion

.endproc


; ===============================================================
.segment	"CODE"

.proc	_inthex: near

; ---------------------------------------------------------------
; char* inthex(int value, char * str) {
;
; E.g.
;	char buf[13];
;	_swr_print_str( inthex( cmd_idx, buf ) );
; ---------------------------------------------------------------

	jsr     pushax
    lda     #$10            ; set Base for hexadecimal conversation
    sta     tmp1

.endproc


; ===============================================================
.segment	"CODE"

.proc	_itoa_conversion: near

; ---------------------------------------------------------------
; char* itoa( value, str, 16);
;
; E.g.
;	char buf[13];
;	_swr_print_str( inthex( cmd_idx, buf ) );
; ---------------------------------------------------------------

	jsr     decsp4
	ldy     #$07
	lda     (sp),y
	tax
	dey
	lda     (sp),y
	ldy     #$02
	sta     (sp),y
	iny
	txa
	sta     (sp),y
	ldy     #$05
	lda     (sp),y
	tax
	dey
	lda     (sp),y
	ldy     #$00
	sta     (sp),y
	iny
	txa
	sta     (sp),y
	ldx     #$00
	lda     tmp1
	jsr     _itoa
;
; 		return str;
;
	ldy     #$01
	lda     (sp),y
	tax
	dey
	lda     (sp),y

	jmp     incsp4

.endproc
