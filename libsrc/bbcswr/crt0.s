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
	.include	"bbcswr/swr.inc"	; This includes a Dummy ROM Title, override with new file in SAMPLES/BBCSWR

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
	.import		_service_release_static_ws
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
	.import		_service_char_in_rs232_buffer
	.import		_service_char_in_print_buffer
	.import		_service_10hz_poll
	.import		_service_bell_request
	.import		_service_sound_buffer_purged
	.import		_service_interactive_help
	.import		_service_claim_aws_hazel
	.import		_service_claim_pws_hazel
	.import		_service_top_aws_hazel
	.import		_service_request_pws_hazel
	.import		_service_return_filesys_info
	.import		_service_shut_issued
	.import		_service_reset_call
	.import		_service_unknown_conf_cmd
	.import		_service_unknown_status
	.import		_service_language_init
	.import		_service_swram_size
	.import		_service_joystick

	.import		_dbg_print_reg
	.import		pusha
	.import		OSWRCH, OSNEWL
	
	.import		decsp2, decsp4, incsp2, incsp4
	.import		_itoa, pushax, steax0sp
	; .import		_osbyte
	
	.export		__STARTUP__ : absolute = 1        ; Mark as startup
	.export		_SWR_Title, _SWR_Version
	.export		_paged_rom_ws
	; .export		_claim_static_workspace, _release_static_workspace
	; .export	_claim_vectors

	
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
	_aws		= $f8		; 16 Bit pointer (&f8/&f9) to Absolute Workspace exported to 'C'
	_pws		= $fa		; 16 Bit pointer (&fa/&fb) to Private Workspace exported to 'C'

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
									; refer to asminc/bbcswr/swr.inc


; .segment	"CODE"
; ------------------------------------------------------------------------
; A table of service routines used by the service entry point
_service_index_table:
	.addr		_service0			; 0x00 No Operation
	.addr		_service1			; 0x01 stake a claim for Asbolute WorkSpace
	.addr		_service2			; 0x02 Stake a claim for Private Workspace
	.addr		_service3			; 0x03 Auto_Boot initialise
	.addr		_service4			; 0x04 Unrecognised command
	.addr		_service5			; 0x05 Unrecognised interrupt
	.addr		_service6			; 0x06 process Break interrupt
	.addr		_service7			; 0x07 Unrecognised OSBYTE
	.addr		_service8			; 0x08 Unrecognised OSWORD
	.addr		_service9			; 0x09 Help command
	.addr		_service10			; 0x0A Claim absolute static workspace
	.addr		_service11			; 0x0B NMI release
	.addr		_service12			; 0x0C NMI Claim
	.addr		_service13			; 0x0D Initialise ROM filing system
	.addr		_service14			; 0x0E ROM filing systemget byte
	.addr		_service15			; 0x0F Claim vectors
	.addr		_service16			; 0x10 SPOOL/EXEC file closure
	.addr		_service17			; 0x11 Font implosion/explosion warning
	.addr		_service18			; 0x12 Initialise filing system
	.addr		_service19			; 0x13 char in rs232 buffer
	.addr		_service20			; 0x14 char in print buffer
	.addr		_service21			; 0x15 10hz poll
	.addr		_service22			; 0x16 bell request
	.addr		_service23			; 0x17 sound buffer purged
	.addr		_service24			; 0x18 interactive help
	.addr		_service25			; 0x19 claim aws hazel
	.addr		_service26			; 0x1A 
	.addr		_service27			; 0x1B
	.addr		_service28			; 0x1C
	.addr		_service29			; 0x1D
	.addr		_service30			; 0x1E
	.addr		_service31			; 0x1F
	.addr		_service32			; 0x20
	.addr		_service33			; 0x21 claim aws hazel
	.addr		_service34			; 0x22 claim pws hazel
	.addr		_service35			; 0x23 top aws hazel
	.addr		_service36			; 0x24 request pws hazel
	.addr		_service37			; 0x25 return filesys info
	.addr		_service38			; 0x26 shut issued
	.addr		_service39			; 0x27 reset call
	.addr		_service40			; 0x28 unknown conf cmd
	.addr		_service41			; 0x29 unknown status
	.addr		_service42			; 0x2A language init
	.addr		_service43			; 0x2B swram size
	.addr		_service44			; 0x2C joystick
	.addr		_service45			; 0x2D 
	.addr		_service46			; 0x2E 
	.addr		_service47			; 0x2F  
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

	cmp		#48						; Compare Service Call ID 
	bcc		_service0_48			;     < 48
	jmp		_service48_255			;     >= 48

