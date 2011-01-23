/*******************************************************************************
*
* FILE:		gram.y
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
%{

#include	"yystype.h"
#include	"y.tab.h"

/*******************************************************************************
 *
 *	ansi_c audit routines
 *	the only types supported by the ansi_c compiler:
 *
 *	Input type1, type2:		Return type:
 *	VOID, NUL			CHAR
 *	CHAR, NUL			CHAR
 *	INT, NUL			INT
 *	UNSIGNED, CHAR			UNSIGNED_CHAR
 *	UNSIGNED, INT			UNSIGNED_INT
 *	UNSIGNED_CHAR, NUL		UNSIGNED_CHAR
 *	UNSIGNED_INT, NUL		UNSIGNED_INT
 *
 *	also support typedef char identifier or typedef int identifier 
 *
 *	TYPEDEF, CHAR			TYPEDEF_CHAR
 *	TYPEDEF, INT			TYPEDEF_INT
 *
 ******************************************************************************/
/*
 *	audit the type specifiers
 *	only support TYPEDEF CHAR or INT or
 *	support VOID, [UNSIGNED] CHAR or INT - everything to one byte CHAR
		$$.token = audit_declaration_specifiers( $1.token, 0);
		$$.token = audit_declaration_specifiers( $1.token, $2.token);
 */
int	audit_declaration_specifiers( int type1, int type2)
{
	switch( type1)
	{
	case VOID:
		if( ! type2)
			return CHAR;
		break;
	case CHAR:
		if( ! type2)
			return CHAR;
		break;
	case INT:
		if( ! type2)
			return INT;
		break;
	case UNSIGNED:
		switch( type2)
		{
		case CHAR:
			return UNSIGNED_CHAR;
		case INT:
			return UNSIGNED_INT;
		}
		break;
	case UNSIGNED_CHAR:
		if( ! type2)
			return UNSIGNED_CHAR;
		break;
	case UNSIGNED_INT:
		if( ! type2)
			return UNSIGNED_INT;
		break;
	case TYPEDEF:
		switch( type2)
		{
		case CHAR:
			return TYPEDEF_CHAR;
		case INT:
			return TYPEDEF_INT;
		}
		break;
	}
	fprintf( stderr, "Error: unsupported data type: %s %s\n", tokens[ type1], tokens[ type2]);
	data.errors++;
	return CHAR;
}

/*******************************************************************************
 *
 *	typedef table routines
 *
 ******************************************************************************/
/*
 *	print the typedef table
 */
void	print_typedef_table( void)
{
	if( data.typedef_table)
	{
		printf( "typedef table:\n");
		print_clips_list( data.typedef_table);
	}
}

/*
 *	find the identifier in the typedef table linked list 
 */
CLIPS	*find_typedef( char *text, int length)
{
	CLIPS	*lists;
/*
 *	search the clips list using the buffer length and string compare to match
 */
	for( lists = data.typedef_table; lists; lists = lists->next)
	{
		if( lists->length == length && ! strcmp( lists->buffer, text))
			return( lists);
	}
	return( lists);
}

/*
 *	type an identifier in typedef table
		$$.token = typedef_declaration( $1.token, $2.clips);
 */
CLIPS	*typedef_declaration( int type_specifier, CLIPS *identifier)
{
	CLIPS	*clips;
	int	type;
/*
 *	first search for same identifier string
 */
	clips = find_typedef( identifier->buffer, identifier->length);
	if( clips)
	{
		fprintf( stderr, "Error: typedef already defined for: %s\n", clips->buffer);
		data.errors++;
		return( identifier);
	}
	switch( type_specifier)
	{
	case TYPEDEF_CHAR:
		identifier->token = CHAR;
		break;
	case TYPEDEF_INT:
		identifier->token = INT;
		break;
	default:
		fprintf( stderr, "Warning typedef not supported for: %s\n", clips->buffer);
		data.warnings++;
		return( identifier);
	}
/*
 *	attach it to the head of the typedef table list (LIFO)
 */
	identifier->next = data.typedef_table;
	data.typedef_table = identifier;
/*
 *	return 
 */
	return( (CLIPS*)0);
}

/*******************************************************************************
 *
 *	pic memory routines
 *
 *	68 STATIC REGISTERS
 *
 *	+---------------+
 *	| TOP_STATIC	| 0X0C
 *	+---------------+
 *	| STATIC	| 0X0D
 *	+---------------+
 *	| ...		|
 *	+---------------+
 *	| STATIC	| 0X4E
 *	+---------------+
 *	| BOTTOM_STATIC	| 0X4F
 *	+---------------+
 *
 ******************************************************************************/
