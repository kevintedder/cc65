/*****************************************************************************/
/*                                                                           */
/*             S I D E W A Y S   R O M   C O M M A N D S                     */
/*                                                                           */
/* Define the command to be used by this Sideways ROM                        */
/*                                                                           */
/* Each command is defined by:                                               */
/* 		const char cmd1[]  = "F1";		// The name of the command           */
/* 		const char desc1[] = "abc";		// A desciption of the command       */
/* 		void func1() {					// The function to be called         */
/* 			swr_print_str("func1");                                          */
/* 			swr_print_newline();                                             */
/*		}                                                                    */
/*                                                                           */
/* Include each command in the struct cmd array                              */
/* 		const struct cmd commands[cmd_count] = {                             */
/* 						{ cmd1, desc1, func1 },                              */
/*      }                                                                    */
/*                                                                           */
/* //	###  Update the cmd_count in swr_cmds.h ###                          */
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

#include <bbc/swr_print_lite.h>
#include <bbc/swr.h>
#include <bbc/swr_cmds.h>
#include <bbc/swr_debug.h>
#include <bbc/types.h>

/*
	Use of CONST qualifier forces data in RODATA segment for Sideways ROM
*/

const char cmd1[]  = "F1";
const char desc1[] = "abc";
void func1() {
	swr_print_str("func1");
	swr_print_newline();
}

const char cmd2[]  = "F2";
const char desc2[] = "def";
void func2() {
	swr_print_str("func2");
	swr_print_newline();
}

const char cmd3[]  = "F3";
const char desc3[] = "ghi";
void func3() {
	swr_print_str("func3");
	swr_print_newline();
}

const char cmd4[]  = "F4";
const char desc4[] = "ghi";
void func4() {
	swr_print_str("func4");
	swr_print_newline();
}

const char cmd5[]  = "F5";
const char desc5[] = "ghi";
void func5() {
	swr_print_str("func5");
	swr_print_newline();
}


/*
// Extend <N> for more commands 
const char cmd<N>[]  = "F<N>";
const char desc<N>[] = "ghi";
void func<N>() {
	swr_print_str("func<N>");
	swr_print_newline();
}

//	###  Update the cmd_count in swr_cmds.h ###
*/

const struct cmd commands[cmd_count] = { 
				{ cmd1, desc1, func1 }, 
				{ cmd2, desc2, func2 }, 
				{ cmd3, desc3, func3 }, 
				{ cmd4, desc4, func4 }, 
				{ cmd5, desc5, func5 }
};


