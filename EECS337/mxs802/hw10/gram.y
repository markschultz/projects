/*******************************************************************************
*
* FILE:		gram.y
*
* DESC:		EECS 337 Assignment 10
*
* AUTHOR:	caseid
*
* DATE:		November 2, 2010
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

/*******************************************************************************
 *
 *	code generator routines
 *
 ******************************************************************************/
/*
 *	generate the pic header information
 */
void	code_generator_pic_prefix( void)
{
	printf( "; automatic code generation for ansi_c PIC16F84A compiler\n");
	printf( "; EECS337 Compilers by: caseid, date: Fall 2010\n");
	printf( "; CPU configuration\n");
	printf( "; (16F84 with RC osc, watchdog timer off, power-up timer on)\n");
	printf( "	processor 16f84A\n");
	printf( "	include <p16F84A.inc>\n");
	printf( "	__config _RC_OSC & _WDT_OFF & _PWRTE_ON\n");
	printf( "; beginning of program code\n");
	printf( "	org	0x00	; reset at address 0\n");
	printf( "reset:	goto	init	; skip reserved program addresses\n");
	printf( "	org	0x08 	; beginning of user code\n");
	printf( "init:\n");
	printf( "; At startup, all ports are inputs.\n");
	printf( "	bsf	STATUS,RP0	; switch to bank 0 memory\n");
	printf( "	clrf	TRISB		; set PORTB to all outputs\n");	
	printf( "	bcf	STATUS,RP0	; return to bank 1 memory\n");
	printf( "mloop:\n");
	printf( "; here begins the main program\n");
}

/*
 *	generate the pic tail information
 */
void	code_generator_pic_postfix( void)
{
	printf( "	return	; if main does not have a return\n");
	printf( "printf:	; only standard library function\n");
	printf( "	movwf	PORTB	; output w to stdout\n");
	printf( "	return\n");
	printf( "	end		; end of program code\n");
}

/*
 *	code generator operand postfix
 */
 void	code_generator_operand_postfix( CLIPS *tuple)
{
	if( tuple->token != I_CLR)
	{
		if( tuple->mask & MASK_W_REG)
			printf( ",w");
		else if( tuple->mask & MASK_F_REG)
			printf( ",f");
	}
}

/*
 *	code generator operand
 */
void	code_generator_operand( CLIPS *tuple)
{
	if( tuple->mask & MASK_ADDRESS)
		printf( "0x%02.2x", tuple->address);
	switch( tuple->token)
	{
	case I_BCF:
	case I_BSF:
	case I_BTFSC:
	case I_BTFSS:
		if( tuple->mask & MASK_VALUE)
			printf( ",%d", tuple->value);
		break;
	default:
		if( tuple->mask & MASK_VALUE)
			printf( "0x%02.2x", tuple->value);
		break;
	}
	if( tuple->mask & MASK_LABEL)
		if( tuple->length <= 2)		/* assembler does not like one letter labels */
			printf( "%s1", tuple->buffer);
		else
			printf( "%s", tuple->buffer);
	code_generator_operand_postfix( tuple);
	printf( "\n");
	return;
}

/*
 *	code generator instruction postfix
 */
void	code_generator_instr_postfix( CLIPS *tuple)
{
	switch( tuple->token)
	{
	case I_MOV:
		if( tuple->mask & MASK_VALUE)
			printf( "lw\t");
		else if( tuple->mask & MASK_W_REG || tuple->mask & MASK_F_REG)
			printf( "f\t");
		else
			printf( "wf\t");
		break;
	case I_CLR:
		if( tuple->mask & MASK_W_REG)
			printf( "w");
		else
			printf( "f\t");
		break;
	default:
		if( tuple->mask & MASK_VALUE)
			printf( "lw\t");
		else
			printf( "wf\t");
		break;
	}
}

/*
 *	code generator instruction
 */
