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

#include <bbcswr/bbcswr.h>
#include <bbcswr/bbcswr_debug.h>
#include <bbcswr/types.h>


void service_release_static_ws() {

//	On entry:   Areg	=	ROM Service Type requested
//				Xreg	= 	Current ROM Number
//				Yreg	= 	Any parameter required for the service

#ifdef BBCSWR_DEBUG
	swr_print_str( "service_release_static_ws:Begin" );
	swr_print_newline();
	dbg_print_rom();
#endif

	paged_rom_ws[Xreg] = paged_rom_ws[Xreg] & 0x7f;			// Clear Bit 7 = Release AWS Ownership

#ifdef BBCSWR_DEBUG
	swr_print_str( "service_release_static_ws:End" );
	swr_print_newline();
#endif

}


void claim_static_aws() {

//	On entry:   Areg	=	ROM Service Type requested
//				Xreg	= 	Current ROM Number
//				Yreg	= 	Any parameter required for the service

#ifdef BBCSWR_DEBUG
	swr_print_str( "claim_static_aws:Begin" );
	swr_print_newline();
	dbg_print_rom();
#endif

//	DO NOT CHANGE - No local variables declared.  This code is written so as not to use 
//					the C stack whilst the ROM initialises AWS

	if ( ( paged_rom_ws[Xreg] & 0x80 ) == 0x0 ) {	// Is this ROM the AWS Owner?

		// AWS Owner?  No
		
#ifdef BBCSWR_DEBUG
		swr_print_str( "Issue ROM service:Begin" );
		swr_print_newline();
#endif

		asm("ldx	#$0a");									// Service call - Claim Static AWS
		asm("ldy	#0");
		asm("jsr 	_issue_rom_service_call");

#ifdef BBCSWR_DEBUG
		swr_print_str( "Issue ROM service:End" );
		swr_print_newline();
#endif
		
		paged_rom_ws[Xreg] = paged_rom_ws[Xreg] | 0x80;		// Set Bit 7 = Claim AWS Ownership

	}

	// AWS Owner?  Yes - already 

#ifdef BBCSWR_DEBUG
	swr_print_str( "claim_static_aws:End" );
	swr_print_newline();
#endif

}
