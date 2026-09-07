; /*****************************************************************************/
; /*                                                                           */
; /*                    BBC EVENTV & BRKV handler routine                      */
; /*                                                                           */
; /*    This                                                                   */
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

	.include "bbc/os.inc"
	.include "bbc/osbyte.inc"
	.include "zeropage.inc"

	.importzp	tmp1, tmp2, tmp3, tmp4, ptr1, ptr2, ptr3, ptr4

; # ========================================================
; # BRK handler
; # ========================================================

	.export	brkret
	.export	_brkinitialise, _brkterminate

	.bss
oldbrkv:	.res	2
brkret:		.res	2	; where to jump back to if a BRK is trapped
						; this is set by __set_brk_ret
	.code

_brkinitialise:
;	On entry:    	AX 	= 
;					Y	= 
;					
;	On Exit:		AX	= 
;					Y	= 
;
;	NOTE:			It is assumed that the calling function will disable Interrupts before call.

	lda		#<_brkhandler			; Low byte of new event vector
	ldx		#>_brkhandler			; High byte of new event vector
	ldy		#<(BRKV - $0200)		; BRKV offset

	jsr		_exchange_os_vector

	sta		oldbrkv					; Save old BRKV vector returned in AX
	stx		oldbrkv+1

	rts


_brkterminate:
;	On entry:    	AX 	= 
;					Y	= 
;					
;	On Exit:		AX	= 
;					Y	= 
;
;	NOTE:			It is assumed that the calling function will disable Interrupts before call.


	lda		oldbrkv					; Low byte of original event vector
	ldx		oldbrkv+1				; High byte of original event vector
	ldy		#<(BRKV - $0200)		; BRKV offset

	jsr		_exchange_os_vector

									; Discard returned vector in AX
	; sta		oldeventv				; Save new BRKV vector
	; stx		oldeventv+1

	rts


_brkhandler:

	; Handler code to be written

	jmp	(oldbrkv)					; Return via the original BRK vector



; # ========================================================
; # EVENT handler
; # ========================================================

	.export		_eventinitialise, _eventterminate

	.bss
oldeventv:	.res	2
oldescen:	.res	1				; was escape event enabled before?

	.code

_eventinitialise:
;	On entry:    	AX 	= 
;					Y	= 
;					
;	On Exit:		AX	= 
;					Y	= 
;
;	NOTE:			It is assumed that the calling function will disable Interrupts before call.


	lda		#<_eventhandler			; Low byte of new event vector
	ldx		#>_eventhandler			; High byte of new event vector
	ldy		#<(EVNTV - $0200)		; EVENTV offset

	jsr		_exchange_os_vector

	sta		oldeventv				; Save old EVENTV vector returned in AX
	stx		oldeventv+1
	
	rts


_eventterminate:
;	On entry:    	AX 	= 
;					Y	= 
;					
;	On Exit:		AX	= 
;					Y	= 
;
;	NOTE:			It is assumed that the calling function will disable Interrupts before call.


; 	AX contains exit code, store LSB in user flag
	
;	Tidy up. Close any open files, etc

	; restore event handler
	lda		oldeventv				; Low byte of the original event vector
	ldx		oldeventv+1				; High byte of original event vector
	ldy		#<(EVNTV - $0200)		; EVENTV offset

	jsr		_exchange_os_vector

									; Discard returned veector in AX
	; sta		oldeventv				; Save new EVENTV vector
	; stx		oldeventv+1

	rts


; # ========================================================
; # Enable/Disable Events
; # ========================================================

	.export		_enable_event, _disable_event

_enable_event:
;	On entry:    	X 	= Events to enabled
;					
	lda		#osbyte_ENABLE_EVENT
	jmp		OSBYTE


_disable_event:
;	On entry:    	AX 	= Events to disabled
;
	lda		#osbyte_DISABLE_EVENT
	jmp		OSBYTE



; # ========================================================
; # Event Handler
; # ========================================================

	.import		preservezp, restorezp

