; /*****************************************************************************/
; /*                                                                           */
; /*                        P R I N T _ L I T E ( )                            */
; /*                                                                           */
; /*    A lightweight print function for cc65 for BBC sideways ROM             */
; /*                                                                           */
; /*    A ROM is limited to 16KBytes in size. The printf() takes up too        */
; /*    much room so this smaller print() function has been developed          */
; /*                                                                           */
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

	.export		_print_newline, _print_lite
	.export		_intdec, _inthex

	.include	"bbc/os.inc"

_print_newline:						; Print a string terminated by <CR>
	jmp		OSNEWL


_print_lite:						; Print a string that is terminated by Null
;
; void print_str( char * str )
;
	sta     ptr1
	stx     ptr1+1
	ldy     #$00
_loop:
	lda     (ptr1),y
	beq		_exit					; Is this string null terminated

	jsr		OSWRCH
	iny
	jmp		_loop

_exit:
	rts



_intdec:
;
; char* intdec(int value, char * str ) {
;
	jsr     pushax

    lda     #$0A            ; set Base for decimal conversation
    sta     tmp1
    jmp     _itoa_conversion

_inthex:
;
; char* inthex(int value, char * str) {
;
	jsr     pushax

    lda     #$10            ; set Base for hexadecimal conversation
    sta     tmp1


_itoa_conversion:
;
; itoa( value, str, 16);
;
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
; return str;
;
	ldy     #$01
	lda     (sp),y
	tax
	dey
	lda     (sp),y
;
; }
;
	jmp     incsp4
