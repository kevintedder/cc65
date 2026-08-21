/*****************************************************************************/
/*    'C' Header                                                             */
/*                        C A L L B A C K ( )                                */
/*                                                                           */
/*    The standard callback mechanism (*func_ptr)(param1, param2) uses       */
/*    the DATA segment of RAM to hold a JMP $<addr> instruction. The         */
/*    <addr> is modified and a JSR calls it. Since this code resides         */
/*    in ROM this mechanism cannot be used.                                  */
/*                                                                           */
/*    This callback() function modifies the Page Zero Tmp1..3 to store       */
/*    the JMP $<addr> instruction and a JSR calls it.                        */
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

#ifndef SWR_CALLBACK_H
#define SWR_CALLBACK_H

extern void swr_callback();

#endif
