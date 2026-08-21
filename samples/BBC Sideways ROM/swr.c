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
#include <bbc/swr_print_lite.h>
#include <bbc/swr.h>
#include <bbc/swr_debug.h>
#include <bbc/types.h>


//	Use of CONST qualifier forces data in RODATA segment for Sideways ROM


// const char swr_title[] = "CC65-SWR";    // Define the ROM Title
// const char swr_version[] = "v0.03";     // & version number

//  ##################################################
//  ### ROM utility routines                       ###
//  ##################################################

void print_rom_title() {
    swr_print_str( (char*) SWR_Title );
    swr_print_space(1);
    swr_print_str( (char*) SWR_Version );
    swr_print_newline();
    swr_print_newline();
}

