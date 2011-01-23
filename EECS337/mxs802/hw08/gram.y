/***********************************************
*
* File gram.y
*
* desc EECS337 assignment 2
*
* author mxs802
*
* date 9-6-10
*
***********************************************/

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

%token T_UNIVERSE
%token UNSIGNED_CHAR
%token UNSIGNED_INT
%token TYPEDEF_CHAR
%token TYPEDEF_INT

%start file

%%

primary_expr
	: identifier
	| CONSTANT
	{
	#ifdef YYDEBUG
	if (IS_FLAGS_DEBUG(data.flags))
		print_clips_list($1.clips);
	#endif
	de_clips_list($1.clips);
	}

	| STRING_LITERAL
{
	#ifdef	YYDEBUG
	if(IS_FLAGS_DEBUG(data.flags))
		print_clips_list($1.clips);
	#endif
	de_clips_list($1.clips);
  }
	| '(' expr ')'
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
		switch($1.token)
		{
			case TYPEDEF_CHAR:
			case TYPEDEF_INT:
				$$.clips = typedef_declaration($1.token, $2.clips);
				break;
			default:
				$$.clips = 0;
		}
	}
	;

declaration_specifiers
	: storage_class_specifier
	{
		$$.token = audit_declaration_specifiers($1.token,0);
	}
	| storage_class_specifier declaration_specifiers
	{
		$$.token = audit_declaration_specifiers($1.token,$2.token);
	}
	| type_specifier
	{
		$$.token = audit_declaration_specifiers($1.token, 0);
	}
	| type_specifier declaration_specifiers
	{
		$$.token = audit_declaration_specifiers($1.token,$2.token);
	}
	;

init_declarator_list
	: init_declarator
	| init_declarator_list ',' init_declarator
	;

init_declarator
	: declarator
	| declarator '=' initializer
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

compound_statement
	: '{' '}'
	| '{' statement_list '}'
	| '{' declaration_list '}'
	| '{' declaration_list statement_list '}'
	;

declaration_list
	: declaration
	| declaration_list declaration
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

file
	: external_definition
	| file external_definition
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
	#ifdef YYDEBUG
		if(IS_FLAGS_DEBUG(data.flags))
			print_clips_list($1.clips);
	#endif
	}
	;

%%

void	yyerror( char *s)
{
	fflush(stdout);
	printf("\n%*s\n%*s\n", data.column, "^", data.column, s);
}

