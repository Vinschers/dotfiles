#define BAR_OFFSET 2

int
width_tag(Bar *bar, int tag)
{
    Monitor *m = bar->mon;
    int w = 0, tw, imgw, imgh;
    Picture img;

    tw = TEXTW(tagicon(m, tag, &img, &imgw, &imgh));

    if (tw <= lrpad)
        return 0;

    tw += imgw;

    if (tw > lrpad)
        w += tw;

    return w;
}

int
width_tags(Bar *bar, BarArg *a)
{
	int w, i;

	for (w = 0, i = 0; i < NUMTAGS; i++) {
        w += width_tag(bar, i);
	}

	return w + BAR_OFFSET;
}

int
draw_tags(Bar *bar, BarArg *a)
{
	int invert;
	int w, x = a->x;
	unsigned int i, occ = 0, urg = 0;
	char *icon;
	Monitor *m = bar->mon;
	Client *c;
    Picture img;
    int imgw, imgh;

	for (c = m->clients; c; c = c->next) {
		occ |= c->tags;
		if (c->isurgent)
			urg |= c->tags;
	}

	for (i = 0; i < NUMTAGS; i++) {
		icon = tagicon(bar->mon, i, &img, &imgw, &imgh);
		invert = 0;
		w = TEXTW(icon);

        if (imgw > 0)
            w += imgw;

        if (w <= lrpad)
            continue;

		drw_setscheme(drw, scheme[
			m->tagset[m->seltags] & 1 << i
			? SchemeTagsSel
			: urg & 1 << i
			? SchemeUrg
			: SchemeTagsNorm
		]);

        drw_text(drw, x, a->y, w, a->h, lrpad / 2, "", invert, False);

        if (imgw > 0) {
            drw_text(drw, x + BAR_OFFSET + imgw, a->y, TEXTW(icon), a->h, lrpad / 2, icon, invert, False);
            drw_pic(drw, x + BAR_OFFSET + lrpad / 2, a->y + (a->h - imgh)/2, imgw, imgh, img);
        } else {
            drw_text(drw, x + BAR_OFFSET, a->y, w, a->h, lrpad / 2, icon, invert, False);
            drw_text(drw, x + w, a->y, w, a->h, lrpad / 2, "", invert, False);
        }

		drawindicator(m, NULL, occ, x, a->y, w, a->h, i, -1, invert, tagindicatortype);
		if (ulineall || m->tagset[m->seltags] & 1 << i) {
            if (i == 0)
			    drw_rect(drw, x + ulinepad + BAR_OFFSET, bh - ulinestroke - ulinevoffset, w - (ulinepad * 2), ulinestroke, 1, 0);
            else
			    drw_rect(drw, x + ulinepad + BAR_OFFSET/2, bh - ulinestroke - ulinevoffset, w - (ulinepad * 2), ulinestroke, 1, 0);
        }
		x += w;
	}

	return 1;
}

int
click_tags(Bar *bar, Arg *arg, BarArg *a)
{
	int i = 0, x = 0;

	do {
        x += width_tag(bar, i);
	} while (a->x >= x && ++i < NUMTAGS);
	if (i < NUMTAGS) {
		arg->ui = 1 << i;
	}
	return ClkTagBar;
}

int
hover_tags(Bar *bar, BarArg *a, XMotionEvent *ev)
{
	int i = 0, x = lrpad / 2;
	int px, py;
	Monitor *m = bar->mon;
	int ov = gappov;
	int oh = gappoh;


	do {
        x += width_tag(bar, i);
	} while (a->x >= x && ++i < NUMTAGS);

	if (i < NUMTAGS) {
		if ((i + 1) != selmon->previewshow && !(selmon->tagset[selmon->seltags] & 1 << i)) {
			if (bar->by > m->my + m->mh / 2) // bottom bar
				py = bar->by - m->mh / scalepreview - oh;
			else // top bar
				py = bar->by + bar->bh + oh;
			px = bar->bx + ev->x - m->mw / scalepreview / 2;
			if (px + m->mw / scalepreview > m->mx + m->mw)
				px = m->wx + m->ww - m->mw / scalepreview - ov;
			else if (px < bar->bx)
				px = m->wx + ov;
			selmon->previewshow = i + 1;
			showtagpreview(i, px, py);
		} else if (selmon->tagset[selmon->seltags] & 1 << i) {
			hidetagpreview(selmon);
		}
	} else if (selmon->previewshow != 0) {
		hidetagpreview(selmon);
	}

	return 1;
}