/*
 *	get an address off the static memory
 */
int	get_address( void)
{
	if( data.address > BOTTOM_STATIC)
	{
		fprintf( stderr, "Error: address allocation failure: %d\n", data.address);
		data.errors++;
		return( 0);
	}
	return( data.address++);	/* at top of memory go down */
}

/*
 *	put an address onto the static memory
 */
int	put_address( int address)
{
	if( data.address - 1 != address)
	{
		fprintf( stderr, "Error: address deallocation failure: %d\n", address);
		data.errors++;
		return( 0);
	}
	return( data.address--);	/* at bottom of memory go up */
}

/*******************************************************************************
 *
 *	more clips routines
 *
 ******************************************************************************/
/*
 *	link the tail of first linked list to second linked list
 */
CLIPS	*clips_tail_to_head( CLIPS *head1, CLIPS *head2)
{
	CLIPS	*lists;
/*
 *	check if head1 exist else return head2
 */
	if( head1)
	{
		lists = end_clips( head1);
		lists->next = head2;
		return( head1);
	}
	return( head2);
}

/*******************************************************************************
 *
 *	symbol table routines
 *
 ******************************************************************************/
/*
 *	print the symbol table
 */
void	print_symbol_table( void)
{
	printf( "symbol table:\n");
	print_clips_list( data.symbol_table);
}

/*
 *	find the identifier in the symbol table linked list at this level
 */
CLIPS	*find_symbol( int level, char *text, int length)
{
	CLIPS	*lists;
/*
 *	search the clips list using the buffer length and string compare to match
 */
	for( lists = data.symbol_table; lists; lists = lists->next)
	{
		if( lists->level < level)
			return( (CLIPS*)0);
		if( lists->length == length && ! strcmp( lists->buffer, text))
			return( lists);
	}
	return( lists);
}

/*
 *	create a symbol table entry unless one already exists 
 */
void	create_symbol( int type, unsigned char value, char *buffer, int length)
{
	CLIPS	*clips;
/*
 *	first search for same identifier string
 */
	clips = find_symbol( data.level, buffer, length);
/*
 *	update symbol type entry or make new symbol table entry
 */
	if( clips)
	{
		if( 0 < type)
			clips->token = type;
		if( 0 < value)
			clips->value = value;
		return;
	}
	clips = al_clips( type, value, get_address(), 0, buffer, length);
	clips->level = data.level;
/*
 *	attach it to the head of the symbol table list (LIFO)
 */
	clips->next = data.symbol_table;
	data.symbol_table = clips;
	return;
}

/*******************************************************************************
 *
 *	symbol parser production routines
 *
 ******************************************************************************/
/*
 *	type an identifier in symbol table
		$$.clips = symbol_declaration( $1.token, $2.clips);
 */
CLIPS	*symbol_declaration( int type_specifier, CLIPS *init_declarator_list)
{
	CLIPS	*lists;
/*
 *	can be a list of identifiers
 */
	for( lists = init_declarator_list; lists; lists = lists->next)
	{
/*
 *	create a symbol with this type
 */
		create_symbol( type_specifier, 0, lists->buffer, lists->length);
	}
/*
 *	return init_declarator_list linked list
 */
	return( init_declarator_list);
}

/*
 *	update the value from last identifier and attach the clip
		$$.clips = symbol_init_declarator_list( $1.clips, $3.clips);
 */
CLIPS	*symbol_init_declarator_list( CLIPS *init_declarator_list, CLIPS *init_declarator)
{
	CLIPS	*lists;
/*
 *	can be a list of identifiers
 */
	for( lists = init_declarator_list; lists; lists = lists->next)
	{
/*
 *	create a symbol with this value
 */
		create_symbol( 0, init_declarator->value, lists->buffer, lists->length);
	}
/*
 *	link in the last init_declarator clip, return head of list
 */
	clips_tail_to_head( init_declarator_list, init_declarator);
	return( init_declarator_list);
}

/*
 *	update a value of an identifier in symbol table
		$$.clips = symbol_init_declarator( $1.clips, $3.clips);
 */
