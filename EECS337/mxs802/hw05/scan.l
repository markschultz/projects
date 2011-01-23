/*******************************************************************************
*
* FILE:		scan.l
*
* DESC:		EECS 337 Assignment 5
*
* AUTHOR:	caseid
*
* DATE:		September 28, 2010
*
* EDIT HISTORY:	
*
*******************************************************************************/

D			[0-9]
L			[a-zA-Z_]
H			[a-fA-F0-9]
E			[Ee][+-]?{D}+
FS			(f|F|l|L)
IS			(u|U|l|L)*

%{
#include	"yystype.h"
#include	"y.tab.h"
#include	"tokens.h"

/*******************************************************************************
 *
 *	dynamic memory routines
 *
 ******************************************************************************/
/*
 *	memory allocation error (FATAL no return!)
 */
void	al_error( int length)
{
	fprintf( stderr, "Fatal error: memory allocation failure: %d\n", length);
	exit( -1);
}

/*
 *	allocate buffer memory routine
 */
char	*al_buffer( char *text, int length)
{
	char	*buffer = 0;

	if( 0 < length)
	{
		if( !( buffer = (char*)malloc( length)))
			al_error( length);
		else
		{
/*
 *	initialize the buffer to zero and copy in text
 */
			memset( (void *)buffer, 0, (size_t)length);
			strncpy( buffer, text, length);
			data.memory += length;
		}
	}
	return( buffer);
}

/*
 *	deallocate buffer memory routine
 */
void	de_buffer( char *buffer, int length)
{
	if( 0 < length)
	{
		free( buffer);
		data.memory -= length;
	}
	return;
}

/*
 *	allocate a clips data structure
 */
CLIPS	*al_clips( int token, unsigned char value, int address, int mask, char *buffer, int length)
{
	CLIPS *clips;

	if( !(clips = ( CLIPS*)malloc( sizeof( CLIPS))))
		al_error( sizeof( CLIPS));
	else
	{
		memset( (void *)clips, 0, (size_t)sizeof( CLIPS));
		clips->token = token;
		clips->value = value;
		clips->address = address;
		clips->mask = mask;
		if( 0 < length)
		{
			clips->length = length;
			clips->buffer = al_buffer( buffer, length);
		}
		data.memory += sizeof( CLIPS);
	}
	return( clips);
}

/*
 *	deallocate a clips data structure
 */
void	de_clips( CLIPS *clips)
{
	if( clips)
	{
		de_buffer( clips->buffer, clips->length);
		free( clips);
		data.memory -= sizeof( CLIPS);
	}
	return;
}

/*
 *	deallocate a clips linked list
 */
void	de_clips_list( CLIPS *clips)
{
	CLIPS	*clips_next;
/*
 *	deallocate the clips linked list structure
 */
	while( clips)
	{
		clips_next = clips->next;
		de_clips( clips);
		clips = clips_next;
	}
	return;
}

/*
 *	find the last clips structure in linked list
 */
CLIPS	*end_clips( CLIPS *clips)
{
	if( clips)
		while( clips->next)
			clips = clips->next;
	return clips;
}

/*
 *	print a clips structure
 */
void	print_clips( CLIPS *clips)
{
	if( clips)
	{
		printf( "next: %08.8x ", clips->next);
		printf( "token: %s ", tokens[ clips->token]);
		printf( "value: %02.2x ", clips->value);
		printf( "address: %02.2x ", clips->address);
		printf( "mask: %02.2x ", clips->mask);
		printf( "level: %d ", clips->level);
		printf( "length: %d ", clips->length);
		if( 0 < clips->length)
			printf( "buffer: %s\n", clips->buffer);
		else
			printf( "buffer: %d\n", clips->buffer);
	}
	return;
}

/*
 *	print a clips linked list
 */
void	print_clips_list( CLIPS *clips)
{
/*
 *	print the clips linked list structure
 */
	while( clips)
	{
		print_clips( clips);
		clips = clips->next;
	}
	return;
}


/*******************************************************************************
 *
 *	lowest level ansi_c audit routines
 *
 ******************************************************************************/
/*
 *	check for conversion error
 */
int	ansi_c_audit_conversion( unsigned char byte, unsigned int integer, char *text, int length)
{
	if( byte != integer)
	{
		fprintf( stderr, "Warning: data conversion error\n");
		data.warnings++;
	}
	return 0;
}

/*
 *	check for overflow condition
 */
int	ansi_c_audit_overflow( unsigned char byte, unsigned int integer, char *text, int length)
{
	if( 255 < integer)
	{
		fprintf( stderr, "Warning: overflow in implicit constant conversion\n");
		data.warnings++;
	}
	return 0;
}

/*
 *	check for multi character constant
 */
int	ansi_c_audit_multi_character( unsigned char byte, unsigned int integer, char *text, int length)
{
	switch( text[ 1])
	{
	case '\\':
		switch( text[ 2])
		{
		case 'n':	/* newline */
		case 'r':	/* cr */
		case 't':	/* tab */
		case 'b':	/* backspace */
		case '\\':	
		case '?':
		case '\'':
		case '"':
		case 'x':
		case 'X':
		case '0':
		case '1':
		case '2':
		case '3':
		case '4':
		case '5':
		case '6':
		case '7':
		     break;
		default:
			if( text[ 2] != '\'')
			{
				fprintf( stderr, "Warning:  multi-character character constant\n");
				data.warnings++;
			}
		}
	}
	return 0;
}

	int	i;
/*
 *	check the digits for octal
 */
int	ansi_c_audit_octal_digits( unsigned char byte, unsigned int integer, char *text, int length)
{
	for( i = length - 1; 0 <= i; i--)
	{
		switch( text[ i])
		{
		case '0':
		case '1':
		case '2':
		case '3':
		case '4':
		case '5':
		case '6':
		case '7':
		case 'l':
		case 'L':
		case 'u':
		case 'U':
		     break;
		default:
		     fprintf( stderr, "Error: invalid digit \"%c\" in octal constant\n", text[ i]);
		     data.errors++;
		     return 1;
		}
	}
	return 0;
}

/*******************************************************************************
 *
 *	highest level ansi_c audit routines
 *
 ******************************************************************************/
/*
 *	audit the char constant
 */
void	ansi_c_audit_char( unsigned char byte, unsigned int integer, char *text, int length)
{
	if( ansi_c_audit_conversion( byte, integer, text, length))
		return;
	if( ansi_c_audit_overflow( byte, integer, text, length))
		return;
	if( ansi_c_audit_multi_character( byte, integer, text, length))
		return;
	return;
}

/*
 *	audit the decimal constant
 */
void	ansi_c_audit_decimal( unsigned char byte, unsigned int integer, char *text, int length)
{
	if( ansi_c_audit_conversion( byte, integer, text, length))
		return;
	if( ansi_c_audit_overflow( byte, integer, text, length))
		return;
	return;
}

/*
 *	audit the hex constant
 */
void	ansi_c_audit_hex( unsigned char byte, unsigned int integer, char *text, int length)
{
	if( ansi_c_audit_conversion( byte, integer, text, length))
		return;
	if( ansi_c_audit_overflow( byte, integer, text, length))
		return;
	return;
}

/*
 *	audit the octal constant
 */
void	ansi_c_audit_octal( unsigned char byte, unsigned int integer, char *text, int length)
{
	if( ansi_c_audit_conversion( byte, integer, text, length))
		return;
	if( ansi_c_audit_overflow( byte, integer, text, length))
		return;
	if( ansi_c_audit_octal_digits( byte, integer, text, length))
		return;
	return;
}

/*
 *	audit the float constant
 */
void	ansi_c_audit_float( unsigned char byte, float f, char *text, int length)
{
	int	integer;
/*
 *	check for floating point errors
 */
	integer = (int)f;
	if( ansi_c_audit_conversion( byte, integer, text, length))
		return;
	if( ansi_c_audit_overflow( byte, integer, text, length))
		return;
	return;
}

/*******************************************************************************
 *
 *	scanner encode routines now using CLIPS
 *
 ******************************************************************************/
/*
 *	encode a constant hex value
 */
CLIPS	*constant_hex( char *text, int length)
{
	CLIPS	*clips;

	unsigned int	x = 0;
	sscanf( text, "%x", &x);
	clips = al_clips( CONSTANT, (unsigned char)x, 0, 0, 0, 0);
	ansi_c_audit_hex( clips->value, x, text, length);
	return( clips);
}

/*
 *	encode a constant octal value
 */
CLIPS	*constant_octal( char *text, int length)
{
	CLIPS	*clips;
	unsigned int	o = 0;
	sscanf( text, "%o", &o);
	clips = al_clips( CONSTANT, (unsigned char)o, 0, 0, 0, 0);
	ansi_c_audit_octal( clips->value, o, text, length);
	return( clips);
}

/*
 *	encode a constant decimal value
 */
CLIPS	*constant_decimal( char *text, int length)
{
	CLIPS	*clips;
	unsigned int	u = 0;
	sscanf( text, "%u", &u);
	clips = al_clips( CONSTANT, (unsigned char)u, 0, 0, 0, 0);
	ansi_c_audit_decimal( clips->value, u, text, length);
	return( clips);
}

/*
 *	encode a constant character value
 */
CLIPS	*constant_char( char *text, int length)
{
	CLIPS	*clips;
	unsigned int c = 0;
	switch( text[ 1])
	{
	case '\\':
		switch( text[ 2])
		{
		case 'n':	/* newline */
			c = 0x0a;
			break;
		case 'r':	/* cr */
			c = 0x0d;
			break;
		case 't':	/* tab */
			c = 0x09;
			break;
		case 'b':	/* backspace */
			c = 0x08;
			break;
		case '\\':	
			c = 0x5c;
			break;
		case '?':
			c = 0x3f;
			break;
		case '\'':
			c = 0x27;
			break;
		case '"':
			c = 0x22;
			break;
		case 'x':
		case 'X':
			text[1] = '0';
			sscanf( &text[1], "%x", &c);
			break;
		case '0':
		case '1':
		case '2':
		case '3':
		case '4':
		case '5':
		case '6':
		case '7':
			sscanf( &text[2], "%o", &c);
			break;
		default:
			{
				int i;
				for( i = 2; i < length; i++)
				{
					if( text[ i] == '\'')
						break;
					c = text[ i];
				}
			}
			break;
		}
		break;
	default:
		c = text[1];
		break;
	}
	clips = al_clips( CONSTANT, (unsigned char)c, 0, 0, 0, 0);
	ansi_c_audit_char( clips->value, c, text, length);
	return( clips);
}

/*
 *	encode a constant floating point value
 */
CLIPS	*constant_float( char *text, int length)
{
	CLIPS	*clips;
	float	f = 0;
	sscanf( text, "%f", &f);
	clips = al_clips( CONSTANT, (unsigned char)f, 0, 0, 0, 0);
	ansi_c_audit_float( clips->value, f, text, length);
	return( clips);
}

/*
 *	encode a string literal
 */
CLIPS	*string_literal( char *text, int length)
{
	CLIPS	*clips;
/*
 *	do not need the beginning " and also remove the ending " but add one for nul (-2 + 1 = -1)
 */
	text[ length - 1] = 0;
	clips = al_clips( STRING_LITERAL, 0, 0, 0, &text[1], length - 1);
	return( clips);
}

/*
 *	encode an identifier
 */
CLIPS	*identifier( char *text, int length)
{
	CLIPS	*clips;
/*
 *	but add one for nul
 */
	clips = al_clips( IDENTIFIER, 0, 0, 0, text, length + 1);
	return( clips);
}

%}

