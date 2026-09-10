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
#include <bbcswr/swr_cmds.h>
#include <bbcswr/swr_callback.h>
#include <bbcswr/swr_debug.h>
#include <bbcswr/types.h>

long service_unknown_command( byte A, byte X, byte Y ) {
	int cmd_idx = 0;
    char *cmd_str;
	
    // --------------------------------//
    // PLACE YOUR CODE BELOW           //
    // --------------------------------//

#ifdef SWR_DEBUG
    swr_print_str( SERVICE_NAME );
	dbg_print_byte( A );
    swr_print_newline();
#endif

    cmd_str = &cmd_ptr[Y];							// cmd pointers to the start of the command string
	
	for( cmd_idx = 0; cmd_idx < cmd_count; cmd_idx++ ) {
				
		if (  strcmp_cr( cmd_str, commands[cmd_idx].command ) == 0  ) {
			// Command recognised

			swr_callback( commands[cmd_idx].func );	// Call the recognised command

			A = 0;                   		    	// Prevent further ROMs from processing this cmd
			break;
		}
	}
	
    // --------------------------------//
    // PLACE YOUR CODE ABOVE           //
    // --------------------------------//

	return  (long)( (long)Y << 16 )  + ( (int)X << 8 ) + A;	// Return the values of A, X, Y
}


// void test() {
	// long t;
	// byte a,x,y;

	// t = service_unknown_command( 1,2,3);
	
	// a = t % 256;
	// x = (t / 256) % 256;
	// y = (t /65563) % 256;
	
// }