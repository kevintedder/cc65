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


#include <bbcswr/bbcswr.h>
#include <bbcswr/bbcswr_cmds.h>
#include <bbcswr/swr_callback.h>
#include <bbcswr/bbcswr_debug.h>
#include <bbcswr/types.h>

void service_unknown_command() {

//	On entry:   Areg	=	ROM Service Type requested
//				Xreg	= 	Current ROM Number
//				Yreg	= 	Any parameter required for the service


	int cmd_idx = 0;
	char *cmd_str;
	
 
#ifdef BBCSWR_DEBUG
	swr_print_str( "service_unknown_command:Begin" );
	swr_print_newline();
	dbg_print_rom();
#endif

	service_routine_pre_call();			

	// --------------------------------//
    // PLACE YOUR CODE BELOW           //
    // --------------------------------//

    cmd_str = &cmd_ptr[Yreg];						// cmd pointers to the start of the command string
	
	for( cmd_idx = 0; cmd_idx < cmd_count; cmd_idx++ ) {
				
		if (  strcmp_cr( cmd_str, commands[cmd_idx].command ) == 0  ) {

			// Command recognised
			swr_callback( commands[cmd_idx].func );	// Call the recognised command

			Areg = 0;                   		    // Prevent further ROMs from processing this cmd
			break;
		}
	}
	
    // --------------------------------//
    // PLACE YOUR CODE ABOVE           //
    // --------------------------------//


#ifdef BBCSWR_DEBUG
	swr_print_str( "service_unknown_command:End" );
	swr_print_newline();
#endif

	service_routine_post_call();

}
