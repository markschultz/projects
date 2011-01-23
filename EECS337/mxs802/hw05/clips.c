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

