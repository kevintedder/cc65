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
#include <bbcswr/swr_debug.h>
#include <bbcswr/types.h>

void service_filesystem_init() {

#ifdef SWR_DEBUG
	swr_print_str( "service_filesystem_init:Begin" );
	swr_print_newline();
	dbg_print_rom();
#endif

	service_routine_pre_call();			

    // --------------------------------//
    // PLACE YOUR CODE HERE            //
    // --------------------------------//



    // --------------------------------//
    // PLACE YOUR CODE ABOVE           //
    // --------------------------------//

	service_routine_post_call();

#ifdef SWR_DEBUG
	swr_print_str( "service_filesystem_init:End" );
	swr_print_newline();
#endif
}

