/* user and group to drop privileges to */
static const char *user  = "nobody";
static const char *group = "nobody"; // use "nobody" for arch

static const char *colorname[NUMCOLS] = {
	[INIT] =   "black",     /* after initialization */
	[INPUT] =  "#005577",   /* during input */
	[FAILED] = "#CC3333",   /* wrong password */
	[CAPS] =   "green",       /* CapsLock on */
};


/* Background image path, should be available to the user above */
static const char * background_image = "/usr/share/backgrounds/bg.jpg";


/*
 * Xresources preferences to load at startup
 */
ResourcePref resources[] = {
		{ "bg_image",     STRING,  &background_image },
		{ "locked",       STRING,  &colorname[INIT] },
		{ "input",        STRING,  &colorname[INPUT] },
		{ "failed",       STRING,  &colorname[FAILED] },
		{ "capslock",     STRING,  &colorname[CAPS] },
};


/* treat a cleared input like a wrong password (color) */
static const int failonclear = 0;






/* time in seconds before the monitor shuts down */
static const int monitortime = 600;



