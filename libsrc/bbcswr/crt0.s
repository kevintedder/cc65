; /*****************************************************************************/
; /*                                                                           */
; /*                Startup code for cc65 for BBC sideways ROM                 */
; /*                                                                           */
; /*        This must be the *first* file on the linker command line           */
; /*                                                                           */
; /*  All service routines must be declare as:                                 */
; /*      void __fastcall__ <service_routine>();                               */
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

	.include	"bbc/os.inc"
	.include	"swr.inc"

	.import		_service_no_op
	.import		_service_claim_absolute_ws
	.import		_service_claim_private_ws
	.import		_service_auto_boot
	.import		_service_unknown_command
	.import		_service_unknown_interrupt
	.import		_service_break
	.import		_service_unknown_osbyte
	.import		_service_unknown_osword
	.import		_service_help
	.import		_service_claim_static_ws
	.import		_service_nmi_release
	.import		_service_nmi_claim
	.import		_service_initilise_rom_fs
	.import		_service_rom_fs_get_byte
	.import		_service_vector_claim
	.import 	_service_spool_closure
	.import		_service_font_explosion
	.import		_service_filesystem_init
	.import		_service_tube_post_init
	.import		_service_tube_main_init

	.import		decsp2, decsp4, incsp2, incsp4
	.import		_itoa, pushax, steax0sp
	.import		_osbyte
	
 	.export		_exit_bits
	.export		__STARTUP__ : absolute = 1        ; Mark as startup
	.export		_SWR_Title, _SWR_Version
	.export		_paged_rom_ws
	.export		_claim_absolute_static_workspace, _release_absolute_static_workspace, _claim_vectors

	
	.importzp	c_sp, sreg, regsave
	.importzp	ptr1, ptr2, ptr3, ptr4
    .importzp	tmp1, tmp2, tmp3, tmp4
    .importzp	regbank

	.exportzp	_aws, _pws
	.exportzp	_Areg, _Xreg, _Yreg
	.exportzp	_OS_Areg, _OS_Xreg, _OS_Yreg, _cmd_ptr

; ------------------------------------------------------------------------
; BBC Sideways ROM runtime

; Define Zero Page labels for CC65 'C' language - these can be  
; moved within Page Zero if they clash with other services

;	Using Zeropage $f8 - $fb ; OS temporaray workspace
	_aws		= $f8		; 16 Bit pointer to Absolute Workspace exported to 'C'
	_pws		= $fa		; 16 Bit pointer to Private Workspace exported to 'C'

;	OS Zeropage general workspace
	_Areg		= $e4		; 8 Bit - Save __A__ Reg during service call
	_Xreg		= $e5		; 8 Bit - Save __X__ Reg during service call
	_Yreg		= $e6		; 8 Bit - Save __Y__ Reg during service call

;	OS Zeropage defined locations
	_OS_Areg	= $ef		; Copy of __A__ reg for OSBYTE/OSWORD calls
	_OS_Xreg	= $f0		; Copy of __X__ reg for OSBYTE/OSWORD calls
	_OS_Yreg	= $f1		; Copy of __Y__ reg for OSBYTE/OSWORD calls
	_cmd_ptr	= $f2		; 16 Bit pointer to Cmd

	_paged_rom_ws = $0df0


; ------------------------------------------------------------------------
;	
.segment	"STARTUP"

.org 		$8000					; Set Sideways Rom start address

langauge:
	jmp		_Language_Entry			; Langauge Entry Point

service:
	jmp		_service_entry_point


; ------------------------------------------------------------------------
; Define ROM header - must be included in this
; segment for Beeb OS to recognise this ROM.


SWR_HEADER							; Macro to define this ROM's identity


; .segment	"CODE"
; ------------------------------------------------------------------------
; A table of service routines used by the service entry point
_service_index_table:
	.addr		_service0			; No Operation
	.addr		_service1			; stake a claim for Asbolute WorkSpace
	.addr		_service2			; Stake a claim for Private Workspace
	.addr		_service3			; Auto_Boot initialise
	.addr		_service4			; Unrecognised command
	.addr		_service5			; Unrecognised interrupt
	.addr		_service6			; process Break interrupt
	.addr		_service7			; Unrecognised OSBYTE
	.addr		_service8			; Unrecognised OSWORD
	.addr		_service9			; Help command
	.addr		_service10			; Claim absolute static workspace
	.addr		_service11			; NMI release
	.addr		_service12			; NMI Claim
	.addr		_service13			; Initialise ROM filing system
	.addr		_service14			; ROM filing systemget byte
	.addr		_service15			; Claim vectors
	.addr		_service16			; SPOOL/EXEC file closure
	.addr		_service17			; Font implosion/explosion warning
	.addr		_service18			; Initialise filing system
	; .addr		_service19
	; .addr		_service20
	; .addr		_service21
	; .addr		_service22
	; .addr		_service23
	; .addr		_service24
	; .addr		_service25
	; .addr		_service26
	; .addr		_service27
	; .addr		_service28
	; .addr		_service29
	; .addr		_service30
	; .addr		_service31

	.addr		_service254			; TUBE port initialisation
	.addr		_service255			; TUBE main initialisation


