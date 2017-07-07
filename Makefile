CC=gcc
CFLAGS=-Wall

all:
	flex ac_scanner.l
	$(CC)  lex.yy.c -lm -g -o  ac_circuit_solver