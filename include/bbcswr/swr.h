/*****************************************************************************/
/*                                                                           */
/*                       sideways_rom header file                            */
/*                                                                           */
/*    This header file contains the data declarations for the SWR to         */
/*    during and service routine                                             */
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

#ifndef SWR_H
#define SWR_H

#include <bbc/types.h>

// User defined struct of the Absolute Work Space. 
// Transient variable data should be declare within here. Always call 
// claim_absolute_static_workspace() before each service call. It cannot
// be guarenteed to remain valid between service calls.
struct aws {
	byte	reserved[128];		// First 128 Bytes reserved for C Stack use during ROM service call.  DO NOT CHANGE
	
    byte	tmp1;
    byte	tmp2;
    word	tmp3;
    word	tmp4;
	
    byte	padding[128 - 6];	// Total = 255 Byte (1 x Page)	
};								// Allocated to BSS Segment in page 0x0e00 (see BBCSWR.CFG)

// User defined struct of the Private Work Space. 
// Permanent variable data should be declare within here. Data is guarenteed
// to remain valid between service calls.
struct pws {
    byte    tmp1;
    byte    tmp2;
    word    tmp3;
    word    tmp4;
    byte  padding[251];         
	
	// Total = 255 Byte (1 x Page)
};


extern struct aws *aws;			// Absolute workspace requires X pages (see 'struct aws' above)
#pragma zpsym ("aws");			// aws is in the zeropage

extern struct pws *pws;			// Private workspace requires X pages (see 'struct pws' above)
#pragma zpsym ("pws");			// pws is in the zeropage

extern byte   Areg;             // __A__ register saved on entry to service call
#pragma zpsym ("Areg");         // Areg is in the zeropage

extern byte   Xreg;             // __X__ register saved on entry to service call
#pragma zpsym ("Xreg");         // Xreg is in the zeropage

extern byte   Yreg;             // __Y__ register saved on entry to service call
#pragma zpsym ("Yreg");         // Yreg is in the zeropage

extern byte   OS_Areg;          // OSBYTE A register saved on entry to service call
#pragma zpsym ("OS_Areg");      // Areg is in the zeropage

extern byte   OS_Xreg;          // OSBYTE X register saved on entry to service call
#pragma zpsym ("OS_Xreg");      // Xreg is in the zeropage

extern byte   OS_Yreg;          // OSBYTE Y register saved on entry to service call
#pragma zpsym ("OS_Yreg");      // Yreg is in the zeropage

extern char*  cmd_ptr;          // cmd_ptr pointer to command text
#pragma zpsym ("cmd_ptr");      // cmd_ptr is in the zeropage

extern const char SWR_Title[];    // Define the ROM Title
extern const char SWR_Version[];  // & version number

#define newline "\r\n"


//  ##################################################
//  ### External routines defined in CRT0.S        ###
//  ##################################################
void print_rom_title();

extern byte paged_rom_ws[];

extern byte _OS_Areg;

extern void claim_static_workspace();
extern void release_static_workspace();
extern void claim_vectors();

int __fastcall__ strcmp_cr (const char* s1, const char* s2);


#endif