; ------------------------------------------------------------------------
_Language_Entry:
;	No langauge defined
	rts

; ------------------------------------------------------------------------
_service_entry_point:
									; On entry, 
									;	__A__ = service ID, 
									;	__X__ = ROM number, 
									;	__Y__ = parameter (if necessary)

; Call the requested service routine using the Service ID as 
; an index into the Service Index Table above

	jsr		_save_regs				; Preserve Reg __A__, __X__, __Y__ to page zero throughout service call

	cmp		#32						; Compare Service Call ID 
	bcc		_service0_31			;     < 32
	jmp		_service32_255			;     >= 32

_service0_31:

	asl		a 						; Multiply by 2, point into 16-bit address table
	tax								; Move Service ID to X
	lda		_service_index_table,x
	sta		ptr1					; Store Address of Service(x) at
	lda		_service_index_table+1,x
	sta		ptr1+1					; temp Page Zero Address

	; jsr		_restore_regs
	jmp		(ptr1)					; Call Service(x) indirectly

; ------------------------------------------------------------------------
; Define each service routine

_service0:							; Do nothing
	jsr		_service_no_op
	jmp		_service_routine_post_call

_service1:							; stake a claim for Asbolute WorkSpace
	jsr		_initialise_stack_pointer
	jsr		_service_claim_absolute_ws
	jmp		_service_routine_post_call

_service2:							; Stake a claim for Private Workspace
	jsr		_initialise_stack_pointer
	jsr		_service_claim_private_ws
	jmp		_service_routine_post_call

_service3:							; Auto_Boot initialise
	jsr		_service_routine_pre_call
	jsr		_service_auto_boot
	jmp		_service_routine_post_call

_service4:
	jsr		_service_routine_pre_call
	jsr		_service_unknown_command
	jmp		_service_routine_post_call

_service5:
	jsr		_service_routine_pre_call
	jsr		_service_unknown_interrupt
	jmp		_service_routine_post_call

_service6:
	jsr		_service_routine_pre_call
	jsr		_service_break 
	jmp		_service_routine_post_call

_service7:
	jsr		_service_routine_pre_call
	jsr		_service_unknown_osbyte
	jmp		_service_routine_post_call

_service8:
	jsr		_service_routine_pre_call
	jsr		_service_unknown_osword
	jmp		_service_routine_post_call

_service9:
	jsr		_service_routine_pre_call
	jsr		_service_help
	jmp		_service_routine_post_call

_service10:
	jsr		_service_routine_pre_call
	jsr		_service_claim_static_ws
	jmp		_service_routine_post_call

_service11:
	jsr		_service_routine_pre_call
	jsr		_service_nmi_release
	jmp		_service_routine_post_call

_service12:
	jsr		_service_routine_pre_call
	jsr		_service_nmi_claim
	jmp		_service_routine_post_call

_service13:
	jsr		_service_routine_pre_call
	jsr		_service_initilise_rom_fs
	jmp		_service_routine_post_call

_service14:
	jsr		_service_routine_pre_call
	jsr		_service_rom_fs_get_byte
	jmp		_service_routine_post_call

_service15:
	jsr		_service_routine_pre_call
	jsr		_service_vector_claim
	jmp		_service_routine_post_call

_service16:
	jsr		_service_routine_pre_call
	jsr		_service_spool_closure
	jmp		_service_routine_post_call

_service17:
	jsr		_service_routine_pre_call
	jsr		_service_font_explosion
	jmp		_service_routine_post_call

_service18:
	jsr		_service_routine_pre_call
	jsr		_service_filesystem_init
	jmp		_service_routine_post_call

_service19:
_service20:
_service21:
_service22:
_service23:
_service24:
_service25:
_service26:
_service27:
_service28:
_service29:
_service30:
_service31:
	jmp		_service_unknown


_service32_255:

; ------------------------------------------------------------------------
_service254:
	cmp		#$FE					; Tube Post Initilisation
	bne		_service255

	jsr		_service_routine_pre_call
	jsr		_service_tube_post_init
	jmp		_service_routine_post_call

; ------------------------------------------------------------------------
_service255:
	cmp		#$FF					; Tube Main Initilisation
	bne		_service_unknown

	jsr		_service_routine_pre_call
	jsr		_service_tube_main_init
	jmp		_service_routine_post_call

_service_unknown:					; ROM Service call not identified
	jmp		_service_routine_post_call

_exit_bits:
	rts

; ------------------------------------------------------------------------
_service_routine_pre_call:			;	Setup the CC65 'C' environment

;	ldx		_Xreg					; Get ROM No
;	lda		_paged_rom_ws,x			; Retrieve the PWS page address
;	and		#$80					; Mask out bits 2^6 ... 2^0
;	bne		_service_routine_pre_call_2	; Skip if Bit 2^7 = 1 since we already own the AWS
;										; there no need to set up the pointers again

	jsr		_initialise_aws_pointer
	jsr		_initialise_pws_pointer
	jsr		_initialise_stack_pointer