;	This event table list the routines to process each event
_eventtable:
	.addr		_event0				; 0x00	Output buffer Empty
	.addr		_event1				; 0x01	Input buffer full
	.addr		_event2				; 0x02	Char enters input buffer
	.addr		_event3				; 0x03	ADC Conversion Complete
	.addr		_event4				; 0x04	Vertical Sync
	.addr		_event5				; 0x05	Interval Timer = Zero
	.addr		_event6				; 0x06	ESCAPE condition detected
	.addr		_event7				; 0x07	RS423 Error
	.addr		_event8				; 0x08	Network Error
	.addr		_event9				; 0x09	User Event


_eventhandler:
;	On entry:    	A	=	EVENT number
;					X 	= 	event data
;					Y	= 	event data
;					
;	On Exit:		A	=	preserved
;					X	= 	preserved
;					Y	= 	preserved
;
;	NOTE:			It is assumed that the calling function will disable Interrupts before call.

	; cmp		#$0a
	; bcc		_eh_exit				; Event number >= $0A, goto exit

	sta		tmp1					; Save AX temporarily
	stx		tmp2

	pha								; Preserve all registers to CPU stack
	txa
	pha
	tya
	pha

	; jsr		preservezp				; preserve page zero (26 bytes) to C Stack

	asl		a						; Use the Event number as an index into the event table
	tax
	lda		_eventtable,x
	sta		_eh01+1					; Update event address into the JSR @ <_eh01> below
	lda		_eventtable+1,x
	sta		_eh01+2

	lda		tmp1					; Restore AX fro, temp store
	ldx		tmp2
	
_eh01:
	jsr		_eh01					; Call Event routine (altered from above)

	; jsr		restorezp				; restore page zero (26 bytes) from C stack

	pla								; Restore all registers from CPU stack
	tay
	pla
	tax
	pla
	
_eh_exit:	
	jmp		(oldeventv)				; Return via the original EVENT vector


_event0:							; 0x00	Output buffer Empty
	lda		#'0'
	jsr		OSWRCH
	rts

_event1:							; 0x01	Input buffer full
	lda		#'1'
	jsr		OSWRCH
	rts

_event2:							; 0x02	Char enters input buffer
	lda		#'2'
	jsr		OSWRCH
	rts

_event3:							; 0x03	ADC Conversion Complete
	lda		#'3'
	jsr		OSWRCH
	rts

_event4:							; 0x04	Vertical Sync
	lda		#'4'
	jsr		OSWRCH
	rts

_event5:							; 0x05	Interval Timer = Zero
	lda		#'5'
	jsr		OSWRCH
	rts

_event6:							; 0x06	ESCAPE condition detected
	lda		#'6'
	jsr		OSWRCH
	rts

_event7:							; 0x07	RS423 Error
	lda		#'7'
	jsr		OSWRCH
	rts

_event8:							; 0x08	Network Error
	lda		#'9'
	jsr		OSWRCH
	rts

_event9:							; 0x09	User Event
	lda		#'A'
	jsr		OSWRCH
	rts


; # ========================================================
; # Exchange system vectors
; # ========================================================

	.import VECTORTABLE

_exchange_os_vector:
;	On entry:    	AX 	= New vector address
;					Y	= Vector offset in Page $0200
;					
;	On Exit:		AX	= Old vector address (must be saved somewhere for future restore)
;					Y	= preserved
;
;	NOTE:			It is assumed that the calling function will disable Interrupts before call.

	sta		tmp1					; save lowbyte of new vector temporarily
	stx		tmp2					; save highbyte of new vector temporarily
	
	lda		VECTORTABLE,y			
	pha								; Push lowbyte of the original Vector address to CPU Stack
	iny
	lda		VECTORTABLE,y
	pha								; Push highbyte of original Vector address to CPU Stack

	dey
	lda		tmp1
	sta		VECTORTABLE,y			; Store lowbyte of new vector address in &0200 + Offset
	iny
	lda		tmp2
	sta		VECTORTABLE,y			; Store highbyte of new vector address in &0200 + Offset

	pla								; Pull highbyte of old Vector address from CPU Stack
	tax
	pla								; Pull lowbyte of old Vector address from CPU Stack

	rts								; return old vector address in AX
