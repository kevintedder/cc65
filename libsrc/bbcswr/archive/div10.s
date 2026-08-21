
	.setcpu		"6502"
	.importzp	tmp1, tmp2, tmp3, tmp4
	.export		_div10


_div10:

.segment	"CODE"
;
; unsigned int div10( unsigned int num) {
;
    sta tmp1        ; Store num in tmp1/tmp2
    sta tmp3        ; Store result in tmp3/tmp4
    stx tmp1+1
    stx tmp3+1

    asl tmp3
    rol tmp3+1      ;result = 2*num

    asl tmp3
    rol tmp3+1      ;result = 4*num

    clc
    lda tmp1
    adc tmp3
    sta tmp3

    lda tmp1+1
    adc tmp3+1
    sta tmp3+1      ;result = 5*num

    asl tmp3
    rol tmp3+1      ;result = 10*num

    lda tmp3
    ldx tmp3+1

    rts
