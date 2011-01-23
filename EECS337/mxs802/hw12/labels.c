/*
 *	create the next label
 */
int	next_label( char *buffer)
{
	sprintf( buffer, "label%d", data.label++);
	return( strlen( buffer) + 1);
}

/*
 *	convert and expression into tuple
		$$.clips = tuple_and_expr( I_AND, $1.clips, $3.clips);
 */
CLIPS	*tuple_and_expr( int instr, CLIPS *and_expr, CLIPS *equality_expr)
{
	and_expr->token = instr;
	and_expr->mask = MASK_ADDRESS | MASK_W_REG;
	clips_tail_to_head( equality_expr, and_expr);
	return( equality_expr);
}

/*
 *	convert selection statement into tuple
		$$.clips = tuple_selection_statement( $3.clips, $5.clips);
 */
CLIPS	*tuple_selection_statement( CLIPS *expr, CLIPS *statement)
{
	char	buffer1[ 32];
	int	length1;
	CLIPS	*tuple;

	length1 = next_label( buffer1);
	tuple = end_clips( expr);
	tuple->next = al_clips( I_BTFSC, 0x02, 0x03, MASK_ADDRESS | MASK_VALUE, 0, 0);
	tuple->next->next = al_clips( I_GOTO, 0, 0, MASK_LABEL, buffer1, length1);
	clips_tail_to_head( tuple, statement);
	tuple = end_clips( statement);
	tuple->next = al_clips( I_LABEL, length1, 0, MASK_LABEL, buffer1, length1);
	return( expr);
}

/*
 *	iteration selection statement into tuple
		$$.clips = tuple_iteration_statement( $3.clips, $5.clips);
 */
CLIPS	*tuple_iteration_statement( CLIPS *expr, CLIPS *statement)
{
	char	buffer1[ 32];
	int	length1;
	char	buffer2[ 32];
	int	length2;
	CLIPS	*tuple;
	CLIPS	*clips;
/*
 *	create the next temporary label
 */
	length1 = next_label( buffer1);
	length2 = next_label( buffer2);
	tuple = al_clips( I_LABEL, length1, 0, MASK_LABEL, buffer1, length1);
	tuple->next = expr;
	clips = end_clips( expr);
	clips->next = al_clips( I_BTFSC, 0x02, 0x03, MASK_ADDRESS | MASK_VALUE, 0, 0);
	clips->next->next = al_clips( I_GOTO, 0, 0, MASK_LABEL, buffer2, length2);
	clips_tail_to_head( clips, statement);
	clips = end_clips( statement);
	clips->next = al_clips( I_GOTO, 0, 0, MASK_LABEL, buffer1, length1);
	clips->next->next = al_clips( I_LABEL, length2, 0, MASK_LABEL, buffer2, length2);
	return( tuple);
}

/*
 *	convert jump statement goto into tuple
		$$.clips = tuple_jump_statement_goto( $2.clips);
 */
CLIPS	*tuple_jump_statement_goto( CLIPS *identifier)
{
	identifier->token = I_GOTO;
	identifier->mask = MASK_LABEL;
	return( identifier);
}

/*
 *	convert labeled statement into tuple
		$$.clips = tuple_labeled_statement( $2.clips);
 */
CLIPS	*tuple_labeled_statement( CLIPS *identifier, CLIPS *statement)
{
	identifier->token = I_LABEL;
	identifier->mask = MASK_LABEL;
	identifier->value = 1;	/* set this to not generate a return in front of this label */
	clips_tail_to_head( identifier, statement);
	return( identifier);
}

