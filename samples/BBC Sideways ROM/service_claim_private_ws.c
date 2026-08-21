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

#include <bbc/swr_print_lite.h>
#include <bbc/swr.h>
#include <bbc/swr_debug.h>
#include <bbc/types.h>


#define configure_pws           // Optional - If defined, include code to claim Private workspace


void service_claim_private_ws() {
    // print_lite( "claim_private_ws" );
    // print_newline();
    // print_cpu_registers();
    // print_workspace();

#ifdef configure_pws
    Yreg += ( sizeof(struct pws) / 256 ) + 1;   // Struct pws declared in /include/bbc/swr.h
    paged_rom_ws[Xreg] = Yreg;          // Save PWS pointer into Paged ROM Workspace Storage @ 0x0df0
    pws = Yreg * 256;                   // Define how many pages required for private workspace
#endif

    // print_cpu_registers();
}

