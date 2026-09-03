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

void print_osbyte() {
	char buf[12];
	
	swr_print_str( "osbyte " );
	swr_print_str( intdec( OS_Areg, buf ) );
	swr_print_str( "," );
	swr_print_str( intdec( OS_Xreg, buf ) );
	swr_print_str( "," );
	swr_print_str( intdec( OS_Yreg, buf ) );
	swr_print_newline();
}

void service_unknown_osbyte() {

    // swr_print_str( "unknown_osbyte " );
    // swr_print_newline();
    // dbg_print_cpu_registers();
    // dbg_print_osbyte_registers();

    // --------------------------------//
    // PLACE YOUR CODE HERE            //
    // --------------------------------//

	switch ( OS_Areg ) {
		
		case 22:
			print_osbyte();
			aws->tmp1 = 10;
			Areg = 0;                       // Prevent further ROMs from processing this cmd
			break;
			
		case 23:
			print_osbyte();
			aws->tmp1 = 20;
			Areg = 0;                       // Prevent further ROMs from processing this cmd
			break;

		case 24:
			print_osbyte();
			aws->tmp1 = 30;
			Areg = 0;                       // Prevent further ROMs from processing this cmd
			break;
			
	}

}