void	code_generator_instr( CLIPS *tuple)
{
	switch( tuple->token)
	{
	case I_LABEL:
		if( tuple->length <= 2)		/* assembler does not like one letter labels */
			printf( "%s1:\n", tuple->buffer);
		else
			printf( "%s:\n", tuple->buffer);
		break;
	case I_MOV:
	case I_ADD:
	case I_AND:
	case I_IOR:
	case I_SUB:
	case I_XOR:
	case I_CLR:
		printf( "\t%s", instr_table[ tuple->token]);
		code_generator_instr_postfix( tuple);
		code_generator_operand( tuple);
		break;
	case I_COMF:
	case I_DECF:
	case I_DECFSZ:
	case I_INCF:
	case I_INCFSZ:
	case I_RLF:
	case I_RRF:
	case I_SWAPF:
	case I_CALL:
	case I_GOTO:
	case I_TRIS:
	case I_RETLW:
	case I_BCF:
	case I_BSF:
	case I_BTFSC:
	case I_BTFSS:
		printf( "\t%s\t", instr_table[ tuple->token]);
		code_generator_operand( tuple);
		break;
	case I_CLRWDT:
	case I_NOP:
	case I_OPTION:
	case I_RETFIE:
	case I_RETURN:
	case I_SLEEP:
		printf( "\t%s\n", instr_table[ tuple->token]);
		break;
	}
	return;
}

/*
 *	post process the instruction list
 *	insert post initialization code (goto mloop)
 */
CLIPS	*code_post_process_initialize( CLIPS *tuple_list)
{
	CLIPS *tuple = 0;
	CLIPS *lists;
	CLIPS *tuple_next;
/*
 *	create the instructions based on the main flag
 */
	if( IS_FLAGS_MAIN( data.flags))
	{
		tuple = al_clips( I_MOV, 0, 0, MASK_LABEL | MASK_W_REG, "PORTA", sizeof( "PORTA") + 1);	/* read from stdin */
		tuple->next = al_clips( I_CALL, 0, 0, MASK_LABEL, "main", sizeof( "main") + 1);		/* call main */
	}
	lists = al_clips( I_GOTO, 0, 0, MASK_LABEL, "mloop", sizeof( "mloop") + 1);			/* goto mloop */
	tuple = clips_tail_to_head( tuple, lists);
/*
 *	check if no declaration or just function body
 */
	if( ! tuple_list || tuple_list->token == I_LABEL)
	{
		tuple = clips_tail_to_head( tuple, tuple_list);
		return( tuple);
	}
/*
 *	check if declaration list [ function body ]
 */
	for( lists = tuple_list; lists; lists = lists->next)
	{
		if( ! lists->next || lists->next->token == I_LABEL)	/* start of function body */
		{
			tuple_next = lists->next;
			lists->next = tuple;
			tuple_list = clips_tail_to_head( tuple_list, tuple_next);
			return( tuple_list);
		}
	}
	return( tuple_list);
}

/*
 *	post process the instruction list
 *	insert RETURNs for subroutines without returns
 */
CLIPS	*code_post_process_return( CLIPS *tuple_list)
{
	CLIPS *lists;
	CLIPS *tuple_next;
/*
 *	check if return, function body
 */
	for( lists = tuple_list; lists; lists = lists->next)
	{
		switch( lists->token)
		{
		case I_RETURN:
		case I_RETFIE:
		case I_RETLW:
			break;
		default:
			if( lists->next && lists->next->token == I_LABEL && ! lists->next->value)	/* start of function body */
			{
				tuple_next = lists->next;
				lists->next = al_clips( I_RETURN, 0, 0, MASK_INSTR, 0, 0);
				lists->next->next = tuple_next;
			}
		}
	}
	return( tuple_list);
}

/*
 *	post process the instruction list
 *	this gets messy because we have to fix lots of things
 */
CLIPS	*code_post_process( CLIPS *tuple_list)
{
/*
 *	insert post initialization code (goto mloop)
 */
	tuple_list = code_post_process_initialize( tuple_list);
/*
 *	insert RETURNs for subroutines without returns
 */
	tuple_list = code_post_process_return( tuple_list);
/*
 *	return fixed tuple instruction list
 */
	return( tuple_list);
}

