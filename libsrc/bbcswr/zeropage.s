;
; Ullrich von Bassewitz, 26.05.2002
;
; CC65 runtime: zeropage usage
;
; Specifically for the BBCSWR target

.include        "zeropage.inc"

; ------------------------------------------------------------------------

.zeropage
;   Address $90 - $9f
c_sp:           .res    2       ; Stack pointer
sreg:           .res    2       ; Secondary register/high 16 bit for longs
ptr1:           .res    2
ptr2:           .res    2
ptr3:           .res    2
ptr4:           .res    2
tmp1:           .res    1
tmp2:           .res    1
tmp3:           .res    1
tmp4:           .res    1

.segment "ZEROPAGE2": zeropage
;   Address $b0 - $bf
regsave:        .res    4       ; Slot to save/restore (E)AX into
regbank:        .res    regbanksize     ; Register bank
