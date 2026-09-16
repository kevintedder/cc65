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

	.importzp	c_sp, sreg, regsave
	.importzp	ptr1, ptr2, ptr3, ptr4
    .importzp	tmp1, tmp2, tmp3, tmp4
    .importzp	regbank

	.export		_paged_rom_ws
	.globalzp	_aws, _pws
	.globalzp	_Areg, _Xreg, _Yreg
	.exportzp	_OS_Areg, _OS_Xreg, _OS_Yreg, _cmd_ptr

	.import		decsp2, decsp4, incsp2, incsp4
	.import		_itoa, pushax, steax0sp

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

	.import		_claim_static_aws
	
	.import		_dbg_print_header
	.import		_dbg_print_nibble
	.import		_dbg_print_byte
	.import		_dbg_print_word
	.import		_dbg_print_long
	.import		_dbg_print_osbyte_registers
	.import		_dbg_print_cpu_registers
	.import		_dbg_print_workspace
	.import		_dbg_print_rom
	.import		_dbg_print_reg
	

	.import		_osbyte
	.import		OSWRCH
	.import		OSNEWL
	

	.export		__STARTUP__ : absolute = 1        ; Mark as startup
	.export		_SWR_Title, _SWR_Version

	.export		_service_routine_pre_call		
	.export		_service_routine_post_call
	.export		_issue_rom_service_call
	
; ------------------------------------------------------------------------
; BBC Sideways ROM runtime

	_paged_rom_ws = $0df0

; Define Zero Page labels for CC65 'C' language - these can be  
; moved within Page Zero if they clash with other services
.zeropage

;	Using Zeropage, reserved by BASIC for user space ($70 - $8F)
	_aws:		.res 2      ; 16 Bit pointer (&70/&71) to Absolute Workspace exported to 'C'
	_pws:		.res 2      ; 16 Bit pointer (&72/&73) to Private Workspace exported to 'C'

	_Areg:		.res 1		; 8 Bit - Save __A__ Reg during service call
	_Xreg:		.res 1		; 8 Bit - Save __A__ Reg during service call
	_Yreg:		.res 1		; 8 Bit - Save __A__ Reg during service call

;	OS Zeropage defined locations
	_OS_Areg	= $ef		; 8 Bit - Copy of __A__ reg for OSBYTE/OSWORD calls
	_OS_Xreg	= $f0		; 8 Bit - Copy of __X__ reg for OSBYTE/OSWORD calls
	_OS_Yreg	= $f1		; 8 Bit - Copy of __Y__ reg for OSBYTE/OSWORD calls
	_cmd_ptr	= $f2		; 16 Bit pointer to Cmd

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

;	On entry:   __A__	=	ROM Service Type requested
;				__X__	= 	Current ROM Number
;				__Y__	= 	Any parameter required for the service

;	To make these ROM services re-entrant

;	Save CPU registers
	sta		_Areg
	stx		_Xreg
	sty		_Yreg

; Call the requested service routine using the Service ID (CPU Reg __A__) 
; as the index into the Service Index Table above
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

	jmp		(ptr1)					; Call Service(x) indirectly

; ------------------------------------------------------------------------
; Define each service routine

_service0:									; Do nothing
	jmp		_service_no_op

_service1:									; stake a claim for Asbolute WorkSpace
	jsr		_service_claim_absolute_ws
	jmp		_restore_regs					; Restore current service call registers

_service2:									; Stake a claim for Private Workspace
	jsr		_service_claim_private_ws		; Set up PWS
	jmp		_restore_regs					; Restore current service call registers

_service3:									; Auto_Boot initialise
	jmp		_service_auto_boot

_service4:
	jmp		_service_unknown_command

_service5:
	jmp		_service_unknown_interrupt

_service6:
	jmp		_service_break 

_service7:
	jmp		_service_unknown_osbyte

_service8:
	jmp		_service_unknown_osword

_service9:
	jmp		_service_help

_service10:
	jsr		_service_release_static_ws
	jmp		_restore_regs					; Restore current service call registers

_service11:
	jmp		_service_nmi_release

_service12:
	jmp		_service_nmi_claim

_service13:
	jmp		_service_initilise_rom_fs

_service14:
	jmp		_service_rom_fs_get_byte

_service15:
	jmp		_service_vector_claim

_service16:
	jmp		_service_spool_closure

_service17:
	jmp		_service_font_explosion

_service18:
	jmp		_service_filesystem_init

_service19:
	jmp		_service_char_in_rs232_buffer

_service20:
	jmp		_service_char_in_print_buffer

