 /*******************************************************************************
*
* FILE:		tokens.h
*
* DESC:		EECS 337 Assignment 9
*
* AUTHOR:	caseid
*
* DATE:		October 26, 2010
*
* EDIT HISTORY:	
*
*******************************************************************************/
#ifndef	TOKENS_H
#define	TOKENS_H	1

/*******************************************************************************
 *
 *	ansi_c token table 
 *
 ******************************************************************************/
char	*tokens[] =
{
	"NUL", "SOH", "STX", "ETX", "EOT", "ENQ", "ACK", "BEL", "BS",
	"HT", "LF", "VT", "FF", "CR", "SO", "SI", "DLE", "DC1", "DC2",
	"DC3", "DC", "NAK", "SYN", "ETB", "CAN", "EM", "SUB", "ESC",
	"FS", "GS", "RS", "US", " ", "!", "\"", "#", "$", "%", "&",
	"'", "(", ")", "*", "+", ",", "-", ".", "/", "0", "1", "2",
	"3", "4", "5", "6", "7", "8", "9", ":", ";", "<", "=", ">",
	"?", "@", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J",
	"K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V",
	"W", "X", "Y", "Z", "[", "\\", "]", "^", "_", "`", "a", "b",
	"c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n",
	"o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
	"{", "|", "}", "~", "DEL",
/* 8 bit ascii codes do not exist so label with a minus sign (-) */
	"-NUL", "-SOH", "-STX", "-ETX", "-EOT", "-ENQ", "-ACK",
	"-BEL", "-BS", "-HT", "-LF", "-VT", "-FF", "-CR", "-SO",
	"-SI", "-DLE", "-DC1", "-DC2", "-DC3", "-DC", "-NAK", "-SYN",
	"-ETB", "-CAN", "-EM", "-SUB", "-ESC", "-FS", "-GS", "-RS",
	"-US", "- ", "-!", "-\"", "-#", "-$", "-%", "-&", "-'", "-(",
	"-)", "-*", "-+", "-,", "--", "-.", "-/", "-0", "-1", "-2",
	"-3", "-4", "-5", "-6", "-7", "-8", "-9", "-:", "-;", "-<",
	"-=", "->", "-?", "-@", "-A", "-B", "-C", "-D", "-E", "-F",
	"-G", "-H", "-I", "-J", "-K", "-L", "-M", "-N", "-O", "-P",
	"-Q", "-R", "-S", "-T", "-U", "-V", "-W", "-X", "-Y", "-Z",
	"-[", "-\\", "-]", "-^", "-_", "-`", "-a", "-b", "-c", "-d",
	"-e", "-f", "-g", "-h", "-i", "-j", "-k", "-l", "-m", "-n",
	"-o", "-p", "-q", "-r", "-s", "-t", "-u", "-v", "-w", "-x",
	"-y", "-z", "-{", "-|", "-}", "-~", "-DEL",
/* yacc error tokens */
	"ERRORCODE",
#if (IDENTIFIER == 258)
	"ERRORCODE2",
#endif
/* yacc %tokens */
	"IDENTIFIER", "CONSTANT", "STRING_LITERAL", "SIZEOF",
	"PTR_OP", "INC_OP", "DEC_OP", "LEFT_OP", "RIGHT_OP", "LE_OP",
	"GE_OP", "EQ_OP", "NE_OP", "AND_OP", "OR_OP", "MUL_ASSIGN",
	"DIV_ASSIGN", "MOD_ASSIGN", "ADD_ASSIGN", "SUB_ASSIGN",
	"LEFT_ASSIGN", "RIGHT_ASSIGN", "AND_ASSIGN", "XOR_ASSIGN",
	"OR_ASSIGN", "TYPE_NAME", "TYPEDEF", "EXTERN", "STATIC",
	"AUTO", "REGISTER", "CHAR", "SHORT", "INT", "LONG", "SIGNED",
	"UNSIGNED", "FLOAT", "DOUBLE", "CONST", "VOLATILE", "VOID",
	"STRUCT", "UNION", "ENUM", "ELIPSIS", "RANGE", "CASE",
	"DEFAULT", "IF", "ELSE", "SWITCH", "WHILE", "DO", "FOR",
	"GOTO", "CONTINUE", "BREAK", "RETURN", "UNSIGNED_CHAR",
	"UNSIGNED_INT", "TYPEDEF_CHAR", "TYPEDEF_INT",
};

#endif
