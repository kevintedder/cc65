;
; int printf (const char* Format, ...);
;
; Ullrich von Bassewitz, 1.12.2000
;

        .export         _printf
        .import         _stdin,_stdout,_stderr, pushax, addysp, _vfprintf, __filetab
        .importzp       sp, ptr1

        .macpack        generic

	.import		_print_byte, _print_word, _print_swr
        .import         OSWRCH, OSNEWL
        .include        "_file.inc"
        .include        "fcntl.inc"

; ----------------------------------------------------------------------------
.data

ParamSize:      .res    1               ; Number of parameter bytes

; ----------------------------------------------------------------------------
.code

_printf:
;                               On entry:
;                                       SP -> va_list / Format String

        sty     ParamSize       ; Number of param bytes passed in Y


;	### NEW ###
	pha
        txa
        pha

	lda	#'A'
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



; We are using a (hopefully) clever trick here to reduce code size. On entry,
; the stack pointer points to the last pushed parameter of the variable
; parameter list. Adding the number of parameter bytes, would result in a
; pointer that points *after* the Format parameter.
; Since we have to push stdout anyway, we will do that here, so
;
;   * we will save the subtraction of 2 (__fixargs__) later
;   * we will have the address of the Format parameter which needs to
;     be pushed next.
;

; Push file descriptor (_stdout) to 'C' stack
        lda     #<__filetab
        ldx     #>__filetab+1
        jsr     _print_word

        lda     #<_stdin
        ldx     #>_stdin+1
        jsr     _print_word

        lda     #<_stdout
        ldx     #>_stdout+1
        jsr     _print_word

        lda     #<_stderr
        ldx     #>_stderr+1
        jsr     _print_word

        jsr     OSNEWL

        lda     #<_stdout
        ldx     #>_stdout+1
        jsr     pushax

; Now calculate the va_list pointer, which does points to Format

        lda     sp              ; Get the 'C' Stack pointer
        ldx     sp+1

;       ### NEW ###
        clc
        adc     ParamSize       ; increment by paramsize
;        add     ParamSize
;       ### NEW ###

        bcc     @L1
        inx                     ; Carry overflow - increment __X__

@L1:    sta     ptr1            ; pointer to format string param (Pointer)
        stx     ptr1+1

; Push Format String

        ldy     #1
        lda     (ptr1),y        ; High byte of pointer to Format String
        tax
        dey                     ; __Y__ - 1 = 0
        lda     (ptr1),y        ; Low byte of pointer to Format String
        jsr     pushax          ; Push Format string pointer to 'C' stack

; Load va_list (last and __fastcall__ parameter to vfprintf)

        lda     ptr1            ; Load pointer to format string
        ldx     ptr1+1

; Call vfprintf

        jsr     _vfprintf

; Cleanup the stack. We will return what we got from vfprintf

        ldy     ParamSize
        jmp     addysp

