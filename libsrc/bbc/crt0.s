;
; Startup code for cc65 (bbc normal library - not ROM)
;
; This must be the *first* file on the linker command line
;

	.import		initlib, donelib
    .import		zerobss
	.import		callmain	
	.import		preservezp, restorezp
	.import		_raise

	.import		disable_cursor_edit
	.import		restore_cursor_edit
	.import		init_stack
	; .import 	init_fp_rom

	; .import		brkret
	; .import		trap_brk, release_brk
	.import		_eventinitialise, _eventterminate
	.import		_brkinitialise, _brkterminate
	.import		_enable_event, _disable_event

	.export		__Cstart, __Cend
    .export		_exit

    .export		__STARTUP__ : absolute = 1      ; Mark as startup
		
	.include "zeropage.inc"
	.include "bbc/os.inc"
	.include "bbc/osbyte.inc"

	
	.bss
oldeventv:	.res	2
oldescen:	.res	1	; was escape event enabled before?
save_s:	.res	1		; save CPU stack pointer before entering main
						; exit can be called from any level!


.segment	"STARTUP"

__Cstart:							; C code starts here

reset:
	jsr		zerobss
	jsr		disable_cursor_edit
	jsr		init_stack
	
;	jsr		init_fp_rom 				; Find and save BASIC rom slot

	sei									; disable interrupts while we setup the vectors	jsr		_eventinitialise			; setup new EVENTV 
	jsr		_eventinitialise			; Setup new EVENTV handler
	jsr		_brkinitialise				; Setup new BRK handler
	cli
	
	ldx		#EVNTV_ESCAPE 				; enable escape event
	jsr		_enable_event

	; ldx		#EVNTV_CHAR_INPUT 			; enable escape event
	; jsr		_enable_event
	
	jsr		initlib						; Initialize library modules

	tsx
	stx		save_s		

	
	jsr		callmain					;  Call C main() function


__Cend:									; C code ends here

	ldx		save_s						; force return to OS
	txs

	jsr     donelib						; Cleanup library modules

	ldx		#EVNTV_ESCAPE				; disable escape event
	jsr		_disable_event

	; ldx		#EVNTV_CHAR_INPUT 			; enable escape event
	; jsr		_disable_event

	sei									; disable interrupts while we setup the vectors
	jsr		_brkterminate				; Restore original BRK handler
	jsr		_eventterminate				; Restore original EVENTV handler
	cli									; reenable interrupts

	jsr		restore_cursor_edit

_exit:
	rts