_service_routine_pre_call_2:
	rts
	;jmp		_restore_regs

; ------------------------------------------------------------------------
_initialise_aws_pointer:			; Set Pointer to Work Space (AWS/PWS).

 	lda		#$0e					; Set pointer to Absolute workspace
 	sta		_aws+1
 	lda		#$00
 	sta		_aws

; 	rts

; ------------------------------------------------------------------------
_initialise_pws_pointer:			; Set Pointer to Work Space (AWS/PWS).

	ldx		_Xreg					; Get ROM No
	lda		_paged_rom_ws,x			; Retrieve the PWS page address
	and		#$7f					; Mask out bit 2^7 (AWS owner)
	sta 	_pws + 1
	lda		#$00					; Set pointer to Private workspace
	sta 	_pws

	rts

; ------------------------------------------------------------------------
_initialise_stack_pointer:
;	Let's be cheeky and use the lower 64 bytes of Page $0100 (CPU Stack) 
;	for the 'C' Stack starting @ 0x0140.
;	### BE CAREFUL ### 
;	Avoid too many function call levels. The depth may corrupt the stack
;	### BE CAREFUL ### 

; 	Set the 'C' stack pointer to $0140
	lda		#$40					; Use the lowest 64 byte of the CPU Stack
	sta		c_sp
	lda		#$01					; Page 0x01 - CPU Stack
	sta		c_sp+1

	rts

; ------------------------------------------------------------------------
_service_routine_post_call:			; Tidy up after calling service routine and 
									; restore regs __A__, __X__, __Y__	

	jmp		_restore_regs			; Restore current service call registers

; ------------------------------------------------------------------------
_claim_vectors:						; Claim vectors
	ldx		#$0f					; Service Request - Claim Vectors
	ldy		#$00					; Argument is null
	jsr     _issue_rom_service_call
	rts

; ------------------------------------------------------------------------
_claim_absolute_static_workspace:	; Claim ownership of Absolute Work Space (AWS)
									; Set flag to indicate I now own the AWS
	ldx		_Xreg					; Use ROM No as index
	lda		_paged_rom_ws,x			; Get Saved ROM workspace ID
	ora		#$80					; Set AWS Owner flag (Bit 2^7).
	sta		_paged_rom_ws,x

	ldx		#$0a					; Service Request - Claim Static Workspace
	ldy		#$00					; Argument is null
	jsr		_issue_rom_service_call
	rts

; ------------------------------------------------------------------------
_release_absolute_static_workspace:	; Release ownership of Absolute Work Space (AWS)
									; Clear flag to indicate I now no longer own the AWS
	ldx		_Xreg					; Use ROM No as index
	lda		_paged_rom_ws,x			; Get Saved ROM workspace ID
	and		#$7f					; Clear AWS Owner flag (Bit 2^7).
	sta		_paged_rom_ws,x
	rts

; ------------------------------------------------------------------------
_issue_rom_service_call:
;									; On Entry:
;									;	__X__ = Service Call
;									;	__Y__ = Service Argument

	jsr		_push_saved_regs		; push previously saved regs & __SP__ to CPU stack. Make service ROM re-entrant

	lda		#$8f					; Osbyte ROM service Requests
;	ldx		#$00					; Service Request   - Preset by calling function
;	ldy		#$00					; Service Argument  - Preset by calling function
	jsr     OSBYTE      			; Returned value in X(low) Y(High)

	jsr		_pull_saved_regs		; Restore previous service call register. Service ROM is re-entrant
	rts

; ------------------------------------------------------------------------
_save_regs:							; Save CPU registers to Page zero
    sta		_Areg
	stx		_Xreg
	sty		_Yreg
	rts

; ------------------------------------------------------------------------
_restore_regs:						; Restore CPU Registers from Page Zero
	lda		_Areg
	ldx		_Xreg
	ldy		_Yreg
	rts

; ------------------------------------------------------------------------
_push_saved_regs:
	sta		tmp4					; Save __A__ reg temporarily

	pla								; Adjust return address on CPU stack
	sta		ptr1
	pla
	sta		ptr1+1

	lda		_Areg
	pha
	lda		_Xreg
	pha
	lda		_Yreg
	pha
	; lda		c_sp						; push C stack pointer to CPU stack
	; pha
	; lda		c_sp+1
	; pha

	lda		ptr1+1					; push return address back on CPU stack
	pha
	lda		ptr1
	pha

	lda		tmp4					; restore __A__
	rts								; Return using the adjusted Stack Address

; ------------------------------------------------------------------------
_pull_saved_regs:
	sta		tmp4					; Save __A__ reg temporarily

	pla								; Adjust return address on CPU stack
	sta		ptr1
	pla
	sta		ptr1+1

	; pla
	; sta		c_sp+1					; Restore original C stack Pointer
	; pla
	; sta		c_sp

	pla
	sta		_Yreg
	pla
	sta		_Xreg
	pla
	sta		_Areg

	lda		ptr1+1					; push return address back on CPU stack
	pha
	lda		ptr1
	pha

	lda		tmp4					; restore __A__
	rts								; Return using the adjusted Stack Address

