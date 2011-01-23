/*
 *	define a clips structure
 *	supports: CONSTANT STRING_LITERAL IDENTIFIER types
 */
#define	CLIPS	struct clips
CLIPS
{
	CLIPS		*next;
	int		token;
	unsigned char	value;
	int		address;
#define	MASK_VALUE	0x0001
#define	MASK_ADDRESS	0x0002
#define	MASK_LABEL	0x0004
#define	MASK_W_REG	0x0008
#define	MASK_F_REG	0x0010
#define	MASK_INSTR	0x0020
	int		mask;
	char		*buffer;
	int		length;
	int		level;
};

/*
 *	define yystype
 */
#define YYSTYPE union yyansi_c
YYSTYPE
{
	int	token;
	CLIPS	*clips;
};

