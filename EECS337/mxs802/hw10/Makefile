#-----------------------------------------------------------------------------
#	Makefile
#	EECS 337 Compilers Fall 2010
#	by caseid
#
# REVISION HISTORY
#
#-----------------------------------------------------------------------------
.KEEP_STATE:
SHELL=/bin/bash

#
#	define version of c compiler, linker and lex
#
CC=	gcc
LINK=	gcc
LEX=	flex
#
#	define yacc lex and compiler flags
#
YFLAGS	= -dv
LFLAGS	=
CFLAGS	= -g

SRC	= gram.y scan.l main.c
OBJ	= gram.o scan.o main.o

ansi_c :	$(OBJ)
	$(LINK) $(CFLAGS) $(OBJ) -o ansi_c

scan.o	: y.tab.h

clean	:
	rm -f scan.c gram.c y.tab.h y.output *.o

fromtar	:
	tar xvf hw08_caseid.tar 
