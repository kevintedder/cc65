; vfprintf.s
;
; int fastcall vfprintf(FILE* f, const char* Format, va_list ap);
;
; 2005-02-08, Ullrich von Bassewitz
; 2005-02-11, Greg King

        .export         _vfprintf
        .import         push1, pushwysp, incsp6
        .import         _fwrite, __printf
        .importzp       sp, ptr1

        .macpack        generic

	.import		_print_byte, _print_word, _print_swr
        .import         OSWRCH, OSNEWL

; ----------------------------------------------------------------------------
.data

; Static data for the _vfprintf routine
;
outdesc:                                ; Static outdesc structure
ccount:         .res    2
outfunc:        .word   out             ; Points to output function (out:)
ptr:            .res    2               ; Points to output file descriptor
                .res    2               ; (Not used by this function)

; ----------------------------------------------------------------------------
.code

; Callback routine used for the actual output.
;
; Since we know, that this routine is always called with "our" outdesc, we
; can ignore the passed pointer d, and access the data directly. While this
; is not very clean, it gives better and shorter code.
;
; static void cdecl out (struct outdesc* d, const char* buf, unsigned count)
; /* Routine used for writing */
; {
;     register size_t cnt;
;
;     /* Write to the file */
;     if ((cnt = fwrite(buf, 1, count, ptr)) == 0) {
;         ccount = -1;
;     } else {
;         ccount += cnt;
;     }
; }

; About to call
;
;       fwrite (buf, 1, count, ptr);
;
out:
;	### NEW ###
	pha
        txa
        pha

	lda	#'D'
	jsr 	OSWRCH

        lda     ccount
        ldx     ccount+1
        jsr     _print_word

        lda     outfunc
        ldx     outfunc+1
        jsr     _print_word

        lda     ptr
        ldx     ptr+1
        jsr     _print_word

        jsr     OSNEWL

        pla
        tax
	pla
;	### NEW ###

        ldy     #5
        jsr     pushwysp        ; Push buf
        jsr     push1           ; Push #1
        ldy     #7
        jsr     pushwysp        ; Push count
        lda     ptr
        ldx     ptr+1

        jsr     _fwrite

        sta     ptr1            ; Save function result
        stx     ptr1+1

; Check the return value.

        ora     ptr1+1
        bne     @Ok

; We had an error. Store -1 into ccount

.ifp02
        lda     #<-1
.else
        dec     a
.endif
        sta     ccount
        bne     @Done           ; Branch always

; Result was ok, count bytes written

@Ok:    lda     ptr1
        add     ccount
        sta     ccount
        txa
        adc     ccount+1
@Done:  sta     ccount+1
        jmp     incsp6          ; Drop stackframe


; ----------------------------------------------------------------------------
; vfprintf - formatted output
;
; int fastcall vfprintf(FILE* f, const char* format, va_list ap)
; {
;     static struct outdesc d = {
;         0,
;         out
;     };
;
;     /* Setup descriptor */
;     d.ccount = 0;
;     d.ptr  = f;
;
;     /* Do formatting and output */
;     _printf (&d, format, ap);
;
;     /* Return bytes written */
;     return d.ccount;
; }
;
_vfprintf:
;                               On entry:
;                                        __AX__ = pointer to param list
;                                       SP -> Format String / File descriptor / va_list
;                                       PTR1 -> Format String

        pha                     ; Save low byte of ap

;	### NEW ###
	pha
        txa
        pha

	lda	#'B'
	jsr 	OSWRCH

        ldy     #1
        lda     (sp),y
        tax
        dey
        lda     (sp),y
        jsr     _print_word

        ldy     #3
        lda     (sp),y
        tax
        dey
        lda     (sp),y
        jsr     _print_word

        ldy     #5
        lda     (sp),y
        tax
        dey
        lda     (sp),y
        jsr     _print_word

        jsr     OSNEWL

        pla
        tax
	pla
;	### NEW ###



; Setup the outdesc structure

        lda     #0
        sta     ccount
        sta     ccount+1        ; Clear character-count

; Reorder the stack. Replace f on the stack by &d, so the stack frame is
; exactly as _printf expects it. Parameters will get dropped by _printf.

;                               __Y__ = 0,1 - offset to format string (skip)

        ldy     #2
        lda     (sp),y          ; Low byte of file descriptor @ SP[2]
        sta     ptr             ; Save in Output Descriptor (ptr)

        lda     #<outdesc
        sta     (sp),y          ; Replace with Pointer to Output descriptor           
        
        iny                     ; __Y__ = #3
        lda     (sp),y          ; High byte of file descriptor @ SP[3]
        sta     ptr+1           ; Save in Output Descriptor (ptr)
        
        lda     #>outdesc
        sta     (sp),y          ; Replace with Pointer to Output descriptor

        lda     #<out           ; Set Output descriptor Function
        sta     outfunc
        lda     #>out
        sta     outfunc+1




;	### NEW ###
	pha
        txa
        pha

	lda	#'B'
	jsr 	OSWRCH

        ldy     #3
        lda     (sp),y
        tax
        dey
        lda     (sp),y

        jsr     _print_word

        jsr     OSNEWL

        pla
        tax
	pla
;	### NEW ###




; Restore low byte of ap and call _printf

        pla
        jsr     __printf

; Return the number of bytes written

        lda     ccount
        ldx     ccount+1
        rts


