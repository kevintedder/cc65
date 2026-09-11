;
; Ullrich von Bassewitz, 25.10.2000
;
; CC65 runtime: Decrement the stackpointer by <Tmp>
;

        .export         decsp2, decsp3, decsp4, decsp5, decsp6, decsp7, decsp8
        .importzp       c_sp, tmp1


.proc   decsp2

	lda		#2
	sta		tmp1
	jmp		decsp

.endproc

.proc   decsp3

	lda		#3
	sta		tmp1
	jmp		decsp

.endproc

.proc   decsp4

	lda		#4
	sta		tmp1
	jmp		decsp

.endproc

.proc   decsp5

	lda		#5
	sta		tmp1
	jmp		decsp

.endproc

.proc   decsp6

	lda		#6
	sta		tmp1
	jmp		decsp

.endproc

.proc   decsp7

	lda		#7
	sta		tmp1
	jmp		decsp

.endproc

.proc   decsp8

	lda		#8
	sta		tmp1
	jmp		decsp

.endproc



.proc   decsp
;	On Entry	tmp1 = decrement count

        lda     c_sp
        sec						; Set Carry Flag
        sbc     tmp1
        sta     c_sp
        bcs     @L1				; Carry Flag still set, no borrow
		dec     c_sp+1			; Carry Borrowed, decrement highbyte

@L1:
        rts
		
		
		
; ---- Orignal ----
        ; bcc     @L1
        ; rts

; @L1:    dec     c_sp+1
        ; rts
; ---- Orignal ----

.endproc




