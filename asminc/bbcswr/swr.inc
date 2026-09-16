
; ------------------------------------------------------------------------
; Define ROM header - must be included in this
; segment for Beeb OS to recognise this ROM.

.macro  SWR_HEADER

_SWR_Romtype:
	.byte	$80						; Bit 7 = 1 - Service Entry present
									; Bit 6 = 0 - No Langauge present

_SWR_Copyright_Offset:
	.byte	_SWR_Copyright - $8000

_SWR_Binary_Ver:
	.byte	$00

_SWR_Title:
	.byte	"CC65 Dummy", $00			; Adjust this Title to suit

_SWR_Version:
	.byte	"v0.00", $00		; Adjust this Version to suit

_SWR_Copyright:
	.byte	$00, "(C)"

_SWR_Copyright_Str:
	.byte	"2025 ", $00
;	.byte	"Copyright(c) 2025 ", $00

_SWR_2nd_Proc:
	.byte	$00, $00

.endmacro

