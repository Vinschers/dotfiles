#include <ctype.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

static char currenticons[NUMTAGS][10];

char *
geticon(Monitor *m, int tag, int iconset)
{
	int i;
	int tagindex = tag + NUMTAGS * m->num;
	for (i = 0; i < LENGTH(tagicons[iconset]) && tagicons[iconset][i] != NULL; ++i);
	if (i == 0)
		tagindex = 0;
	else if (tagindex >= i)
		tagindex = tagindex % i;

	return tagicons[iconset][tagindex];
}

void
tolowerstr(char *dest, const char *src)
{
	unsigned char *p = NULL;

	for (p = (unsigned char *)src; *p; ++p)
		*(dest++) = tolower(*p);
	*dest = 0;
}

char *
gettagsuperscript(int tag)
{
	switch (tag) {
		case 0:
			return "¹";
		case 1:
			return "²";
		case 2:
			return "³";
		case 3:
			return "⁴";
		case 4:
			return "⁵";
		case 5:
			return "⁶";
		case 6:
			return "⁷";
		case 7:
			return "⁸";
		case 8:
			return "⁹";
	}

	return "";
}

unsigned char
hex_to_dec(const char *hex)
{
    unsigned char ret = 0;

    if (hex[0] >= 'a')
        ret += hex[0] - 'a' + 10;
    else
        ret += hex[0] - '0';
    ret <<= 4;

    if (hex[1] >= 'a')
        ret += hex[1] - 'a' + 10;
    else
        ret += hex[1] - '0';

    return ret;
}

void
change_scheme(char *color, Clr *scheme)
{
    char lowercolor[10];
    unsigned short red, green, blue;

    tolowerstr(lowercolor, color + 1); // Remove #

    red = hex_to_dec(lowercolor);
    green = hex_to_dec(lowercolor + 2);
    blue = hex_to_dec(lowercolor + 4);

    scheme->color.red = red << 8;
    scheme->color.green = green << 8;
    scheme->color.blue = blue << 8;
}

unsigned char
containsstr(char *str1, char *str2)
{
    char *ptr;

    for (ptr = str1; *ptr; ++ptr) {
        if (ptr == str1 || *(ptr - 1) == ' ')
            if (strncmp(ptr, str2, strlen(str2)) == 0)
                return 1;
    }

    return 0;
}

void
setoccupiedicon(Monitor *m, int tag, Picture *img, int *imgw, int *imgh)
{
    Client *c;
    unsigned short i = 0;
	char *tagsuperscript = gettagsuperscript(tag), lowername[200], currentname[200];
    char *icon = currenticons[tag];

    *imgw = 0;
    *imgh = 0;

    for (c = m->clients; c && !(c->tags & 1 << tag); c = c->next) {}
	if (!c) {
        *icon = '\0';
        return;
    }

	tolowerstr(lowername, c->name);

	for (i = 0; i < LENGTH(occupiedicons); ++i) {
		tolowerstr(currentname, occupiedicons[i][0]);

		if (containsstr(lowername, currentname)) {
            sprintf(icon, "%s%s", occupiedicons[i][1], tagsuperscript);

            if (occupiedicons[i][2][0] != '\0') // if there is a new color for the icon
                change_scheme(occupiedicons[i][2], scheme[SchemeTagsNorm]);

            return;
		}
	}

    if (c->icon) {
        *img = c->icon;
        *imgw = c->icw;
        *imgh = c->ich;
        strcpy(icon, tagsuperscript);
    } else {
        strcpy(icon, geticon(m, tag, IconsOccupied));
    }
}

char *
tagicon(Monitor *m, int tag, Picture *img, int *imgw, int *imgh)
{
    char *icon = currenticons[tag];

    change_scheme(colors[SchemeTagsNorm][0], scheme[SchemeTagsNorm]);
	setoccupiedicon(m, tag, img, imgw, imgh);

	if (*icon == '\0') {
        strcpy(icon, geticon(m, tag, IconsDefault));

		if (TEXTW(icon) <= lrpad && m->tagset[m->seltags] & 1 << tag)
            strcpy(icon, geticon(m, tag, IconsVacant));
	}

	return icon;
}