CLIPS	*symbol_init_declarator( CLIPS *declarator, CLIPS *initializer)
{
	CLIPS	*lists;
/*
 *	can be a list of identifiers
 */
	for( lists = declarator; lists; lists = lists->next)
	{
/*
 *	create a symbol with this value and copy it to identifier list
 */
		create_symbol( 0, initializer->value, lists->buffer, lists->length);
		lists->value = initializer->value;
	}
/*
 *	free the initializer linked list
 */
	de_clips_list( initializer);
	return( declarator);
}

/*
 *	new symbol table identifiers at this level
		symbol_left_bracket();
 */
void	symbol_left_bracket( void)
{
/*
 *	increment the symbol table level
 */
	data.level++;
	return;
}

/*
 *	pop symbol table identifiers at this level
		symbol_right_bracket();
 */
void	symbol_right_bracket( void)
{
	CLIPS	*clips;
/*
 *	print the complete symbol table before poping symbols off
 */
#ifdef	YYDEBUG
	if( IS_FLAGS_SYMBOL( data.flags))
	{
		printf( "pop symbol table level: %d\n", data.level);
		print_symbol_table();
	}
#endif
/*
 *	check and remove all clips above level
 */
	for( clips = data.symbol_table; clips; clips = data.symbol_table)
	{
		if( clips->level < data.level)
			break;
		put_address( clips->address);
		data.symbol_table = clips->next;
		de_clips( clips);
	}
/*
 *	decrement the symbol table level
 */
	data.level--;
	return;
}

%}

%token IDENTIFIER CONSTANT STRING_LITERAL SIZEOF
%token PTR_OP INC_OP DEC_OP LEFT_OP RIGHT_OP LE_OP GE_OP EQ_OP NE_OP
%token AND_OP OR_OP MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN
%token SUB_ASSIGN LEFT_ASSIGN RIGHT_ASSIGN AND_ASSIGN
%token XOR_ASSIGN OR_ASSIGN TYPE_NAME

%token TYPEDEF EXTERN STATIC AUTO REGISTER
%token CHAR SHORT INT LONG SIGNED UNSIGNED FLOAT DOUBLE CONST VOLATILE VOID
%token STRUCT UNION ENUM ELIPSIS RANGE

%token CASE DEFAULT IF ELSE SWITCH WHILE DO FOR GOTO CONTINUE BREAK RETURN

%token UNSIGNED_CHAR
%token UNSIGNED_INT
%token TYPEDEF_CHAR
%token TYPEDEF_INT

%start code

%%

primary_expr
	: identifier
	| CONSTANT
	{
#ifdef	YYDEBUG
		if( IS_FLAGS_DEBUG( data.flags))
			print_clips_list( $1.clips);
#endif
	}
	| STRING_LITERAL
	{
#ifdef	YYDEBUG
		if( IS_FLAGS_DEBUG( data.flags))
			print_clips_list( $1.clips);
#endif
		de_clips_list( $1.clips);
		$$.clips = 0;
	}
	| '(' expr ')'
	{
		$$ = $2;	/* C allows struct to struct copy */
	}
	;

postfix_expr
	: primary_expr
	| postfix_expr '[' expr ']'
	| postfix_expr '(' ')'
	| postfix_expr '(' argument_expr_list ')'
	| postfix_expr '.' identifier
	| postfix_expr PTR_OP identifier
	| postfix_expr INC_OP
	| postfix_expr DEC_OP
	;

argument_expr_list
	: assignment_expr
	| argument_expr_list ',' assignment_expr
	;

unary_expr
	: postfix_expr
	| INC_OP unary_expr
	| DEC_OP unary_expr
	| unary_operator cast_expr
	| SIZEOF unary_expr
	| SIZEOF '(' type_name ')'
	;

unary_operator
	: '&'
	| '*'
	| '+'
	| '-'
	| '~'
	| '!'
	;

cast_expr
	: unary_expr
	| '(' type_name ')' cast_expr
	;

multiplicative_expr
	: cast_expr
	| multiplicative_expr '*' cast_expr
	| multiplicative_expr '/' cast_expr
	| multiplicative_expr '%' cast_expr
	;

additive_expr
	: multiplicative_expr
	| additive_expr '+' multiplicative_expr
	| additive_expr '-' multiplicative_expr
	;

shift_expr
	: additive_expr
	| shift_expr LEFT_OP additive_expr
	| shift_expr RIGHT_OP additive_expr
	;

relational_expr
	: shift_expr
	| relational_expr '<' shift_expr
	| relational_expr '>' shift_expr
	| relational_expr LE_OP shift_expr
	| relational_expr GE_OP shift_expr
	;

