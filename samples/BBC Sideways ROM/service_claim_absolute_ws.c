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


#define configure_aws           // Optional - If defined, include code to claim Absolute workspace

// struct aws aws;                 // declare uninitialised variable, from /include/bbcswr/swr.h,  in
                                // segment BSS @ 0x0e00.  All ROM variables must be placed in
                                // here. No access outside the AWS is permitted.
//  Reference all ROM variables as :
//      aws->tmp1;
//      aws->tmp2;
//      etc ...


void service_claim_absolute_ws() {
    byte ws;

    // print_lite( "claim_absolute_ws " );
    // print_newline();
    // print_cpu_registers();
    // print_workspace();

#ifdef configure_aws
    ws = 0x0e + ( sizeof(struct aws) / 256 ) + 1;   // Start with OSHWM + size of AWS in 256 byte pages + 1
    if ( ws > Yreg ) {
        Yreg = ws;
    }
#endif

    // print_cpu_registers();
}


