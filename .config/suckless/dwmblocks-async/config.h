#define CMDLENGTH 1000
#define DELIMITER "  "
#define LEADING_DELIMITER " "
#define CLICKABLE_BLOCKS

const Block blocks[] = {
	// BLOCK("sb-network",     1,      8),
	// BLOCK("sb-price",       60,     7),
	BLOCK("sb-weather",     60,     7),
	BLOCK("sb-hololive",    60,     6),
	BLOCK("sb-music",       2,      5),
	BLOCK("sb-keyboard",    0,      4),
	BLOCK("sb-hardware",    2,      3),
	BLOCK("sb-battery",     30,     2),
	BLOCK("sb-datetime",    1,      1)
};
