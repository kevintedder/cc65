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

#include <bbc/osbyte.h>
#include <bbcswr/swr_print_lite.h>
#include <bbcswr/swr.h>
#include <bbcswr/swr_debug.h>
#include <bbcswr/types.h>


void service_claim_static_ws() {
	
//	DO NOT CHANGE - No local variables declared.  This code is written so as not to use 
//					the C stack whilst the ROM initialises PWS

	if ( ( paged_rom_ws[Xreg] & 0x80 ) != 0x0 ) {	// Is this ROM the AWS Owner

		// AWS Owner?  No

		//  Use OS_Areg as a temporary store for Paged ROM setting
		OS_Areg = paged_rom_ws[Xreg] | 0x80;	// Set Bit 7 = Claim AWS Owner
		paged_rom_ws[Xreg] = OS_Areg;

		asm("lda	#143");
		asm("ldx	#10");
		asm("ldy	#0");
		asm("jsr 	$fffe");
		
		paged_rom_ws[Xreg] = OS_Areg;
	}

	// AWS Owner?  Yes


#ifdef SWR_DEBUG
	dbg_print_rom();
#endif

}

void service_release_static_ws() {
	OS_Areg = paged_rom_ws[Xreg] & 0x7f;	// Set Bit 7 = Claim AWS Owner
	paged_rom_ws[Xreg] = OS_Areg;

}