/*
 *	code generator for the pic16f84 processor
		code_generator_pic16f84( $1.clips);
 */
void	code_generator_pic16f84( CLIPS *tuple_list)
{
	CLIPS *tuple;
/*
 *	debug tuple list
 */
#ifdef	YYDEBUG
	if( IS_FLAGS_DEBUG( data.flags))
		print_clips_list( tuple_list);
#endif
/*
 *	post process the instruction list
 */
	tuple_list = code_post_process( tuple_list);
/*
 *	generate the header
 */
	code_generator_pic_prefix();
/*
 *	walk the tuple list and generate PIC16F85 assembler code
 */
	for( tuple = tuple_list; tuple; tuple = tuple->next)
	{
		code_generator_instr( tuple);
	}
/*
 *	generate the end of pic code
 */
	code_generator_pic_postfix();
/*
 *	deallocate the tuple linked list
 */
	de_clips_list( tuple_list);
	return;
}

/*
 *	Test complete instruction set of PIC16F84
 */
void	code_generator_instr_test( void)
{
	CLIPS	*tuple;
	CLIPS	*tuple_head = 0;
	int	index;
/*
 *	loop thru the PIC instructions and generate and example of each
 *	instruction format. The generated instruction sequence does NOT
 *	represent a meaningful program!
 */
	for( index = 0; index <= 52; index++)
	{
		switch( index)
		{
		case 0:
/*    MOVLW   value        Place value in W */
			tuple = al_clips( I_MOV, 0x0f, 0, MASK_VALUE, 0, 0);
			break;
		case 1:
/*    MOVF    address,W    Copy contents of address to W */
			tuple = al_clips( I_MOV, 0, get_address(), MASK_ADDRESS | MASK_W_REG, 0, 0);
			break;
		case 2:
/*    MOVF    address,F    Copy contents of address to itself (not useless; sets Z flag if zero) */
			tuple = al_clips( I_MOV, 0, get_address(), MASK_ADDRESS | MASK_F_REG, 0, 0);
			break;
		case 3:
/*    MOVWF   address      Copy contents of W to address */
			tuple = al_clips( I_MOV, 0, get_address(), MASK_ADDRESS, 0, 0);
			break;
		case 4:
/*    ADDLW   value           Add W to value, place result in W */
			tuple = al_clips( I_ADD, 0x0f, 0, MASK_VALUE, 0, 0);
			break;
		case 5:
/*    ADDWF   address,W       Add W to contents of address, place result in W */
			tuple = al_clips( I_ADD, 0, get_address(), MASK_ADDRESS | MASK_W_REG, 0, 0);
			break;
		case 6:
/*    ADDWF   address,F       Add W to contents of address, store result at address */
			tuple = al_clips( I_ADD, 0, get_address(), MASK_ADDRESS | MASK_F_REG, 0, 0);
			break;
		case 7:
/*    ANDLW   value           Logical-AND W with value, place result in W */
			tuple = al_clips( I_AND, 0x0f, 0, MASK_VALUE, 0, 0);
			break;
		case 8:
/*    ANDWF   address,W       Logical-AND W with contents of address, place result in W */
			tuple = al_clips( I_AND, 0, get_address(), MASK_ADDRESS | MASK_W_REG, 0, 0);
			break;
		case 9:
/*    ANDWF   address,F       Logical-AND W with contents of address, store result at address */
			tuple = al_clips( I_AND, 0, get_address(), MASK_ADDRESS | MASK_F_REG, 0, 0);
			break;
		case 10:
/*    IORLW   value           Logical-OR W with value, place result in W */
			tuple = al_clips( I_IOR, 0x0f, 0, MASK_VALUE, 0, 0);
			break;
		case 11:
/*    IORWF   address,W       Logical-OR W with contents of address, place result in W */
			tuple = al_clips( I_IOR, 0, get_address(), MASK_ADDRESS | MASK_W_REG, 0, 0);
			break;
		case 12:
/*    IORWF   address,F       Logical-OR W with contents of address, store result at address */
			tuple = al_clips( I_IOR, 0, get_address(), MASK_ADDRESS | MASK_F_REG, 0, 0);
			break;
		case 13:
/*    SUBLW   value        Subtract W from value, place result in W */
			tuple = al_clips( I_SUB, 0x0f, 0, MASK_VALUE, 0, 0);
			break;
		case 14:
/*    SUBWF   address,W    Subtract W from contents of address, place result in W */
			tuple = al_clips( I_SUB, 0, get_address(), MASK_ADDRESS | MASK_W_REG, 0, 0);
			break;
		case 15:
/*    SUBWF   address,F    Subtract W from contents of address, store result at address */
			tuple = al_clips( I_SUB, 0, get_address(), MASK_ADDRESS | MASK_F_REG, 0, 0);
			break;
		case 16:
/*    XORLW   value        Logical-XOR W with value, place result in W */
			tuple = al_clips( I_XOR, 0x0f, 0, MASK_VALUE, 0, 0);
			break;
		case 17:
/*    XORWF   address,W    Logical-XOR W with contents of address, place result in W */
			tuple = al_clips( I_XOR, 0, get_address(), MASK_ADDRESS | MASK_W_REG, 0, 0);
			break;
		case 18:
/*    XORWF   address,F    Logical-XOR W with contents of address, store result at address */
			tuple = al_clips( I_XOR, 0, get_address(), MASK_ADDRESS | MASK_F_REG, 0, 0);
			break;
		case 19:
/*    BCF     address,bitnumber       Set specified bit to 0 */
			tuple = al_clips( I_BCF, 0x07, get_address(), MASK_VALUE | MASK_ADDRESS, 0, 0);
			break;
		case 20:
/*    BSF     address,bitnumber       Set specified bit to 1 */
			tuple = al_clips( I_BSF, 0x07, get_address(), MASK_VALUE | MASK_ADDRESS, 0, 0);
			break;
		case 21:
/*    BTFSC   address,bitnumber	Test bit, skip next instruction if bit is 0 */
			tuple = al_clips( I_BTFSC, 0x07, get_address(), MASK_VALUE | MASK_ADDRESS, 0, 0);
			break;
		case 22:
/*    BTFSS   address,bitnumber       Test bit, skip next instruction if bit is 1 */
			tuple = al_clips( I_BTFSS, 0x07, get_address(), MASK_VALUE | MASK_ADDRESS, 0, 0);
			break;
		case 23:
/*    COMF    address,W       Reverse all the bits of contents of address, place result in W */
			tuple = al_clips( I_COMF, 0, get_address(), MASK_ADDRESS | MASK_W_REG, 0, 0);
			break;
		case 24:
/*    COMF    address,F       Reverse all the bits of contents of address, store result at address */
			tuple = al_clips( I_COMF, 0, get_address(), MASK_ADDRESS | MASK_F_REG, 0, 0);
			break;
		case 25:
/*    DECF    address,W       Subtract 1 from contents of address, place result in W */
			tuple = al_clips( I_DECF, 0, get_address(), MASK_ADDRESS | MASK_W_REG, 0, 0);
			break;
		case 26:
/*    DECF    address,F       Subtract 1 from contents of address, store result at address */
			tuple = al_clips( I_DECF, 0, get_address(), MASK_ADDRESS | MASK_F_REG, 0, 0);
			break;
		case 27:
/*    DECFSZ  address,W       Like DECF address,W and skip next instruction if result is 0 */
			tuple = al_clips( I_DECFSZ, 0, get_address(), MASK_ADDRESS | MASK_W_REG, 0, 0);
			break;
		case 28:
/*    DECFSZ  address,F       Like DECF address,F and skip next instruction if result is 0 */
			tuple = al_clips( I_DECFSZ, 0, get_address(), MASK_ADDRESS | MASK_F_REG, 0, 0);
			break;
		case 29:
/*    INCF    address,W       Add 1 to contents of address, place result in W */
			tuple = al_clips( I_INCF, 0, get_address(), MASK_ADDRESS | MASK_W_REG, 0, 0);
			break;
		case 30:
/*    INCF    address,F       Add 1 to contents of address, store result at address */
			tuple = al_clips( I_INCF, 0, get_address(), MASK_ADDRESS | MASK_F_REG, 0, 0);
			break;
		case 31:
/*    INCFSZ  address,W       Like INCF address,W and skip next instruction if result is 0 */
			tuple = al_clips( I_INCFSZ, 0, get_address(), MASK_ADDRESS | MASK_W_REG, 0, 0);
			break;
		case 32:
/*    INCFSZ  address,F       Like INCF address,F and skip next instruction if result is 0 */
			tuple = al_clips( I_INCFSZ, 0, get_address(), MASK_ADDRESS | MASK_F_REG, 0, 0);
			break;
		case 33:
/*    RLF     address,W    Rotate bits left through carry flag, place result in W */
			tuple = al_clips( I_RLF, 0, get_address(), MASK_ADDRESS | MASK_W_REG, 0, 0);
			break;
		case 34:
/*    RLF     address,F    Rotate bits left through carry flag, store result at address */
			tuple = al_clips( I_RLF, 0, get_address(), MASK_ADDRESS | MASK_F_REG, 0, 0);
			break;
		case 35:
/*    RRF     address,W    Rotate bits right through carry flag, place result in W */
			tuple = al_clips( I_RRF, 0, get_address(), MASK_ADDRESS | MASK_W_REG, 0, 0);
			break;
		case 36:
/*    RRF     address,F    Rotate bits right through carry flag, store result at address */
			tuple = al_clips( I_RRF, 0, get_address(), MASK_ADDRESS | MASK_F_REG, 0, 0);
			break;
		case 37:
/*    SWAPF   address,W    Swap half-bytes at address, place result in W */
			tuple = al_clips( I_SWAPF, 0, get_address(), MASK_ADDRESS | MASK_W_REG, 0, 0);
			break;
		case 38:
/*    SWAPF   address,F    Swap half-bytes at address, store result at address */
			tuple = al_clips( I_SWAPF, 0, get_address(), MASK_ADDRESS | MASK_F_REG, 0, 0);
			break;
		case 39:
/*    CALL    label           Call subroutine (will return with RETURN or RETLW) */
			tuple = al_clips( I_CALL, 0, 0, MASK_LABEL, "main", sizeof( "main") + 1);
			break;
		case 40:
/*    GOTO    label           Jump to another location in the program */
			tuple = al_clips( I_GOTO, 0, 0, MASK_LABEL, "mloop", sizeof( "mloop") + 1);
			break;
		case 41:
/*    LABEL    label           create label in the program */
			tuple = al_clips( I_LABEL, 0, 0, MASK_LABEL, "main", sizeof( "main") + 1);
			break;
		case 42:
/*    TRIS    PORTA        Copy W into i/o control register for Port A (deprecated) */
			tuple = al_clips( I_TRIS, 0, 0, MASK_LABEL, "PORTA", sizeof("PORTA") + 1);
			break;
		case 43:
/*    TRIS    PORTB        Copy W into i/o control register for Port B (deprecated) */
			tuple = al_clips( I_TRIS, 0, 0, MASK_LABEL, "PORTB", sizeof( "PORTB") + 1);
			break;
		case 44:
/*    CLRW                    Set W to binary 00000000 */
			tuple = al_clips( I_CLR, 0, 0, MASK_W_REG, 0, 0);
			break;
		case 45:
/*    CLRF    address         Set contents of address to binary 00000000 */
			tuple = al_clips( I_CLR, 0, get_address(), MASK_ADDRESS | MASK_F_REG, 0, 0);
			break;
		case 46:
/*    CLRWDT                  Reset (clear) the watchdog timer */
			tuple = al_clips( I_CLRWDT, 0, 0, MASK_INSTR, 0, 0);
			break;
		case 47:
/*    NOP                  Do nothing */
			tuple = al_clips( I_NOP, 0, 0, MASK_INSTR, 0, 0);
			break;
		case 48:
/*    OPTION               Copy W to option register (deprecated instruction) */
			tuple = al_clips( I_OPTION, 0, 0, MASK_INSTR, 0, 0);
			break;
		case 49:
/*    SLEEP                Go into standby mode */
			tuple = al_clips( I_SLEEP, 0, 0, MASK_INSTR, 0, 0);
			break;
		case 50:
/*    RETURN               Return from subroutine */
			tuple = al_clips( I_RETURN, 0, 0, MASK_INSTR, 0, 0);
			break;
		case 51:
/*    RETFIE               Return from interrupt */
			tuple = al_clips( I_RETFIE, 0, 0, MASK_INSTR, 0, 0);
			break;
		case 52:
/*    RETLW   value        Return from subroutine, placing value into W */
			tuple = al_clips( I_RETLW, 0x0f, 0, MASK_VALUE, 0, 0);
			break;
		}
		tuple_head = clips_tail_to_head( tuple_head, tuple);
	}
	code_generator_pic16f84( tuple_head);
	return;
}

