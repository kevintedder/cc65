
	.export	preservezp, restorezp
	.import		subysp
	.import		addysp
	.include	"zeropage.inc"
	
	.code
	
;	Push 26 zero page bytes onto C stack

preservezp:
	ldy	#zpspace						; make room on the stack
	jsr	subysp							; Allocate <zpsace> bytes on the C stack
	
	ldy	#zpspace-1
	
preserveloop:							; copy zpspace to C stack
	lda	c_sp, y							; ??? c_sp always first in zp?
	sta	(c_sp), y	
	dey
	bpl	preserveloop
	
	rts

;	Pull 26 zero page bytes from C stack

restorezp:
	ldy	#zpspace-1
	
restoreloop:							; Copy C stack to zpspace
	lda	(c_sp), y
	sta	c_sp, y
	
	dey
	bpl	restoreloop
	
	ldy	#zpspace
	jsr	addysp							; Remove <zpsace> bytes off the C stack
	rts
 