;
; Ullrich von Bassewitz, 2002-12-16
;
; Signal vector table
;

        .export         sigtable

        .include        "signal.inc"

;----------------------------------------------------------------------------
;

.data

sigtable:
        .word   ___sig_dfl		; SIGABRT	Abort signal
        .word   ___sig_dfl		; SIGFPE	Erroneous arithmetic operation
        .word   ___sig_dfl		; SIGILL	Illegal Instruction
        .word   ___sig_dfl		; SIGINT	Interrupt from keyboard
        .word   ___sig_dfl		; SIGSEGV	Invalid memory reference
        .word   ___sig_dfl		; SIGTERM	Termination signal