/*******************************************************************************
 *
 *	tuple parser production routines
 *
 ******************************************************************************/
/*
 *	convert primary expression identifier into tuple
		$$.clips = tuple_primary_expr_identifier( $1.clips);
 */
CLIPS	*tuple_primary_expr_identifier( CLIPS *clips)
{
	CLIPS	*symbol;
/*
 *	find the identifier in the symbol table (shall already be there!)
 */
	symbol = find_symbol( 0, clips->buffer, clips->length);
/*
 *	generate the intermediate code to mov address to w
 */
	if( symbol)
	{
		clips->token = I_MOV;
		clips->address = symbol->address;
		clips->mask = MASK_ADDRESS | MASK_W_REG;
	}
	return( clips);
}

/*
 *	convert primary expression constant into tuple
		$$.clips = tuple_primary_expr_constant( $1.clips);
 */
CLIPS	*tuple_primary_expr_constant( CLIPS *clips)
{
/*
 *	generate the intermediate code to mov constant value to w
 */
	clips->token = I_MOV;
	clips->mask = MASK_VALUE;
	return( clips);
}

/*
 *	generate initialize code for this list of identifiers
		$$.clips = tuple_declaration( $1.token, $$.clips);
 */
CLIPS	*tuple_declaration( int declaration_specifiers, CLIPS *init_declarator_list)
{
	CLIPS	*lists;
	CLIPS	*symbol;
	CLIPS	*tuple;
	CLIPS	*tuple_head = 0;
/*
 *	can be a list of identifiers
 */
	for( lists = init_declarator_list; lists; lists = lists->next)
	{
/*
 *	find the identifier in the symbol table (shall already be there!)
 */
		symbol = find_symbol( 0, lists->buffer, lists->length);
/*
 *	generate the intermediate code to initialize the variables
 */
		if( symbol)
		{
			if( symbol->level == 0 || symbol->value)
			{
				tuple = al_clips( I_MOV, symbol->value, 0, MASK_VALUE, 0, 0);
				tuple_head = clips_tail_to_head( tuple_head, tuple);
			}
			tuple = al_clips( I_MOV, 0, symbol->address, MASK_ADDRESS, 0, 0);
			tuple_head = clips_tail_to_head( tuple_head, tuple);
		}
	}
	de_clips_list( init_declarator_list);
	return( tuple_head);
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
	{
		$$.clips = tuple_primary_expr_identifier( $1.clips);
	}
	| CONSTANT
	{
#ifdef	YYDEBUG
		if( IS_FLAGS_DEBUG( data.flags))
			print_clips_list( $1.clips);
#endif
		$$.clips = tuple_primary_expr_constant( $1.clips);
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
			$$.clips = tuple_declaration( $1.token, $$.clips);
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
		code_generator_pic16f84( $1.clips);
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

