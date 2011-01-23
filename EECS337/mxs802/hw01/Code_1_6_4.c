/*******************************************************************************
*
* FILE:		Code_1_6_4.c
*
* DESC:		EECS 337 Homework Assignment 1
*
* AUTHOR:	mxs802
*
* DATE:		August 26, 2010
*
* EDIT HISTORY:	
*
*******************************************************************************/

/*
 *	enter the sample code from 1.6.4
 */
#define a (x+1)
int x = 2;
void b() { x = a; printf("%d\n", x); }
void c() { int x = 1; printf("%d\n", a); }
void main() { b(); c(); }
