; /*****************************************************************************/
; /*                                                                           */
; /*                bbcbasic function calls                                    */
; /*                                                                           */
; /*                                                                           */
; /*                                                                           */
; /*  All service routines must be declare as:                                 */
; /*      void __fastcall__ <service_routine>();                               */
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


	.importzp	sp, sreg, regsave, regbank

    .import     pusheax, incsp4

	.export		_rnd, _fp_init, _fp_div, _fp_get, _fp_let, _fp_minus, _fp_mult, _fp_plus, init_fp_rom, select_fp_rom

	.include	"bbc/os.inc"
	.include	"bbc/bbcbasic.inc"

; ---------------------------------------------------------------
; long __near__ _fp_init(fp var)
;       FWA = fp var / FWA normalised & rounded
; ---------------------------------------------------------------
_fp_init:
    rts

; ---------------------------------------------------------------
; long __near__ _fp_div(fp var)
;       FWA = fp var / FWA normalised & rounded
; ---------------------------------------------------------------
_fp_div:
    jsr     fpvar
    jsr     adiv
    rts

; ---------------------------------------------------------------
; long __near__ _fp_get(fp var)
;       pack FWA into fp var
; ---------------------------------------------------------------
_fp_get:
    jsr     fpvar
    jsr     apack
    rts

; ---------------------------------------------------------------
; long __near__ _fp_let(fp var)
;       unpack fp var into FWA
; ---------------------------------------------------------------
_fp_let:
    jsr     fpvar
    jsr     aunp
    rts

; ---------------------------------------------------------------
; long __near__ _fp_minus(fp var)
;       FWA = fp var - FWA normalised & rounded
; ---------------------------------------------------------------
_fp_minus:
    jsr     fpvar
    jsr     aminus
    rts

; ---------------------------------------------------------------
; long __near__ _fp_mult(fp var)
;       FWA = fp var * FWA normalised & rounded
; ---------------------------------------------------------------
_fp_mult:
    jsr     fpvar
    jsr     amult
    rts

; ---------------------------------------------------------------
; long __near__ _fp_plus(fp var)
;       FWA = fp var + FWA normalised & rounded
; ---------------------------------------------------------------
_fp_plus:
    jsr     fpvar
    jsr     aplus
    rts

; ---------------------------------------------------------------
; long __near__ _rnd(long var)
; ---------------------------------------------------------------
_rnd:
;   parameter supplied in __EAX__
    sta     _iwa
    stx     _iwa+1
    lda     sreg
    sta     _iwa+2
    lda     sreg+1
    sta     _iwa+3

    jsr     select_fp_rom
    jsr     rndx           ; Call Basic ROM function rndx - RND(between 0 & iwa)

;   Return _iwa in __EAX__
    lda     _iwa+3
    sta     sreg+1
    lda     _iwa+2
    sta     sreg
    ldx     _iwa+1
    lda     _iwa

    rts

; ---------------------------------------------------------------
; Initialise - find BASIC rom slot and save it
; ---------------------------------------------------------------

init_fp_rom:
    ldx     #$0
    ldy     #$ff
    lda     #$bb
    jsr     OSBYTE
	stx     basicrom

    rts

; ---------------------------------------------------------------
; Ensure the BASIC rom is current selected
; ---------------------------------------------------------------
select_fp_rom:
	lda     basicrom
	sta     $f4
	sta     $fe30
    rts

; ---------------------------------------------------------------
; save fp *var and select BASIC rom
; ---------------------------------------------------------------
fpvar:                          
;   parameter supplied in __AX__
    sta     $4b
    stx     $4c
    jsr     select_fp_rom
    rts