%%
"/*"			{ comment(); }
"#"			{ pdefine(); }

"auto"			{ count(); return(AUTO); }
"break"			{ count(); return(BREAK); }
"case"			{ count(); return(CASE); }
"char"			{ count(); return(CHAR); }
"const"			{ count(); return(CONST); }
"continue"		{ count(); return(CONTINUE); }
"default"		{ count(); return(DEFAULT); }
"do"			{ count(); return(DO); }
"double"		{ count(); return(DOUBLE); }
"else"			{ count(); return(ELSE); }
"enum"			{ count(); return(ENUM); }
"extern"		{ count(); return(EXTERN); }
"float"			{ count(); return(FLOAT); }
"for"			{ count(); return(FOR); }
"goto"			{ count(); return(GOTO); }
"if"			{ count(); return(IF); }
"int"			{ count(); return(INT); }
"long"			{ count(); return(LONG); }
"register"		{ count(); return(REGISTER); }
"return"		{ count(); return(RETURN); }
"short"			{ count(); return(SHORT); }
"signed"		{ count(); return(SIGNED); }
"sizeof"		{ count(); return(SIZEOF); }
"static"		{ count(); return(STATIC); }
"struct"		{ count(); return(STRUCT); }
"switch"		{ count(); return(SWITCH); }
"typedef"		{ count(); return(TYPEDEF); }
"union"			{ count(); return(UNION); }
"unsigned"		{ count(); return(UNSIGNED); }
"void"			{ count(); return(VOID); }
"volatile"		{ count(); return(VOLATILE); }
"while"			{ count(); return(WHILE); }

