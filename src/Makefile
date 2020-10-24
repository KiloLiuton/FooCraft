CFLAGS = -Wall -g -std=c11 -fPIC -c
INCLUDE = ../godot_headers/

simple:
	gcc $(CFLAGS) -I$(INCLUDE) simple.c simple.o
	gcc -rdynamic -shared simple.o -o ../FooCraft/bin/libsimple.so
