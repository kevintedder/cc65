/*****************************************************************************/
/*                                                                           */
/*                                sideways_rom.c                             */
/*                                                                           */
/*                Define a BBC sideways ROM framework Header                 */
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

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <bbcswr/swr_print_lite.h>
#include <bbcswr/swr.h>
#include <bbcswr/swr_debug.h>
#include <bbcswr/types.h>
#include <bbcswr/swr_cmds.h>



void service_help() {
    char* help_cmd;
	int cmd_idx = 0;
    
    claim_absolute_static_workspace();      // I need the AWS so claim it.

    // --------------------------------//
    // PLACE YOUR CODE HERE            //
    // --------------------------------//

    help_cmd = &cmd_ptr[Yreg];                   // cmd pointers to the start of the command string

    if ( help_cmd[0] == 0x0d ) {                 // No command supplied
        print_rom_title();
    }
    else {

        if ( strcmp_cr( help_cmd, SWR_Title ) == 0 ) {
            print_rom_title();

 			for( cmd_idx = 0; cmd_idx < cmd_count; cmd_idx++ ) {
				swr_print_space(1);
				swr_print_str( commands[cmd_idx].command );
				swr_print_space(1);
				swr_print_str( commands[cmd_idx].description );
				swr_print_newline();
			}

            Areg = 0;                       // Prevent further ROMs from processing this cmd
        }

	}
}