_service21:
	jmp		_service_10hz_poll

_service22:
	jmp		_service_bell_request

_service23:
	jmp		_service_sound_buffer_purged

_service24:
	jmp		_service_interactive_help

_service25:
	jmp		_service_claim_aws_hazel

; ROM Services 26 - 32 do not exists. These call are moved to the end of this list.
_service26:
_service27:
_service28:
_service29:
_service30:
_service31:
_service32:

	jmp		_service_unknown

_service33:
	jmp		_service_claim_aws_hazel

_service34:
	jmp		_service_claim_pws_hazel

_service35:
	jmp		_service_top_aws_hazel

_service36:
	jmp		_service_request_pws_hazel

_service37:
	jmp		_service_return_filesys_info

_service38:
	jmp		_service_shut_issued

_service39:
	jmp		_service_reset_call

_service40:
	jmp		_service_unknown_conf_cmd

_service41:
	jmp		_service_unknown_status

_service42:
	jmp		_service_language_init

_service43:
	jmp		_service_swram_size

_service44:
	jmp		_service_joystick

_service45:
_service46:
_service47:

	jmp		_service_unknown


_service48_255:	
	lda		_Areg
	ldx		_Xreg

; ------------------------------------------------------------------------
_service254:
	cmp		#$FE					; Tube Post Initilisation
	bne		_service255

	jmp		_service_tube_post_init

; ------------------------------------------------------------------------
_service255:
	cmp		#$FF					; Tube Main Initilisation
	bne		_service_unknown

	jmp		_service_tube_main_init

_service_unknown:					; ROM Service call not identified
	rts

; ------------------------------------------------------------------------
_service_routine_pre_call:			
;	This routine go hand-in-hand with '_service_routine_post_call'.
;	Setup the CC65 'C' environment and prepare the A,X,Y parameter
;	on the C stack.

;	On entry:   _Areg	=	ROM Service Type requested
;				_Xreg	= 	Current ROM Number
;				_Yreg	= 	Any parameter required for the service

;	Claim AWS for this service call - all other ROMs shall release it
	jsr		_claim_static_aws

;	Prepare AWS pointer
 	lda		#$0e					; Set pointer to Absolute workspace
 	sta		_aws+1
 	lda		#$00
 	sta		_aws

; 	Prepare PWS pointer
	ldx		_Xreg					; Get ROM No
	lda		_paged_rom_ws,x			; Retrieve the PWS page address
	and		#$7f					; Mask out bit 2^7 (AWS owner)
	sta 	_pws + 1				; Set pointer to Private workspace
	lda		#$00
	sta 	_pws

;	Prepare C Stack pointer from PWS
	ldy		#$80						; Offset to PWS->c_stack_ptr
	lda		(_pws),y					; Load from PWS
	sta		c_sp						; Low Byte of C Stack
	lda		_pws+1
	sta		c_sp+1						; High Byte of C Stack

	rts								; Return - Next instruction will be JSR to service


; ------------------------------------------------------------------------
_service_routine_post_call:
;	Tidy up after calling service routine and restore regs __A__, __X__, __Y__
;	with the returned value from the called service in EAX (as a long).

;	On entry:   _Areg	=	ROM Service Type requested
;				_Xreg	= 	Current ROM Number
;				_Yreg	= 	Any parameter required for the service

;	Save C-Stack pointer to this ROMs PWS
	lda		c_sp						; Lower Byte of C Stack
	ldy		#$80						; Offset to PWS->c_stack_ptr
	sta		(_pws),y					; Save in PWS->c_stack_ptr

_restore_regs:

;	Restore CPU registers for service call
	lda		_Areg
	ldx		_Xreg
	ldy		_Yreg
	
	rts


; ------------------------------------------------------------------------
_issue_rom_service_call:
;									
;	On Entry:	;	__X__ = Service Call
;				;	__Y__ = Service Argument

;	push previously saved regs & __SP__ to CPU stack. Makes service ROM re-entrant

	lda		_Areg
	pha
	lda		_Xreg
	pha
	lda		_Yreg
	pha
	
	lda		#$8f					; Osbyte ROM service Requests
;	; ldx		#$00					; Service Request   - Preset by calling function
;	; ldy		#$00					; Service Argument  - Preset by calling function
	jsr     OSBYTE      			; Returned value in X(low) Y(High)

	pla
	sta		_Yreg
	pla
	sta		_Xreg
	pla
	sta		_Areg

;	Restore previous service call register. Makes Service ROM is re-entrant
	rts
