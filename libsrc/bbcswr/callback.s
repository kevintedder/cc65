; /*****************************************************************************/
; /*                                                                           */
; /*                        C A L L B A C K ( )                                */
; /*                                                                           */
; /*    The standard callback mechanism (*func_ptr)(param1, param2) uses       */
; /*    the DATA segment of RAM to hold a JMP $<addr> instruction. The         */
; /*    <addr> is modified and a JSR calls it. Since this code resides         */
; /*    in ROM this mechanism cannot be used.                                  */
; /*                                                                           */
; /*    This callback() function modifies the Page Zero Tmp1..3 to store       */
; /*    the JMP $<addr> instruction and a JSR calls it.                        */
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

;	.import		_itoa, incsp4, decsp4, pushax
	.export		_swr_callback



; ===============================================================
.segment	"CODE"

.proc	_swr_callback: near
; ---------------------------------------------------------------
; void __near__ __fastcall__ swr_callback (void *cmd_func)
; ---------------------------------------------------------------

;	jsr     pushax
	sta     tmp2		; Save Low Order Address
	stx     tmp3		; Save High Order Address
	lda		#$4C		; Load Opcode JMP tmp2 - direct thru tmp2&3
	sta		tmp1
	jsr		tmp1		; Call function via tmp1..3
;	jmp     incsp2
	rts
	
.endproc
