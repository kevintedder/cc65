/*****************************************************************************/
/*    'C' Header                                                             */
/*                        P R I N T _ L I T E ( )                            */
/*                                                                           */
/*    A lightweight print function for cc65 for BBC sideways ROM             */
/*                                                                           */
/*    A ROM is limited to 16KBytes in size. The printf() takes up too        */
/*    much room so this smaller print() function has been developed          */
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

#ifndef PRINT_LITE_H
#define PRINT_LITE_H

extern void swr_print_str( char* str );
extern void swr_print_newline();
extern void swr_print_space(int count);

extern char* intdec( int value, char * str );
extern char* inthex( int value, char * str );

#endif