equality_expr
	: relational_expr
	| equality_expr EQ_OP relational_expr
	| equality_expr NE_OP relational_expr
	;

and_expr
	: equality_expr
	| and_expr '&' equality_expr
	;

exclusive_or_expr
	: and_expr
	| exclusive_or_expr '^' and_expr
	;

inclusive_or_expr
	: exclusive_or_expr
	| inclusive_or_expr '|' exclusive_or_expr
	;

logical_and_expr
	: inclusive_or_expr
	| logical_and_expr AND_OP inclusive_or_expr
	;

logical_or_expr
	: logical_and_expr
	| logical_or_expr OR_OP logical_and_expr
	;

conditional_expr
	: logical_or_expr
	| logical_or_expr '?' logical_or_expr ':' conditional_expr
	;

assignment_expr
	: conditional_expr
	| unary_expr assignment_operator assignment_expr
	;

assignment_operator
	: '='
	| MUL_ASSIGN
	| DIV_ASSIGN
	| MOD_ASSIGN
	| ADD_ASSIGN
	| SUB_ASSIGN
	| LEFT_ASSIGN
	| RIGHT_ASSIGN
	| AND_ASSIGN
	| XOR_ASSIGN
	| OR_ASSIGN
	;

expr
	: assignment_expr
	| expr ',' assignment_expr
	;

constant_expr
	: conditional_expr
	;

declaration
	: declaration_specifiers ';'
	{
		$$.clips = 0;
	}
	| declaration_specifiers init_declarator_list ';'
	{
		switch( $1.token)
		{
		case TYPEDEF_CHAR:
		case TYPEDEF_INT:
			$$.clips = typedef_declaration( $1.token, $2.clips);
			break;
		case CHAR:
		case INT:
		case UNSIGNED_CHAR:
		case UNSIGNED_INT:
		default:
			$$.clips = symbol_declaration( $1.token, $2.clips);
			break;
		}
	}
	;

declaration_specifiers
	: storage_class_specifier
	{
		$$.token = audit_declaration_specifiers( $1.token, 0);
	}
	| storage_class_specifier declaration_specifiers
	{
		$$.token = audit_declaration_specifiers( $1.token, $2.token);
	}
	| type_specifier
	{
		$$.token = audit_declaration_specifiers( $1.token, 0);
	}
	| type_specifier declaration_specifiers
	{
		$$.token = audit_declaration_specifiers( $1.token, $2.token);
	}
	;

init_declarator_list
	: init_declarator
	| init_declarator_list ',' init_declarator
	{
		$$.clips = symbol_init_declarator_list( $1.clips, $3.clips);
	}
	;

init_declarator
	: declarator
	| declarator '=' initializer
	{
		$$.clips = symbol_init_declarator( $1.clips, $3.clips);
	}
	;

storage_class_specifier
	: TYPEDEF
	| EXTERN
	| STATIC
	| AUTO
	| REGISTER
	;

type_specifier
	: CHAR
	| SHORT
	| INT
	| LONG
	| SIGNED
	| UNSIGNED
	| FLOAT
	| DOUBLE
	| CONST
	| VOLATILE
	| VOID
	| struct_or_union_specifier
	| enum_specifier
	| TYPE_NAME
	;

struct_or_union_specifier
	: struct_or_union identifier '{' struct_declaration_list '}'
	| struct_or_union '{' struct_declaration_list '}'
	| struct_or_union identifier
	;

struct_or_union
	: STRUCT
	| UNION
	;

struct_declaration_list
	: struct_declaration
	| struct_declaration_list struct_declaration
	;

struct_declaration
	: type_specifier_list struct_declarator_list ';'
	;

struct_declarator_list
	: struct_declarator
	| struct_declarator_list ',' struct_declarator
	;

struct_declarator
	: declarator
	| ':' constant_expr
	| declarator ':' constant_expr
	;

enum_specifier
	: ENUM '{' enumerator_list '}'
	| ENUM identifier '{' enumerator_list '}'
	| ENUM identifier
	;

enumerator_list
	: enumerator
	| enumerator_list ',' enumerator
	;

enumerator
	: identifier
	| identifier '=' constant_expr
	;

declarator
	: declarator2
	| pointer declarator2
	;

declarator2
	: identifier
	| '(' declarator ')'
	| declarator2 '[' ']'
	| declarator2 '[' constant_expr ']'
	| declarator2 '(' ')'
	| declarator2 '(' parameter_type_list ')'
	| declarator2 '(' parameter_identifier_list ')'
	;