{L}({L}|{D})*		{ count(); yylval.clips = identifier( yytext, yyleng); return(check_type()); }

0[xX]{H}+{IS}?		{ count(); yylval.clips = constant_hex( yytext, yyleng); return(CONSTANT); }
0{D}+{IS}?		{ count(); yylval.clips = constant_octal( yytext, yyleng); return(CONSTANT); }
{D}+{IS}?		{ count(); yylval.clips = constant_decimal( yytext, yyleng); return(CONSTANT); }

'(\\.|[^\\'])+'		{ count(); yylval.clips = constant_char( yytext, yyleng); return(CONSTANT); }

{D}+{E}{FS}?		{ count(); yylval.clips = constant_float( yytext, yyleng); return(CONSTANT); }
{D}*"."{D}+({E})?{FS}?	{ count(); yylval.clips = constant_float( yytext, yyleng); return(CONSTANT); }
{D}+"."{D}*({E})?{FS}?	{ count(); yylval.clips = constant_float( yytext, yyleng); return(CONSTANT); }

\"(\\.|[^\\"])*\"	{ count(); yylval.clips = string_literal( yytext, yyleng); return(STRING_LITERAL); }

">>="			{ count(); return(RIGHT_ASSIGN); }
"<<="			{ count(); return(LEFT_ASSIGN); }
"+="			{ count(); return(ADD_ASSIGN); }
"-="			{ count(); return(SUB_ASSIGN); }
"*="			{ count(); return(MUL_ASSIGN); }
"/="			{ count(); return(DIV_ASSIGN); }
"%="			{ count(); return(MOD_ASSIGN); }
"&="			{ count(); return(AND_ASSIGN); }
"^="			{ count(); return(XOR_ASSIGN); }
"|="			{ count(); return(OR_ASSIGN); }
">>"			{ count(); return(RIGHT_OP); }
"<<"			{ count(); return(LEFT_OP); }
"++"			{ count(); return(INC_OP); }
"--"			{ count(); return(DEC_OP); }
"->"			{ count(); return(PTR_OP); }
"&&"			{ count(); return(AND_OP); }
"||"			{ count(); return(OR_OP); }
"<="			{ count(); return(LE_OP); }
">="			{ count(); return(GE_OP); }
"=="			{ count(); return(EQ_OP); }
"!="			{ count(); return(NE_OP); }
";"			{ count(); return(';'); }
"{"			{ count(); return('{'); }
"}"			{ count(); return('}'); }
","			{ count(); return(','); }
":"			{ count(); return(':'); }
"="			{ count(); return('='); }
"("			{ count(); return('('); }
")"			{ count(); return(')'); }
"["			{ count(); return('['); }
"]"			{ count(); return(']'); }
"."			{ count(); return('.'); }
"&"			{ count(); return('&'); }
"!"			{ count(); return('!'); }
"~"			{ count(); return('~'); }
"-"			{ count(); return('-'); }
"+"			{ count(); return('+'); }
"*"			{ count(); return('*'); }
"/"			{ count(); return('/'); }
"%"			{ count(); return('%'); }
"<"			{ count(); return('<'); }
">"			{ count(); return('>'); }
"^"			{ count(); return('^'); }
"|"			{ count(); return('|'); }
"?"			{ count(); return('?'); }

