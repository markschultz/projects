/*
 *	In scan.l find/cut/replace these lex regular expressions (inside the %% to %% section)
 */
{L}({L}|{D})*		{ count(); yylval.clips = identifier( yytext, yyleng); return(check_type()); }
0[xX]{H}+{IS}?		{ count(); yylval.clips = constant_hex( yytext, yyleng); return(CONSTANT); }
0{D}+{IS}?		{ count(); yylval.clips = constant_octal( yytext, yyleng); return(CONSTANT); }
{D}+{IS}?		{ count(); yylval.clips = constant_decimal( yytext, yyleng); return(CONSTANT); }
'(\\.|[^\\'])+'		{ count(); yylval.clips = constant_char( yytext, yyleng); return(CONSTANT); }
{D}+{E}{FS}?		{ count(); yylval.clips = constant_float( yytext, yyleng); return(CONSTANT); }
{D}*"."{D}+({E})?{FS}?	{ count(); yylval.clips = constant_float( yytext, yyleng); return(CONSTANT); }
{D}+"."{D}*({E})?{FS}?	{ count(); yylval.clips = constant_float( yytext, yyleng); return(CONSTANT); }
\"(\\.|[^\\"])*\"	{ count(); yylval.clips = string_literal( yytext, yyleng); return(STRING_LITERAL); }

/*
 *	then in scan.l find/cut/replace the scanner encoder routines from the comment to the %} line
 *	notice the two new routines at the end to encode string literals and identifiers 
 */
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