pointer
	: '*'
	| '*' type_specifier_list
	| '*' pointer
	| '*' type_specifier_list pointer
	;

type_specifier_list
	: type_specifier
	| type_specifier_list type_specifier
	;

parameter_identifier_list
	: identifier_list
	| identifier_list ',' ELIPSIS
	;

identifier_list
	: identifier
	| identifier_list ',' identifier
	;

parameter_type_list
	: parameter_list
	| parameter_list ',' ELIPSIS
	;

parameter_list
	: parameter_declaration
	| parameter_list ',' parameter_declaration
	;

parameter_declaration
	: type_specifier_list declarator
	| type_name
	;

type_name
	: type_specifier_list
	| type_specifier_list abstract_declarator
	;

abstract_declarator
	: pointer
	| abstract_declarator2
	| pointer abstract_declarator2
	;

abstract_declarator2
	: '(' abstract_declarator ')'
	| '[' ']'
	| '[' constant_expr ']'
	| abstract_declarator2 '[' ']'
	| abstract_declarator2 '[' constant_expr ']'
	| '(' ')'
	| '(' parameter_type_list ')'
	| abstract_declarator2 '(' ')'
	| abstract_declarator2 '(' parameter_type_list ')'
	;

initializer
	: assignment_expr
	| '{' initializer_list '}'
	| '{' initializer_list ',' '}'
	;

initializer_list
	: initializer
	| initializer_list ',' initializer
	;

statement
	: labeled_statement
	| compound_statement
	| expression_statement
	| selection_statement
	| iteration_statement
	| jump_statement
	;

labeled_statement
	: identifier ':' statement
	| CASE constant_expr ':' statement
	| DEFAULT ':' statement
	;

left_bracket
	: '{'
	{
		symbol_left_bracket();
	}

right_bracket
	: '}'
	{
		symbol_right_bracket();
	}

compound_statement
	: left_bracket right_bracket
	{
		$$.clips = 0;
	}
	| left_bracket statement_list right_bracket
	{
		$$.clips = $2.clips;
	}
	| left_bracket declaration_list right_bracket
	{
		$$.clips = $2.clips;
	}
	| left_bracket declaration_list statement_list right_bracket
	{
		$$.clips = clips_tail_to_head( $2.clips, $3.clips);
	}
	;

declaration_list
	: declaration
	| declaration_list declaration
	{
		$$.clips = clips_tail_to_head( $1.clips, $2.clips);
	}
	;

statement_list
	: statement
	| statement_list statement
	;

expression_statement
	: ';'
	| expr ';'
	;

selection_statement
	: IF '(' expr ')' statement
	| IF '(' expr ')' statement ELSE statement
	| SWITCH '(' expr ')' statement
	;

iteration_statement
	: WHILE '(' expr ')' statement
	| DO statement WHILE '(' expr ')' ';'
	| FOR '(' ';' ';' ')' statement
	| FOR '(' ';' ';' expr ')' statement
	| FOR '(' ';' expr ';' ')' statement
	| FOR '(' ';' expr ';' expr ')' statement
	| FOR '(' expr ';' ';' ')' statement
	| FOR '(' expr ';' ';' expr ')' statement
	| FOR '(' expr ';' expr ';' ')' statement
	| FOR '(' expr ';' expr ';' expr ')' statement
	;

jump_statement
	: GOTO identifier ';'
	| CONTINUE ';'
	| BREAK ';'
	| RETURN ';'
	| RETURN expr ';'
	;

code	: file
	{
#ifdef	YYDEBUG
		if( IS_FLAGS_DEBUG( data.flags))
			print_clips_list( $1.clips);
#endif
		de_clips_list( $1.clips);
	}
	;
file
	: external_definition
	| file external_definition
	{
		$$.clips = clips_tail_to_head( $1.clips, $2.clips);
	}
	;

external_definition
	: function_definition
	| declaration
	;

function_definition
	: declarator function_body
	| declaration_specifiers declarator function_body
	;

function_body
	: compound_statement
	| declaration_list compound_statement
	;

identifier
	: IDENTIFIER
	{
#ifdef	YYDEBUG
		if( IS_FLAGS_DEBUG( data.flags))
			print_clips_list( $1.clips);
#endif
	}
	;
%%

void	yyerror( char *s)
{
	fflush(stdout);
	printf("\n%*s\n%*s\n", data.column, "^", data.column, s);
}