[ \t\v\n\f]		{ count(); }
.			{ /* ignore bad characters */ }

%%

/*
 *	yywrap function
 */
int	yywrap( void)
{
	return(1);
}

/*
 *	c preprocessor function
 */
void	pdefine( void)
{
	char c;

	if( IS_FLAGS_ECHO( data.flags))
	    ECHO;
	while(( c = input()) != '\n' && c != 0)
	      if( c && IS_FLAGS_ECHO( data.flags))
	      	  putchar(c);
	if( c != 0)
	      if( IS_FLAGS_ECHO( data.flags))
	      	  putchar(c);
}

/*
 *	c comment function
 */
void	comment( void)
{
	char c, c1;

	if( IS_FLAGS_ECHO( data.flags))
	    ECHO;
loop:
	while(( c = input()) != '*' && c != 0)
	      if( c && IS_FLAGS_ECHO( data.flags))
	      	  putchar(c);
	if( c != 0)
	      if( IS_FLAGS_ECHO( data.flags))
	      	  putchar(c);

	if(( c1 = input()) != '/' && c != 0)
	{
		unput(c1);
		goto loop;
	}
	if( c != 0)
	      if( IS_FLAGS_ECHO( data.flags))
	      	  putchar(c1);
}

/*
 *	update the current column index value
 */
void	count( void)
{
	int i;

	for( i = 0; yytext[i] != '\0'; i++)
		if( yytext[i] == '\n')
			data.column = 0;
		else if( yytext[i] == '\t')
			data.column += 8 - (data.column % 8);
		else
			data.column++;
	if( yytext[0] && IS_FLAGS_ECHO( data.flags))
	    ECHO;
}

int check_type()
{
/*
* pseudo code --- this is what it should check
*
*	if (yytext == type_name)
*		return(TYPE_NAME);
*
*	return(IDENTIFIER);
*/

/*
*	it actually will only return IDENTIFIER
*/

	return(IDENTIFIER);
}