_service0_48:

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
	; jsr		_initialise_stack_pointer	; C stack not required here
	jsr		_service_claim_absolute_ws
	jmp		_restore_regs			; Restore current service call registers
	; jmp		_service_routine_post_call

_service2:							; Stake a claim for Private Workspace
	; jsr		_initialise_stack_pointer	; C stack not required here
	jsr		_service_claim_private_ws
	jmp		_restore_regs			; Restore current service call registers
	; jmp		_service_routine_post_call

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
	jsr		_service_release_static_ws
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
	jsr		_service_routine_pre_call
	jsr		_service_char_in_rs232_buffer
	jmp		_service_routine_post_call

_service20:
	jsr		_service_routine_pre_call
	jsr		_service_char_in_print_buffer
	jmp		_service_routine_post_call

_service21:
	jsr		_service_routine_pre_call
	jsr		_service_10hz_poll
	jmp		_service_routine_post_call

_service22:
	jsr		_service_routine_pre_call
	jsr		_service_bell_request
	jmp		_service_routine_post_call

_service23:
	jsr		_service_routine_pre_call
	jsr		_service_sound_buffer_purged
	jmp		_service_routine_post_call

_service24:
	jsr		_service_routine_pre_call
	jsr		_service_interactive_help
	jmp		_service_routine_post_call

_service25:
	jsr		_service_routine_pre_call
	jsr		_service_claim_aws_hazel
	jmp		_service_routine_post_call

; ROM Services 26 - 32 do not exists. These call are moved to the end of this list.
;_service26:
;_service27:
;_service28:
;_service29:
;_service30:
;_service31:
;_service32:

_service33:
	jsr		_service_routine_pre_call
	jsr		_service_claim_aws_hazel
	jmp		_service_routine_post_call

_service34:
	jsr		_service_routine_pre_call
	jsr		_service_claim_pws_hazel
	jmp		_service_routine_post_call

_service35:
	jsr		_service_routine_pre_call
	jsr		_service_top_aws_hazel
	jmp		_service_routine_post_call

_service36:
	jsr		_service_routine_pre_call
	jsr		_service_request_pws_hazel
	jmp		_service_routine_post_call

_service37:
	jsr		_service_routine_pre_call
	jsr		_service_return_filesys_info
	jmp		_service_routine_post_call

_service38:
	jsr		_service_routine_pre_call
	jsr		_service_shut_issued
	jmp		_service_routine_post_call

_service39:
	jsr		_service_routine_pre_call
	jsr		_service_reset_call
	jmp		_service_routine_post_call

_service40:
	jsr		_service_routine_pre_call
	jsr		_service_unknown_conf_cmd
	jmp		_service_routine_post_call

_service41:
	jsr		_service_routine_pre_call
	jsr		_service_unknown_status
	jmp		_service_routine_post_call

_service42:
	jsr		_service_routine_pre_call
	jsr		_service_language_init
	jmp		_service_routine_post_call

_service43:
	jsr		_service_routine_pre_call
	jsr		_service_swram_size
	jmp		_service_routine_post_call

_service44:
	jsr		_service_routine_pre_call
	jsr		_service_joystick
	jmp		_service_routine_post_call


_service26:
_service27:
_service28:
_service29:
_service30:
_service31:
_service32:

_service45:
_service46:
_service47:


	jmp		_service_unknown


_service48_255:
	jsr		_restore_regs

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
	; jmp		_service_routine_post_call

_service_unknown:					; ROM Service call not identified
	jmp		_service_routine_post_call


; ------------------------------------------------------------------------
_service_routine_pre_call:			
;	This routine go hand-in-hand with '_service_routine_post_call'.
;	Setup the CC65 'C' environment and prepare the A,X,Y parameter
;	on the C stack.

;	On entry:    	Areg	=	ROM Service Type requested
;					Xreg 	= 	Current ROM Number
;					Yreg	= 	Any parameter required for the service
;					
	jsr		_service_claim_static_ws
	jsr		_initialise_aws_pointer
	jsr		_initialise_pws_pointer
	jsr		_initialise_stack_pointer

	; Prepare C stack using save reg values - Areg, Xreg, Yreg
	jsr     decsp2
	lda     _Areg
	tay
	sta     (c_sp),y				; Push Areg to C stack
	lda     _Xreg
	dey
	sta     (c_sp),y				; Push Xreg to C stack
	lda     _Yreg					; Leave Yreg in A as __fastcall__
									; Will be pushed to C stack by called function
	
	rts								; Return - Next instruction will be JSR to service

