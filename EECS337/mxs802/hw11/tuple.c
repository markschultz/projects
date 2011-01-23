/*
 *	convert postfix expression into tuple
		$$.clips = tuple_postfix_expr( $1.clips, 0);
		$$.clips = tuple_postfix_expr( $1.clips, $3.clips);
 */
CLIPS	*tuple_postfix_expr( CLIPS *postfix_expr, CLIPS *argument_expr_list)
{
	CLIPS	*lists;
	CLIPS	*tuple_next;
/*
 *	special case is printf, after each argument insert call to printf
 */
	if( ! strcmp( postfix_expr->buffer, "printf"))
	{
		for( lists = argument_expr_list; lists; )
		{
			if( lists->mask & MASK_W_REG)
			{
				tuple_next = lists->next;
				lists->next = al_clips( I_CALL, 0, 0, MASK_LABEL, "printf", sizeof( "printf") + 1); /* call printf */
				lists->next->next = tuple_next;
				lists = lists->next->next;
			}
			else
			{
				lists = lists->next;
			}
		}
		de_clips_list( postfix_expr);
		return( argument_expr_list);
	}
	postfix_expr->token = I_CALL;
	postfix_expr->mask = MASK_LABEL;
	clips_tail_to_head( postfix_expr, argument_expr_list);
	return( postfix_expr);
}

/*
 *	convert additive expression into tuple
		$$.clips = tuple_additive_expr( I_ADD, $1.clips, $3.clips);
		$$.clips = tuple_additive_expr( I_SUB, $1.clips, $3.clips);
 */
CLIPS	*tuple_additive_expr( int instr, CLIPS *additive_expr, CLIPS *multiplicative_expr)
{
	additive_expr->token = instr;
	additive_expr->mask = MASK_ADDRESS | MASK_W_REG;
	clips_tail_to_head( multiplicative_expr, additive_expr);
	return( multiplicative_expr);
}

/*
 *	convert assignment expression into tuple
		$$.clips = tuple_assignment_expr( $1.clips, $2.token, $3.clips);
 */
CLIPS	*tuple_assignment_expr( CLIPS *unary_expr, int assignment_operator, CLIPS *assignment_expr)
{
	unary_expr->token = I_MOV;
	unary_expr->mask = MASK_ADDRESS;
	clips_tail_to_head( assignment_expr, unary_expr);
	return( assignment_expr);
}

/*
 *	if main( int argc, char *argv[]) then delete parameters
		$$.clips = tuple_parameter_list( $1.clips, $3.clips);
 */
CLIPS	*tuple_parameter_list( CLIPS *parameter_list, CLIPS *parameter_declaration)
{
	de_clips_list( parameter_list);
	de_clips_list( parameter_declaration);
	return( (CLIPS*)0);
}

/*
 *	convert jump statement into tuple
		$$.clips = tuple_jump_statement( $2.clips);
 */
CLIPS	*tuple_jump_statement( CLIPS *return_expr)
{
	CLIPS	*tuple;

	tuple = end_clips( return_expr);
	if( tuple->token == I_MOV && tuple->mask == MASK_VALUE)
		tuple->token = I_RETLW;
	else
		tuple->next = al_clips( I_RETURN, 0, 0, MASK_INSTR, 0, 0);
	return( return_expr);
}

/*
 *	convert function definition into tuple 
		$$.clips = tuple_function_definition( 0, $1.clips, $2.clips);
		$$.clips = tuple_function_definition( $1.token, $2.clips, $3.clips);
 */
CLIPS	*tuple_function_definition( int declaration_specifiers, CLIPS *declarator, CLIPS *function_body)
{
	CLIPS	*tuple;

	if( ! strcmp( declarator->buffer, "main"))
		SET_FLAGS_MAIN( data.flags);
	declarator->token = I_LABEL;
	declarator->mask = MASK_LABEL;
	tuple = clips_tail_to_head( declarator, function_body);
	return( tuple);
}

