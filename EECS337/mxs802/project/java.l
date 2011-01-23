/*******************************************************************************
*
* FILE:		java.l
*
* DESC:		EECS 337 Final Project
*
* AUTHOR:	mxs802q
*
* DATE:		December 1, 2010
*
* EDIT HISTORY:	
*
*******************************************************************************/

Separator	[\(\)\{\}\[\]\;\,\.]
Delimiter1	[\=\>\<\!\~\?\:\+\-\*\/\&\|\^\%]
HexDigit	[0-9a-fA-F]
Digit		[0-9]
OctalDigit	[0-7]
TetraDigit	[0-3]
NonZeroDigit	[1-9]
Letter		[a-zA-Z_]
AnyButSlash	[^\/]
AnyButAstr	[^\*]
BLK		[\b]
TAB		[\t]
FF		[\f]
ESCCHR		[\\]
CR		[\r]
LF		[\n]

Escape		[\\]([r]|[n]|[b]|[f]|[t]|[\\])
Identifier 	{Letter}({Letter}|{Digit})*

Comment1        [\/][\*]({AnyButAstr}|[\*]{AnyButSlash})*[\*][\/]
Comment2        [\/][\/].*
Comment		({Comment1}|{Comment2})
WhiteSpace	({CR}|{LF}|{FF}|{TAB}|{BLK}|[ ])

Dimension	[\[]({WhiteSpace}|{Comment})*[\]]

IntSuffix	([l]|[L])
DecimalNum	{NonZeroDigit}{Digit}*{IntSuffix}?
OctalNum	[0]{OctalDigit}*{IntSuffix}?
HexNum		[0]([x]|[X]){HexDigit}{HexDigit}*{IntSuffix}?
IntegerLiteral	({DecimalNum}|{OctalNum}|{HexNum})

Sign		([\+]|[\-])
FlSuffix	([f]|[F]|[d][D])
SignedInt	{Sign}?{Digit}+
Expo		([e]|[E])
ExponentPart	{Expo}{SignedInt}?
Float1          {Digit}+[\.]{Digit}+?{ExponentPart}?{FlSuffix}?
Float2		[\.]{Digit}+{ExponentPart}?{FlSuffix}?
Float3		{Digit}+{ExponentPart}{FlSuffix}?
Float4		{Digit}+{FlSuffix}
FloatingPoint	({Float1}|{Float2}|{Float3}|{Float4})

