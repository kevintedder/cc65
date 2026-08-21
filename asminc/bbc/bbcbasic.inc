; /*****************************************************************************/
; /*                                                                           */
; /*                Startup code for cc65 for BBC sideways ROM                 */
; /*                                                                           */
; /*        This must be the *first* file on the linker command line           */
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

;	BASIC Zeropage locations

    _lomem      = $00       ; 16 bit pointer to start of BASIC variables
    _vartop     = $02       ; 16 bit pointer to end   of BASIC variables
    _basicsp    = $04       ; 16 bit pointer to most recent entry on BASIC stack
    _himem      = $06       ; 16 bit pointer to start of screen memort-mapped area
    _erl        = $08       ; 16 bit pointer to intruction that errored
    _textoffset = $0a       ; 8 bit offset to _textptr
    _textptr    = $0b       ; 16 bit pointer  to BASIC text line being processed
	_rwa		= $0d		; 5 Byte - Random Work Area exported to 'C'
    _top        = $12       ; 16 bit pointer to end of BASIC program

    _page       = $18       ; 8 bit high order address of start of BASIC program

;   BBC Basic Multi-use work areas
	_iwa		= $2a		; 4 Byte - Integer Work Area exported to 'C'
	_fwa		= $2e		; 8 Byte - Floating Point Work Area A exported to 'C'
	_fwb		= $3b		; 8 Byte - Floating Point Work Area B exported to 'C'

;   BBC BASIC2 sub-routines
    basicrom    = $70       ; save a copy of ROM slot that holds BBC BASIC

;   BBC BASIC2 - Floating Point Routines
    aclear      = $A686
    acomp       = $AD7E
    acopyb      = $A4DC
    adiv        = $A6AD
    adiv10      = $A24D
    aminus      = $A4FD
    amult       = $A656
    amult10     = $A1F4
    anorm       = $A303
    aone        = $A699
    apack       = $A38D
    apack1      = $A385
    apack2      = $A37D
    apack3      = $A381
    aplus       = $A500
    aplusb      = $A505
    aplus1      = $A50B
    arecip      = $A6A5
    around      = $A65C
    asign       = $A1DA
    aswap       = $A4D6
    atest       = $9A5F
    aunp        = $A3B5
    anup1       = $A3B2
    bclear      = $A453
    bcopya      = $A21E
    bunp        = $A34E

;   BBC BASIC2 - Random Number Generator Routines
    rnd         = $af87
    rndi        = $af51     ; Generate a random number between -2147483648 < 0 < 2147483647
    rndx        = $af24     ; Generate a random number between 1 and the value in _iwa
    rndseed     = $af3f     ; Seed _rwa with value in _iwa

