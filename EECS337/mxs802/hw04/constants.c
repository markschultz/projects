/*
 *	replace these LEX regular expression lines in scan.l to encode constant values
 *	be sure to leave out these C comments because they will give you errors in LEX
 */
0[xX]{H}+{IS}?		{ count(); yylval = constant_hex( yytext, yyleng); return(CONSTANT); }
0{D}+{IS}?		{ count(); yylval = constant_octal( yytext, yyleng); return(CONSTANT); }
{D}+{IS}?		{ count(); yylval = constant_decimal( yytext, yyleng); return(CONSTANT); }

'(\\.|[^\\'])+'		{ count(); yylval = constant_char( yytext, yyleng); return(CONSTANT); }

{D}+{E}{FS}?		{ count(); yylval = constant_float( yytext, yyleng); return(CONSTANT); }
{D}*"."{D}+({E})?{FS}?	{ count(); yylval = constant_float( yytext, yyleng); return(CONSTANT); }
{D}+"."{D}*({E})?{FS}?	{ count(); yylval = constant_float( yytext, yyleng); return(CONSTANT); }

/*
 *	insert these lines after #include "y.tab.h" at top of scan.l and before %}
 */
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
 *	yystype routines
 *
 ******************************************************************************/
/*
 *	encode a constant hex value
 */
unsigned char	constant_hex( char *text, int length)
{
	unsigned char c;
	unsigned int	x = 0;
	sscanf( text, "%x", &x);
	c = (char)x;
	ansi_c_audit_hex( c, x, text, length);
	return( c);
}

/*
 *	encode a constant octal value
 */
unsigned char	constant_octal( char *text, int length)
{
	unsigned char c;
	unsigned int	o = 0;
	sscanf( text, "%o", &o);
	c = (char)o;
	ansi_c_audit_octal( c, o, text, length);
	return( c);
}

/*
 *	encode a constant decimal value
 */
unsigned char	constant_decimal( char *text, int length)
{
	unsigned char c;
	unsigned int	u = 0;
	sscanf( text, "%u", &u);
	c = (char)u;
	ansi_c_audit_decimal( c, u, text, length);
	return( c);
}

/*
 *	encode a constant character value
 */
unsigned char	constant_char( char *text, int length)
{
	unsigned char c;
	unsigned int u = 0;
	switch( text[ 1])
	{
	case '\\':
		switch( text[ 2])
		{
		case 'n':	/* newline */
			u = 0x0a;
			break;
		case 'r':	/* cr */
			u = 0x0d;
			break;
		case 't':	/* tab */
			u = 0x09;
			break;
		case 'b':	/* backspace */
			u = 0x08;
			break;
		case '\\':	
			u = 0x5c;
			break;
		case '?':
			u = 0x3f;
			break;
		case '\'':
			u = 0x27;
			break;
		case '"':
			u = 0x22;
			break;
		case 'x':
		case 'X':
			text[1] = '0';
			sscanf( &text[1], "%x", &u);
			break;
		case '0':
		case '1':
		case '2':
		case '3':
		case '4':
		case '5':
		case '6':
		case '7':
			sscanf( &text[2], "%o", &u);
			break;
		default:
			{
				int i;
				for( i = 2; i < length; i++)
				{
					if( text[ i] == '\'')
						break;
					u = text[ i];
				}
			}
			break;
		}
		break;
	default:
		u = text[1];
		break;
	}
	c = (char)u;
	ansi_c_audit_char( c, u, text, length);
	return( c);
}

/*
 *	encode a constant floating point value
 */
unsigned char	constant_float( char *text, int length)
{
	unsigned char c;
	float	f = 0;
	sscanf( text, "%f", &f);
	c = (char)f;
	ansi_c_audit_float( c, f, text, length);
	return( c);
}

