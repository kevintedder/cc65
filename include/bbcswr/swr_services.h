/*****************************************************************************/
/*                                                                           */
/*                    sideways_rom service routines                          */
/*                                                                           */
/*    This header file contains print routines for the sole purpose to       */
/*    debug the code during development. It should be removed from the       */
/*    before being released.                                                 */
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


#ifndef SWR_SERVICES_H
#define SWR_SERVICES_H

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


#endif
