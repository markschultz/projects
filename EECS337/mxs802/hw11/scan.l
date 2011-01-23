/*******************************************************************************
*
* FILE:		scan.l
*
* DESC:		EECS 337 Assignment 11
*
* AUTHOR:	caseid
*
* DATE:		November 9, 2010
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
		if( clips->mask)
			printf( "instr: %s ", instr_table[ clips->token % I_SLEEP]);
		else
			printf( "token: %s ", tokens[ clips->token % UNSIGNED_INT]);
		printf( "value: %02.2x ", clips->value);
		printf( "address: %02.2x ", clips->address);
		printf( "mask: %02.2x ", clips->mask);
		if( clips->mask)
		{
			if( clips->mask & MASK_VALUE)
				printf( "MASK_VALUE ");
			if( clips->mask & MASK_ADDRESS)
				printf( "MASK_ADDRESS ");
			if( clips->mask & MASK_LABEL)
				printf( "MASK_LABEL ");
			if( clips->mask & MASK_W_REG)
				printf( "MASK_W_REG ");
			if( clips->mask & MASK_F_REG)
				printf( "MASK_F_REG ");
			if( clips->mask & MASK_INSTR)
				printf( "MASK_INSTR ");
		}
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
 *	scanner encode routines
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

"auto"			{ count(); yylval.token = AUTO; return(AUTO); }
"break"			{ count(); yylval.token = BREAK; return(BREAK); }
"case"			{ count(); yylval.token = CASE; return(CASE); }
"char"			{ count(); yylval.token = CHAR; return(CHAR); }
"const"			{ count(); yylval.token = CONST; return(CONST); }
"continue"		{ count(); yylval.token = CONTINUE; return(CONTINUE); }
"default"		{ count(); yylval.token = DEFAULT; return(DEFAULT); }
"do"			{ count(); yylval.token = DO; return(DO); }
"double"		{ count(); yylval.token = DOUBLE; return(DOUBLE); }
"else"			{ count(); yylval.token = ELSE; return(ELSE); }
"enum"			{ count(); yylval.token = ENUM; return(ENUM); }
"extern"		{ count(); yylval.token = EXTERN; return(EXTERN); }
"float"			{ count(); yylval.token = FLOAT; return(FLOAT); }
"for"			{ count(); yylval.token = FOR; return(FOR); }
"goto"			{ count(); yylval.token = GOTO; return(GOTO); }
"if"			{ count(); yylval.token = IF; return(IF); }
"int"			{ count(); yylval.token = INT; return(INT); }
"long"			{ count(); yylval.token = LONG; return(LONG); }
"register"		{ count(); yylval.token = REGISTER; return(REGISTER); }
"return"		{ count(); yylval.token = RETURN; return(RETURN); }
"short"			{ count(); yylval.token = SHORT; return(SHORT); }
"signed"		{ count(); yylval.token = SIGNED; return(SIGNED); }
"sizeof"		{ count(); yylval.token = SIZEOF; return(SIZEOF); }
"static"		{ count(); yylval.token = STATIC; return(STATIC); }
"struct"		{ count(); yylval.token = STRUCT; return(STRUCT); }
"switch"		{ count(); yylval.token = SWITCH; return(SWITCH); }
"typedef"		{ count(); yylval.token = TYPEDEF; return(TYPEDEF); }
"union"			{ count(); yylval.token = UNION; return(UNION); }
"unsigned"		{ count(); yylval.token = UNSIGNED; return(UNSIGNED); }
"void"			{ count(); yylval.token = VOID; return(VOID); }
"volatile"		{ count(); yylval.token = VOLATILE; return(VOLATILE); }
"while"			{ count(); yylval.token = WHILE; return(WHILE); }

{L}({L}|{D})*		{ count(); yylval.clips = identifier( yytext, yyleng); return(check_type()); }
0[xX]{H}+{IS}?		{ count(); yylval.clips = constant_hex( yytext, yyleng); return(CONSTANT); }
0{D}+{IS}?		{ count(); yylval.clips = constant_octal( yytext, yyleng); return(CONSTANT); }
{D}+{IS}?		{ count(); yylval.clips = constant_decimal( yytext, yyleng); return(CONSTANT); }
'(\\.|[^\\'])+'		{ count(); yylval.clips = constant_char( yytext, yyleng); return(CONSTANT); }
{D}+{E}{FS}?		{ count(); yylval.clips = constant_float( yytext, yyleng); return(CONSTANT); }
{D}*"."{D}+({E})?{FS}?	{ count(); yylval.clips = constant_float( yytext, yyleng); return(CONSTANT); }
{D}+"."{D}*({E})?{FS}?	{ count(); yylval.clips = constant_float( yytext, yyleng); return(CONSTANT); }
\"(\\.|[^\\"])*\"	{ count(); yylval.clips = string_literal( yytext, yyleng); return(STRING_LITERAL); }

">>="			{ count(); yylval.token = RIGHT_ASSIGN; return(RIGHT_ASSIGN); }
"<<="			{ count(); yylval.token = LEFT_ASSIGN; return(LEFT_ASSIGN); }
"+="			{ count(); yylval.token = ADD_ASSIGN; return(ADD_ASSIGN); }
"-="			{ count(); yylval.token = SUB_ASSIGN; return(SUB_ASSIGN); }
"*="			{ count(); yylval.token = MUL_ASSIGN; return(MUL_ASSIGN); }
"/="			{ count(); yylval.token = DIV_ASSIGN; return(DIV_ASSIGN); }
"%="			{ count(); yylval.token = MOD_ASSIGN; return(MOD_ASSIGN); }
"&="			{ count(); yylval.token = AND_ASSIGN; return(AND_ASSIGN); }
"^="			{ count(); yylval.token = XOR_ASSIGN; return(XOR_ASSIGN); }
"|="			{ count(); yylval.token = OR_ASSIGN; return(OR_ASSIGN); }
">>"			{ count(); yylval.token = RIGHT_OP; return(RIGHT_OP); }
"<<"			{ count(); yylval.token = LEFT_OP; return(LEFT_OP); }
"++"			{ count(); yylval.token = INC_OP; return(INC_OP); }
"--"			{ count(); yylval.token = DEC_OP; return(DEC_OP); }
"->"			{ count(); yylval.token = PTR_OP; return(PTR_OP); }
"&&"			{ count(); yylval.token = AND_OP; return(AND_OP); }
"||"			{ count(); yylval.token = OR_OP; return(OR_OP); }
"<="			{ count(); yylval.token = LE_OP; return(LE_OP); }
">="			{ count(); yylval.token = GE_OP; return(GE_OP); }
"=="			{ count(); yylval.token = EQ_OP; return(EQ_OP); }
"!="			{ count(); yylval.token = NE_OP; return(NE_OP); }
";"			{ count(); yylval.token = ';'; return(';'); }
"{"			{ count(); yylval.token = '{'; return('{'); }
"}"			{ count(); yylval.token = '}'; return('}'); }
","			{ count(); yylval.token = ','; return(','); }
":"			{ count(); yylval.token = ':'; return(':'); }
"="			{ count(); yylval.token = '='; return('='); }
"("			{ count(); yylval.token = '('; return('('); }
")"			{ count(); yylval.token = ')'; return(')'); }
"["			{ count(); yylval.token = '['; return('['); }
"]"			{ count(); yylval.token = ']'; return(']'); }
"."			{ count(); yylval.token = '.'; return('.'); }
"&"			{ count(); yylval.token = '&'; return('&'); }
"!"			{ count(); yylval.token = '!'; return('!'); }
"~"			{ count(); yylval.token = '~'; return('~'); }
"-"			{ count(); yylval.token = '-'; return('-'); }
"+"			{ count(); yylval.token = '+'; return('+'); }
"*"			{ count(); yylval.token = '*'; return('*'); }
"/"			{ count(); yylval.token = '/'; return('/'); }
"%"			{ count(); yylval.token = '%'; return('%'); }
"<"			{ count(); yylval.token = '<'; return('<'); }
">"			{ count(); yylval.token = '>'; return('>'); }
"^"			{ count(); yylval.token = '^'; return('^'); }
"|"			{ count(); yylval.token = '|'; return('|'); }
"?"			{ count(); yylval.token = '?'; return('?'); }

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
	CLIPS	*lists;
/*
 *	search the clips list using the string compare to match
 */
	for( lists = data.typedef_table; lists; lists = lists->next)
	{
		if( ! strcmp( lists->buffer, yytext))
		{
/*
 *	found typedef symbol so deallocate identifier memory and return this type
 */
			de_clips( yylval.clips);
			yylval.token = lists->token;
			return( yylval.token);

		}
	}
/*
*	it actually will only return IDENTIFIER
*/

	return(IDENTIFIER);
}

