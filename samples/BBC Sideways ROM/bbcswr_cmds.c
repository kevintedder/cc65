/*****************************************************************************/
/*                                                                           */
/*             S I D E W A Y S   R O M   C O M M A N D S                     */
/*                                                                           */
/* Define the commands to be used by this Sideways ROM                       */
/*                                                                           */
/* Each command is defined by:                                               */
/* 		const char cmd1[]  = "F1";		// The name of the command           */
/* 		const char desc1[] = "abc";		// A desciption of the command       */
/* 		void func1() {					// The function to be called         */
/* 			## Command Code here  ##                                         */
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

#include <bbcswr/bbcswr.h>
#include <bbcswr/bbcswr_cmds.h>
#include <bbcswr/bbcswr_debug.h>
#include <bbc/types.h>

void func1() {
	swr_print_str("Cmd: Func 1");
	swr_print_newline();
}

void func2() {
	swr_print_str("Cmd: Func 2");
	swr_print_newline();
}

void func3() {
	swr_print_str("Cmd: Func 3");
	swr_print_newline();
}

void func4() {
	swr_print_str("Cmd: Func 4");
	swr_print_newline();
}

void func5() {
	swr_print_str("Cmd: Func 5");
	swr_print_newline();
}

//	###  Update the cmd_count in swr_cmds.h ###

/*
	Use of CONST qualifier forces data in RODATA segment for Sideways ROM
*/
//					Command, Description, Callback Function
const struct cmd commands[] = { 
							{ "F1", "abc", func1 },
							{ "F2", "def", func2 },
							{ "F3", "ghi", func3 },
							{ "F4", "jkl", func4 },
							{ "F5", "mno", func5 }
};
