#ifndef bbc_cmds_H
#define bbc_cmds_H

#include <bbc/osbyte.h>
#include <bbc/osword.h>
#include <bbc/oswrch.h>
#include <bbc/osmode.h>

#define BYTEHIGH(v)   (*(((unsigned char *) (&v) + 1)))
#define BYTELOW(v)    (*((unsigned char *) (&v)))

int get_osbyte(byte _cmd) {
  return osbyte(_cmd, 0x00, 0xFF );
}
int set_osbyte(byte _cmd, byte _value) {
  return osbyte(_cmd, _value, 0x00 );
}

int get_oshwm() {
  return get_osbyte(131) * 256;
}
int set_oshwm(byte _value) {
  return set_osbyte(131, _value);
}

int get_oshimem() {
  return get_osbyte(132) * 256;
}
int set_oshimem(byte _value) {
  return set_osbyte(132, _value);
}

long get_system_time() {
  osword(1, &osword_parameter_block);
  return osword_parameter_block.timer.time;
}
long set_system_time(long _time ) {
  osword_parameter_block.timer.time = _time;
  osword(2, &osword_parameter_block);
  return osword_parameter_block.timer.time;
}

long get_interval_timer() {
  osword(3, &osword_parameter_block);
  return osword_parameter_block.timer.time;
}
long set_interval_timer(long _time ) {
  osword_parameter_block.timer.time = _time;
  osword(4, &osword_parameter_block);
  return osword_parameter_block.timer.time;
}

long future_time;
void sleep(int _delay) {
  future_time = get_system_time() + _delay;         // Set delay in centi-seconds (1/100)th
  while (get_system_time() < future_time) {  }
}

void envelope(byte _number, byte _length ,
              byte _pi1, byte _pi2, byte _pi3,
              byte _pn1, byte _pn2, byte _pn3,
              byte _aa, byte _ad, byte _as, byte _ar,
              byte _ala, byte _ald ) {

  osword_parameter_block.envelope.number  = _number;
  osword_parameter_block.envelope.length  = _length;
  osword_parameter_block.envelope.pi1     = _pi1;
  osword_parameter_block.envelope.pi2     = _pi2;
  osword_parameter_block.envelope.pi3     = _pi3;
  osword_parameter_block.envelope.pn1     = _pn1;
  osword_parameter_block.envelope.pn2     = _pn2;
  osword_parameter_block.envelope.pn3     = _pn3;
  osword_parameter_block.envelope.aa      = _aa;  
  osword_parameter_block.envelope.ad      = _ad;  
  osword_parameter_block.envelope.as      = _as;  
  osword_parameter_block.envelope.ar      = _ar;  
  osword_parameter_block.envelope.ala     = _ala;  
  osword_parameter_block.envelope.ald     = _ald;  

  osword(8, &osword_parameter_block);
}

void sound(int _channel, int _amplitude, int _pitch, int _duration){
  osword_parameter_block.sound.channel = _channel;
  osword_parameter_block.sound.amplitude = _amplitude;
  osword_parameter_block.sound.pitch = _pitch;
  osword_parameter_block.sound.duration = _duration;

  osword(7, &osword_parameter_block);
}
/*
void print_timer(union osword_parameter_block* param_block) {
    printf("T1:0x%04X\t%d\r\n", param_block->timer.time, param_block->timer.time );
//    printf("T2:0x%04X\t%d\r\n", param_block->timer.time2, param_block->timer.time2 );
}
*/
void print_block(char _header[] , union osword_parameter_block* param_block) {
  int z;
  printf("%s ", _header);
  for(z=0; z < 8; z++) {
    printf("%02X ", param_block->bytes.b[z] );
  }
  printf("\r\n");
}

#endif

