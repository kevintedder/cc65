/*****************************************************************************/
/*                                                                           */
/*                       sideways_rom header file                            */
/*                                                                           */
/*    This header file contains the data declarations for the SWR to         */
/*    during and service routine                                             */
/*                                                                           */
/*                                                                           */
/* (C) 2025  Kevin Tedder                                                    */
/*                                                                           */
/* Versions:                                                                 */
/* 01/06/2025   v1.0    -   First release                                    */
/*                                                                           */
/*                                                                           */
/*                                                                           */
/* This software is provided 'as-is', without any expressed or implied       */
/* warranty.  In no event will the authors be held liable for any damages    */
/* arising from the use of this software.                                    */
/*                                                                           */
/* Permission is granted to anyone to use this software for any purpose,     */
/* including commercial applications, and to alter it and redistribute it    */
/* freely, subject to the following restrictions:                            */
/*                                                                           */
/* 1. The origin of this software must not be misrepresented; you must not   */
/*    claim that you wrote the original software. If you use this software   */
/*    in a product, an acknowledgment in the product documentation would be  */
/*    appreciated but is not required.                                       */
/* 2. Altered source versions must be plainly marked as such, and must not   */
/*    be misrepresented as being the original software.                      */
/* 3. This notice may not be removed or altered from any source              */
/*    distribution.                                                          */
/*                                                                           */
/*****************************************************************************/

#ifndef SWR_H
#define SWR_H

#include <bbc/types.h>

// User defined struct of the Absolute Work Space. 
// Transient variable data should be declare within here. Always call 
// claim_absolute_static_workspace() before each service call. It cannot
// be guarenteed to remain valid between service calls.
struct aws {
	byte	tmp1;
	byte	tmp2;
	word	tmp3;
	word	tmp4;
	byte	padding[255 - 6];	// Padding to the nearest 255 Byte (1 x Page). Optional

	// Total = 255 Byte (1 x Page)
};								// Allocated to BSS Segment in page 0x0e00 (see BBCSWR.CFG)

// User defined struct of the Private Work Space. 
// Permanent variable data should be declare within here. Data is guarenteed
// to remain valid between service calls.
struct pws {
	byte	c_stack[128];		// First 128 Bytes reserved for C Stack use during ROM service call.  DO NOT CHANGE
	byte	c_stack_ptr;		// reserved for current stack offset within c_stack for this ROM.   DO NOT CHANGE

//	User space - May be freely declared 
	byte	tmp1;
	byte	tmp2;
	word	tmp3;
	word	tmp4;
	byte	padding[127 - 8];	// Padding to the nearest 255 Byte (1 x Page). Optional
	
	// Total = 255 Byte (1 x Page)
};

//  ##################################################
//  ### External Data structures defined in CRT0.S ###
//  ##################################################

extern struct aws *aws;			// Absolute workspace requires X pages (see 'struct aws' above)
#pragma zpsym ("aws");			// aws is in the zeropage

extern struct pws *pws;			// Private workspace requires X pages (see 'struct pws' above)
#pragma zpsym ("pws");			// pws is in the zeropage

extern byte   Areg;             // __A__ register saved on entry to service call
#pragma zpsym ("Areg");         // Areg is in the zeropage

extern byte   Xreg;             // __X__ register saved on entry to service call
#pragma zpsym ("Xreg");         // Xreg is in the zeropage

extern byte   Yreg;             // __Y__ register saved on entry to service call
#pragma zpsym ("Yreg");         // Yreg is in the zeropage

extern byte   OS_Areg;          // OSBYTE A register saved on entry to service call
#pragma zpsym ("OS_Areg");      // Areg is in the zeropage

extern byte   OS_Xreg;          // OSBYTE X register saved on entry to service call
#pragma zpsym ("OS_Xreg");      // Xreg is in the zeropage

extern byte   OS_Yreg;          // OSBYTE Y register saved on entry to service call
#pragma zpsym ("OS_Yreg");      // Yreg is in the zeropage

extern char*  cmd_ptr;          // cmd_ptr pointer to command text
#pragma zpsym ("cmd_ptr");      // cmd_ptr is in the zeropage

extern const char SWR_Title[];    // Define the ROM Title
extern const char SWR_Version[];  // & version number

#define newline "\r\n"


extern byte paged_rom_ws[];


//  ##################################################
//  ### External routines defined in CRT0.S        ###
//  ##################################################
void service_no_op();                   // Do nothing, but allows you to do something
void service_claim_absolute_ws();
void service_claim_private_ws();
void service_auto_boot( );
void service_unknown_command();
void service_unknown_interrupt();
void service_break();
void service_unknown_osbyte();
void service_unknown_osword();
void service_help();
void service_claim_static_ws();
void service_nmi_release();
void service_nmi_claim();
void service_initilise_rom_fs();
void service_rom_fs_get_byte();
void service_vector_claim();
void service_spool_closure();
void service_font_explosion();
void service_filesystem_init();
void service_tube_post_init();
void service_tube_main_init();
void service_char_in_rs232_buffer();
void service_char_in_print_buffer();
void service_10hz_poll();
void service_bell_request();
void service_sound_buffer_purged();
void service_interactive_help();
void service_claim_aws_hazel();
void service_claim_aws_hazel();
void service_claim_pws_hazel();
void service_top_aws_hazel();
void service_request_pws_hazel();
void service_return_filesys_info();
void service_shut_issued();
void service_reset_call();
void service_unknown_conf_cmd();
void service_unknown_status();
void service_language_init();
void service_swram_size();
void service_joystick();

extern void claim_static_aws();
extern void issue_rom_service_call();
extern void service_routine_pre_call();			
extern void service_routine_post_call();

void print_rom_title();

int __fastcall__ strcmp_cr (const char* s1, const char* s2);


//  #############################################################################
//  ###                       P R I N T _ L I T E ( )                         ###
//  ###                                                                       ###
//  ###   A lightweight print function for cc65 for BBC sideways ROM          ###
//  ###                                                                       ###
//  ###   A ROM is limited to 16KBytes in size. The printf() takes up too     ###
//  ###   much room so this smaller print() function has been developed       ###
//  ###                                                                       ###
//  #############################################################################

extern void swr_print_str( char* str );
extern void swr_print_newline();
extern void swr_print_space(int count);

extern char* intdec( int value, char * str );
extern char* inthex( int value, char * str );



#endif
