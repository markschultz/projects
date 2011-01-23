#-----------------------------------------------------------------------------
#	Makefile
#	EECS 337 Compilers Fall 2008
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

#
#	to make all
#
all:		ansi_c 

SRC	= gram.y scan.l main.c
OBJ	= gram.o scan.o main.o

ansi_c :	$(OBJ)
	$(LINK) $(CFLAGS) $(OBJ) -o ansi_c

scan.o	: y.tab.h yystype.h tokens.h

clean	:
	rm -f scan.c gram.c y.tab.h y.output *.o
#
#	diff between file to save directory 
#
diff2save:
		diff main.c	save/
		diff scan.l	save/
		diff gram.y	save/
		diff yystype.h	save/
		diff tokens.h	save/
		diff Makefile	save/
#
#	backup save
#
backup:
		cp main.c	save/
		cp scan.l	save/
		cp gram.y	save/
		cp yystype.h	save/
		cp tokens.h	save/
		cp Makefile	save/