; ------------------------------------------------------------------------
_service_routine_post_call:
;	Tidy up after calling service routine and restore regs __A__, __X__, __Y__
;	with the returned value from the called service in EAX (as a long).

;						   |Sreg+1| Sreg | Xreg | Areg |
;	On Entry:		EAX	=  |0x00  | __Y__| __X__| __A__|

	jsr		_save_regs

	lda		_Areg
	jsr		_print_byte					; Print A
	lda		_Xreg
	jsr		_print_byte					; Print X
	lda		_Yreg
	jsr		_print_byte					; Print Y
	jsr		OSNEWL
	
	jsr		_restore_regs

	ldy		sreg					; Set Y - 3rd Byte of EAX 

	rts


_nibble:
.byte		"0123456789ABCDEF", $00

_print_nibble:
	lda		_nibble,x
	jsr		OSWRCH
	rts

_print_byte:
	pha

	lda		#'0'
	jsr		OSWRCH
	lda		#'x'
	jsr		OSWRCH

	pla
	pha
	lsr		a
	lsr		a
	lsr		a
	lsr		a
	tax
	jsr		_print_nibble

	pla
	and		#$0f
	tax
	jsr		_print_nibble
	
	lda		#' '
	jsr		OSWRCH
	

; ------------------------------------------------------------------------
_initialise_aws_pointer:			; Set Pointer to Work Space (AWS/PWS).

 	lda		#$0e					; Set pointer to Absolute workspace
 	sta		_aws+1
 	lda		#$00
 	sta		_aws

	rts

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
;	### BE CAREFUL ### 
;	Avoid too many function call levels. The depth may corrupt the stack
;	### BE CAREFUL ### 

; 	Set the 'C' stack pointer to $0e7f (First 128 bytes of AWS)
	lda		_aws+1						; Use the lower 128 byte of the AWS
	sta		c_sp+1
	lda		#$7f						; Use the lower 128 byte of the AWS
	sta		c_sp

	rts

; ------------------------------------------------------------------------
; _claim_vectors:						; Claim vectors
	; ldx		#$0f					; Service Request - Claim Vectors
	; ldy		#$00					; Argument is null
	; jmp     _issue_rom_service_call

; ------------------------------------------------------------------------
; _issue_rom_service_call:
;									; On Entry:
;									;	__X__ = Service Call
;									;	__Y__ = Service Argument

	; jsr		_push_saved_regs		; push previously saved regs & __SP__ to CPU stack. Make service ROM re-entrant

	; lda		#$8f					; Osbyte ROM service Requests
;	; ldx		#$00					; Service Request   - Preset by calling function
;	;ldy		#$00					; Service Argument  - Preset by calling function
	; jsr     OSBYTE      			; Returned value in X(low) Y(High)

	; jsr		_pull_saved_regs		; Restore previous service call register. Service ROM is re-entrant
	; rts

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
; _push_saved_regs:
	; sta		tmp4					; Save __A__ reg temporarily

	; pla								; Adjust return address on CPU stack
	; sta		ptr1
	; pla
	; sta		ptr1+1

	; lda		_Areg
	; pha
	; lda		_Xreg
	; pha
	; lda		_Yreg
	; pha
;	; lda		c_sp						; push C stack pointer to CPU stack
;	; pha
;	; lda		c_sp+1
;	; pha

	; lda		ptr1+1					; push return address back on CPU stack
	; pha
	; lda		ptr1
	; pha

	; lda		tmp4					; restore __A__
	; rts								; Return using the adjusted Stack Address

;------------------------------------------------------------------------
; _pull_saved_regs:
	; sta		tmp4					; Save __A__ reg temporarily

	; pla								; Adjust return address on CPU stack
	; sta		ptr1
	; pla
	; sta		ptr1+1

;	; pla
;	; sta		c_sp+1					; Restore original C stack Pointer
;	; pla
;	; sta		c_sp

	; pla
	; sta		_Yreg
	; pla
	; sta		_Xreg
	; pla
	; sta		_Areg

	; lda		ptr1+1					; push return address back on CPU stack
	; pha
	; lda		ptr1
	; pha

	; lda		tmp4					; restore __A__
	; rts								; Return using the adjusted Stack Address