AnyChrChr	[^\\']
AnyStrChr	[^\\"]
Character	[\']({Escape}|{AnyChrChr})[\']
String		[\"]({Escape}|{AnyStrChr})*[\"]
Numeric  	({IntegerLiteral}|{FloatingPoint})
Literal		({Numeric}|{Character}|{String})


%{
/**************************************************************/
/* This file contains a restricted lexer for java language.   */
/* The lexer will scan java programs in ASCII without unicode */
/* characters and/or unicode escape sequences.                */
/* It is provided only to enable the grammar user to test it  */
/* right away.                                                */
/**************************************************************/

#include	"yystype.h"
#include	"y.tab.h"
//#include	"tokens.h"
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
		//printf( "token: %s ", tokens[ clips->token]);
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
	clips = al_clips( CONST, (unsigned char)x, 0, 0, 0, 0);
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
	clips = al_clips( CONST, (unsigned char)o, 0, 0, 0, 0);
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
	clips = al_clips( CONST, (unsigned char)u, 0, 0, 0, 0);
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
	clips = al_clips( CONST, (unsigned char)c, 0, 0, 0, 0);
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
	clips = al_clips( CONST, (unsigned char)f, 0, 0, 0, 0);
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
	clips = al_clips( LITERAL, 0, 0, 0, strcat(&text[0],"\""), length);
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


"true"		{count(); yylval.token = BOOLLIT; return BOOLLIT;} //changed to boollit from literal
"false"		{count(); yylval.token = BOOLLIT; return BOOLLIT;}

{Separator}	{count(); return yytext[0];}
{Delimiter1}	{count(); return yytext[0];}
{Dimension}	{count(); yylval.token = OP_DIM; return OP_DIM;}

"=="		{count(); yylval.token = OP_EQ; return OP_EQ;}
"<="		{count(); yylval.token = OP_LE; return OP_LE;}
">="		{count(); yylval.token = OP_GE; return OP_GE;}
"!="		{count(); yylval.token = OP_NE; return OP_NE;}
"||"		{count(); yylval.token = OP_LOR; return OP_LOR;}
"&&"		{count(); yylval.token = OP_LAND; return OP_LAND;}
"++"		{count(); yylval.token = OP_INC; return OP_INC;}
"--"		{count(); yylval.token = OP_DEC; return OP_DEC;}
">>"		{count(); yylval.token = OP_SHR; return OP_SHR;}
"<<"		{count(); yylval.token = OP_SHL; return OP_SHL;}
">>>"		{count(); yylval.token = OP_SHRR; return OP_SHRR;}
"+="		{count(); yylval.token = ASS_ADD; return ASS_ADD;}
"-="		{count(); yylval.token = ASS_SUB; return ASS_SUB;}
"*="		{count(); yylval.token = ASS_MUL; return ASS_MUL;}
"/="		{count(); yylval.token = ASS_DIV; return ASS_DIV;}
"&="		{count(); yylval.token = ASS_AND; return ASS_AND;}
"|="		{count(); yylval.token = ASS_OR; return ASS_OR;}
"^="		{count(); yylval.token = ASS_XOR; return ASS_XOR;}
"%="		{count(); yylval.token = ASS_MOD; return ASS_MOD;}
"<<="		{count(); yylval.token = ASS_SHL; return ASS_SHL;}
">>="		{count(); yylval.token = ASS_SHR; return ASS_SHR;}
">>>="		{count(); yylval.token = ASS_SHRR; return ASS_SHRR;}

"abstract"	{count(); yylval.token = ABSTRACT; return ABSTRACT;}
"do"            {count(); yylval.token = DO; return DO;}
"implements"    {count(); yylval.token = IMPLEMENTS; return IMPLEMENTS;}
"package"	{count(); yylval.token = PACKAGE; return PACKAGE;}
"throw"		{count(); yylval.token = THROW; return THROW;}
"boolean"	{count(); yylval.token = BOOLEAN; return BOOLEAN;}
"double"	{count(); yylval.token = DOUBLE; return DOUBLE;}
"import"	{count(); yylval.token = IMPORT; return IMPORT;}
"private"	{count(); yylval.token = PRIVATE; return PRIVATE;}
"throws"	{count(); yylval.token = THROWS; return THROWS;}
"break"		{count(); yylval.token = BREAK; return BREAK;}
"else"		{count(); yylval.token = ELSE; return ELSE;}
"inner"		{count(); yylval.token = INNER; return INNER;}
"protected"	{count(); yylval.token = PROTECTED; return PROTECTED;}
"transient"	{count(); yylval.token = TRANSIENT; return TRANSIENT;}
"byte"		{count(); yylval.token = BYTE; return BYTE;}
"extends"	{count(); yylval.token = EXTENDS; return EXTENDS;}
"instanceof"	{count(); yylval.token = INSTANCEOF; return INSTANCEOF;}
"public"	{count(); yylval.token = PUBLIC; return PUBLIC;}
"try"		{count(); yylval.token = TRY; return TRY;}
"case"		{count(); yylval.token = CASE; return CASE;}
"final"		{count(); yylval.token = FINAL; return FINAL;}
"int"		{count(); yylval.token = INT; return INT;}
"rest"		{count(); yylval.token = REST; return REST;}
"var"		{count(); yylval.token = VAR; return VAR;}
"cast"		{count(); yylval.token = CAST; return CAST;}
"finally"	{count(); yylval.token = FINALLY; return FINALLY;}
"interface"	{count(); yylval.token = INTERFACE; return INTERFACE;}
"return"	{count(); yylval.token = RETURN; return RETURN;}
"void"		{count(); yylval.token = VOID; return VOID;}
"catch"		{count(); yylval.token = CATCH; return CATCH;}
"float"		{count(); yylval.token = FLOAT; return FLOAT;}
"long"		{count(); yylval.token = LONG; return LONG;}
"short"		{count(); yylval.token = SHORT; return SHORT;}
"volatile"	{count(); yylval.token = VOLATILE; return VOLATILE;}
"char"		{count(); yylval.token = CHAR; return CHAR;}
"for"		{count(); yylval.token = FOR; return FOR;}
"native"	{count(); yylval.token = NATIVE; return NATIVE;}
"static"	{count(); yylval.token = STATIC; return STATIC;}
"while"		{count(); yylval.token = WHILE; return WHILE;}
"class"		{count(); yylval.token = CLASS; return CLASS;}
"future"	{count(); yylval.token = FUTURE; return FUTURE;}
"new"		{count(); yylval.token = NEW; return NEW;}
"super"		{count(); yylval.token = SUPER; return SUPER;}
"const"		{count(); yylval.token = CONST; return CONST;}
"generic"	{count(); yylval.token = GENERIC; return GENERIC;}
"null"		{count(); yylval.token = JNULL; return JNULL;}
"switch"	{count(); yylval.token = SWITCH; return SWITCH;}
"continue"	{count(); yylval.token = CONTINUE ; return CONTINUE;}
"goto"		{count(); yylval.token = GOTO; return GOTO;}
"operator"	{count(); yylval.token = OPERATOR; return OPERATOR;}
"synchronized"	{count(); yylval.token = SYNCHRONIZED; return SYNCHRONIZED;}
"default"	{count(); yylval.token = DEFAULT; return DEFAULT;}
"if"		{count(); yylval.token = IF; return IF;}
"outer"		{count(); yylval.token = OUTER; return OUTER;}
"this"		{count(); yylval.token = THIS; return THIS;}
{Identifier}		{ count(); yylval.clips = identifier( yytext, yyleng); return(check_type()); }
{String}	{ count(); yylval.clips = string_literal( yytext, yyleng); return(LITERAL); }
{WhiteSpace}    {count(); }
{Comment}	{ }

%%
//{Identifier}	{count(); return IDENTIFIER;}
//{Comment1}	{comment(); }
//{Comment2}	{comment2(); }
/*
{Literal}	{count(); yylval.token = LITERAL; return LITERAL;}
{HexNum}		{ count(); yylval.clips = constant_hex( yytext, yyleng); return(CONST); }
{OctalNum}		{ count(); yylval.clips = constant_octal( yytext, yyleng); return(CONST); }
{DecimalNum}		{ count(); yylval.clips = constant_decimal( yytext, yyleng); return(CONST); }
{Character}		{ count(); yylval.clips = constant_char( yytext, yyleng); return(CONST); }
{FloatingPoint}		{ count(); yylval.clips = constant_float( yytext, yyleng); return(CONST); }

*/
/*
 *	yywrap function
 */
int	yywrap( void)
{
	return(1);
}

/*
 *	c comment function
 *
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
} */
// c comment function for single line comment
void comment2(void) {
	char c;
	if (IS_FLAGS_ECHO(data.flags))
		ECHO;
	while(( c = input()) != '\n' && c != 0)
	      if( c && IS_FLAGS_ECHO( data.flags))
	      	  putchar(c);
	if( c != 0)
	      if( IS_FLAGS_ECHO( data.flags))
	      	  putchar(c);
}
void comment(void) {
	char c;
	if (IS_FLAGS_ECHO(data.flags))
		ECHO;
	while(( c = input()) != '*' && (c = input()) != '/' )//&& c != 0)
	      if( c && IS_FLAGS_ECHO( data.flags))
	      	  putchar(c);
	if( c != 0)
	      if( IS_FLAGS_ECHO( data.flags))
	      	  putchar(c);
	unput(c);
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