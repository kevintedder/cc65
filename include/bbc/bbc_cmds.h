#ifndef bbc_cmds_H
#define bbc_cmds_H

#include <bbc/types.h>

#define BYTEHIGH(v)   (*(((unsigned char *) (&v) + 1)))
#define BYTELOW(v)    (*((unsigned char *) (&v)))

// int get_osbyte(byte _cmd);
// int set_osbyte(byte _cmd, byte _value);
unsigned int get_oshwm();
unsigned int set_oshwm(byte _value);
unsigned int get_oshimem();
unsigned int set_oshimem(byte _value);
unsigned long get_system_time();
unsigned long set_system_time(long _time );
unsigned long get_interval_timer();
unsigned long set_interval_timer(long _time );
void sleep(int _delay);

void envelope(byte _number, byte _length ,
              byte _pi1, byte _pi2, byte _pi3,
              byte _pn1, byte _pn2, byte _pn3,
              byte _aa, byte _ad, byte _as, byte _ar,
              byte _ala, byte _ald );

void sound(int _channel, int _amplitude, int _pitch, int _duration);

// void print_timer(union osword_parameter_block* param_block) {
// void print_block(char _header[] , union osword_parameter_block* param_block);

#endif

