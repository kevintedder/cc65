/*****************************************************************************/
/*                                                                           */
/*                                                                           */
/*****************************************************************************/
#include <stdio.h>
#include <stdlib.h>
#include <bbc/bbc.h>
#include <bbc/bbc_cmds.h>
#include <bbc/osgraphics.h>

// unsigned long random() {
		// return ( rand() * 0x10000 ) + rand();
// }	

void print_sys_time() {
	unsigned long sys_time;
	int hours, minutes, seconds;
	
	sys_time = get_system_time() / 100;
	srand( sys_time );
	hours	= sys_time / 3600;
	minutes = (sys_time / 60) % 60;
	seconds	= sys_time % 60;
	printf( "System Time: %02u:%02u:%02u\r\n", hours, minutes, seconds );
}

// void test1() {
	// int i;
	
	// union rnd_seed {
		// unsigned long rnd;
		// char bytes[4];		
	// } rnd_seed;

	// for( i = 0; i < 24; i++) {
		// rnd_seed.rnd = random();
		// printf("%2i %14lu  -  0x%02x 0x%02x 0x%02x 0x%02x \r\n", i, rnd_seed.rnd, rnd_seed.bytes[3], rnd_seed.bytes[2], rnd_seed.bytes[1], rnd_seed.bytes[0] );
	// }
	// printf("\r\n");
// }

void test2() {
	int i;
	int xpos, ypos;

	graphics_window( 150, 100, 1100, 400 );
	gcol( 0, COLOUR_BG_BLUE );
	clg();
	
	// sleep( 200 );
	
	for( i = 0; i < 100; i++) {
		xpos = rand() % 1280;
		ypos = rand() % 1024;
		
		gcol( 3, rand() % 8 );
		
		plot( 85 , xpos, ypos );
	}
}


void main(void) {
	unsigned long proc_begin, proc_end;
	unsigned int page, himem;
	
	// mode(2);
	
	// Initialise Random Seed 
	srand( get_system_time() );

	print_sys_time();

	page = get_oshwm();
	himem = get_oshimem();
	printf("Page : 0x%4x, %5u\r\n", page, page );
	printf("Himem: 0x%4x, %5u\r\n", himem, himem );
	printf("RAM  : 0x%4x, %5u\r\n", himem - page, himem - page );
	

	proc_begin = get_system_time();
	test2();	
	proc_end   = get_system_time();
	printf("Duration: %8lu\r\n", proc_end - proc_begin );
}
