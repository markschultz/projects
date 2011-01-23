#-----------------------------------------------------------------------------
#	Makefile
#	EECS 337 Compilers Fall 2010
#	by caseid
#	Assignment 6
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

#
#	to make all
#
all:		calc 

SRC	= yacc.y calc.c
OBJ	= yacc.o calc.o

calc :	$(OBJ)
	$(LINK) $(CFLAGS) $(OBJ) -lm -o calc

lex.o	: y.tab.h 

clean	:
	rm -f yacc.c y.tab.h y.output *.o
