#ifndef osword_H
#define osword_H

typedef struct osword_block osword_block;
struct osword_block {
  byte b [8];
};

typedef struct osword_timer_block osword_timer_block;
struct osword_timer_block {
  long time;
  byte time2;
};

typedef struct osword_sound_block osword_sound_block;
struct osword_sound_block {
  int channel;
  int amplitude;
  int pitch;
  int duration;
};

typedef struct osword_envelope_block osword_envelope_block;
struct osword_envelope_block {
  byte number;
  byte length;
  byte pi1;
  byte pi2;
  byte pi3;
  byte pn1;
  byte pn2;
  byte pn3;
  byte aa;
  byte ad;
  byte as;
  byte ar;
  byte ala;
  byte ald;
};

union osword_parameter_block {
  struct osword_block bytes;
  struct osword_timer_block timer;
  struct osword_sound_block sound;
  struct osword_envelope_block envelope;
} osword_parameter_block;

extern int osword( byte A, union osword_parameter_block* param_block );

#endif


