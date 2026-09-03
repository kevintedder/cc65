#ifndef osgraphics_H
#define osgraphics_H

#include <bbc/types.h>

extern void mode(byte _mode);
extern void clg();
extern void cls();
extern void colour(byte _colour );
extern void gcol(byte _k, byte _colour );
extern void default_colours ( void );
extern void plot(byte _k, int _x, int _y);
extern void graphics_window( unsigned int _left, unsigned int _bottom, unsigned int _right, unsigned int _top );

#endif

