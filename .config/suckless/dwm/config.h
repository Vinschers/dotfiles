/* See LICENSE file for copyright and license details. */

#include <X11/XF86keysym.h>

/* appearance */
static const unsigned int borderpx      = 3;        /* border pixel of windows */
static const unsigned int snap          = 32;       /* snap pixel */
static const int scalepreview           = 4;        /* Tag preview scaling */
static const unsigned int gappih        = 20;       /* horiz inner gap between windows */
static const unsigned int gappiv        = 10;       /* vert inner gap between windows */
static const unsigned int gappoh        = 6;       /* horiz outer gap between windows and screen edge */
static const unsigned int gappov        = 12;       /* vert outer gap between windows and screen edge */
static const int smartgaps_fact         = 1;   /* gap factor when there is only one client; 0 = no gaps, 3 = 3x outer gaps */
static const char autostartblocksh[]    = "autostart_blocking.sh";
static const char autostartsh[]         = "autostart.sh";
static const char dwmdir[]              = "dwm";
static const char localshare[]          = ".local/share";
static const int showbar                = 0;        /* 0 means no bar */
static const int topbar                 = 1;        /* 0 means bottom bar */

#define ICONSIZE 15    /* icon size */
#define ICONSPACING 5  /* space between icon and title */
#define FLEXWINTITLE_BORDERS 0       // 0 = off, 1 = on

/* Status is to be shown on: -1 (all monitors), 0 (a specific monitor by index), 'A' (active monitor) */
static const int statusmon               = -1;
static const int horizpadbar             = 0;   /* horizontal padding for statusbar */
static const int vertpadbar              = 4;   /* vertical padding for statusbar */
static const unsigned int systrayspacing = 2;   /* systray spacing */
static const int showsystray             = 1;   /* 0 means no systray */
static const unsigned int ulinepad       = 5;   /* horizontal padding between the underline and tag */
static const unsigned int ulinestroke    = 2;   /* thickness / height of the underline */
static const unsigned int ulinevoffset   = 0;   /* how far above the bottom of the bar the line should appear */
static const int ulineall                = 0;   /* 1 to show underline on all tags, 0 for just the active ones */

/* Indicators: see patch/bar_indicators.h for options */
static int tagindicatortype              = INDICATOR_NONE;
static int tiledindicatortype            = INDICATOR_NONE;
static int floatindicatortype            = INDICATOR_NONE;
static void (*bartabmonfns[])(Monitor *) = { monocle /* , customlayoutfn */ };
static const int quit_empty_window_count = 0;   /* only allow dwm to quit if no (<= count) windows are open */

static const char *fonts[] = {
    "Source Code Pro:size=12:style=bold",
    "fontawesome:size=12",
    "fontawesomebrands:size=12",
    "JetBrainsMono Nerd Font:size=12",
    "JoyPixels:size=12",
    "Noto Color Emoji:size=12",
    "Latin Modern Math:size=15",
    "Hack Nerd Font Mono:size=12",
    "SourceHanMono:size=15"
};
static const char dmenufont[]       = "Source Code Pro:size=12";

// static const unsigned int baralpha = 0xd0;
// static const unsigned int borderalpha = OPAQUE;

#include "themes/custom.h"

/* tagging: refer to https://github.com/bakkeby/patches/wiki/tagicons */
static char *tagicons[][NUMTAGS] = {
	[IconsDefault]        		= { "" },
	[IconsVacant]        		= { "1", "2", "3", "4", "5", "6", "7", "8", "9" },
	[IconsOccupied]		       	= { "①", "②", "③", "④", "⑤", "⑥", "⑦", "⑧", "⑨" },
};

static char occupiedicons[][3][50] = {
	{ "vim",		    "",    "#019833" },
	{ "neovim",		    "",    "#019833" },
    { "htop",           "",    "#BA9FD7" },
    { "gtop",           "",    "#BA9FD7" },
	{ "zathura", 		"",    "#DC1D00" },
	{ "okular", 		"",    "#DC1D00" },
	{ "sxiv", 		    "",    "" },
	{ "spotui", 		"",    "#1DB954" },
	{ "spotify", 		"",    "#1DB954" },
	{ "zotero",		    "📚",   "" },
	{ "webcam",		    "犯",   "" },
};

/* There are two options when it comes to per-client rules:
 *  - a typical struct table or
 *  - using the RULE macro
 *
 * A traditional struct table looks like this:
 *    // class      instance  title  wintype  tags mask  isfloating  monitor
 *    { "Gimp",     NULL,     NULL,  NULL,    1 << 4,    0,          -1 },
 *    { "Firefox",  NULL,     NULL,  NULL,    1 << 7,    0,          -1 },
 *
 * The RULE macro has the default values set for each field allowing you to only
 * specify the values that are relevant for your rule, e.g.
 *
 *    RULE(.class = "Gimp", .tags = 1 << 4)
 *    RULE(.class = "Firefox", .tags = 1 << 7)
 *
 * Refer to the Rule struct definition for the list of available fields depending on
 * the patches you enable.
 */
static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 *	WM_WINDOW_ROLE(STRING) = role
	 *	_NET_WM_WINDOW_TYPE(ATOM) = wintype
	 */
	RULE(.wintype = WTYPE "DIALOG", .isfloating = 1)
	RULE(.wintype = WTYPE "UTILITY", .isfloating = 1)
	RULE(.wintype = WTYPE "TOOLBAR", .isfloating = 1)
	RULE(.wintype = WTYPE "SPLASH", .isfloating = 1)
};

/* Bar rules allow you to configure what is shown where on the bar, as well as
 * introducing your own bar modules.
 *
 *    monitor:
 *      -1  show on all monitors
 *       0  show on monitor 0
 *      'A' show on active monitor (i.e. focused / selected) (or just -1 for active?)
 *    bar - bar index, 0 is default, 1 is extrabar
 *    alignment - how the module is aligned compared to other modules
 *    widthfunc, drawfunc, clickfunc - providing bar module width, draw and click functions
 *    name - does nothing, intended for visual clue and for logging / debugging
 */
static const BarRule barrules[] = {
	/* monitor   bar    alignment         widthfunc                 drawfunc                clickfunc                hoverfunc                name */
	{ -1,        0,     BAR_ALIGN_LEFT,   width_tags,               draw_tags,              click_tags,              hover_tags,              "tags" },
	{  0,        0,     BAR_ALIGN_RIGHT,  width_systray,            draw_systray,           click_systray,           NULL,                    "systray" },
	{ -1,        0,     BAR_ALIGN_LEFT,   width_ltsymbol,           draw_ltsymbol,          click_ltsymbol,          NULL,                    "layout" },
	{ statusmon, 0,     BAR_ALIGN_RIGHT,  width_status2d,           draw_status2d,          click_statuscmd,         NULL,                    "status2d" },
	{ -1,        0,     BAR_ALIGN_NONE,   width_bartabgroups,       draw_bartabgroups,      click_bartabgroups,      NULL,                    "bartabgroups" },
};

/* layout(s) */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int nstack      = 0;    /* number of clients in primary stack area */
static const int resizehints = 0;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */
static const int decorhints  = 1;    /* 1 means respect decoration hints */

#define FORCE_VSPLIT 1

static const Layout layouts[] = {
	/* symbol     arrange function, { nmaster, nstack, layout, master axis, stack axis, secondary stack axis, symbol func } */
	{ "[]=",      flextile,         { -1, -1, SPLIT_VERTICAL, TOP_TO_BOTTOM, TOP_TO_BOTTOM, 0, NULL } }, // default tile layout
 	{ "><>",      NULL,             {0} },    /* no layout function means floating behavior */
	{ "[M]",      flextile,         { -1, -1, NO_SPLIT, MONOCLE, MONOCLE, 0, NULL } }, // monocle
	{ "|||",      flextile,         { -1, -1, SPLIT_VERTICAL, LEFT_TO_RIGHT, TOP_TO_BOTTOM, 0, NULL } }, // columns (col) layout
	{ ">M>",      flextile,         { -1, -1, FLOATING_MASTER, LEFT_TO_RIGHT, LEFT_TO_RIGHT, 0, NULL } }, // floating master
	{ "[D]",      flextile,         { -1, -1, SPLIT_VERTICAL, TOP_TO_BOTTOM, MONOCLE, 0, NULL } }, // deck
	{ "TTT",      flextile,         { -1, -1, SPLIT_HORIZONTAL, LEFT_TO_RIGHT, LEFT_TO_RIGHT, 0, NULL } }, // bstack
	{ "===",      flextile,         { -1, -1, SPLIT_HORIZONTAL, LEFT_TO_RIGHT, TOP_TO_BOTTOM, 0, NULL } }, // bstackhoriz
	{ "|M|",      flextile,         { -1, -1, SPLIT_CENTERED_VERTICAL, LEFT_TO_RIGHT, TOP_TO_BOTTOM, TOP_TO_BOTTOM, NULL } }, // centeredmaster
	{ "-M-",      flextile,         { -1, -1, SPLIT_CENTERED_HORIZONTAL, TOP_TO_BOTTOM, LEFT_TO_RIGHT, LEFT_TO_RIGHT, NULL } }, // centeredmaster horiz
	{ ":::",      flextile,         { -1, -1, NO_SPLIT, GAPPLESSGRID, GAPPLESSGRID, 0, NULL } }, // gappless grid
	{ "[\\]",     flextile,         { -1, -1, NO_SPLIT, DWINDLE, DWINDLE, 0, NULL } }, // fibonacci dwindle
	{ "(@)",      flextile,         { -1, -1, NO_SPLIT, SPIRAL, SPIRAL, 0, NULL } }, // fibonacci spiral
	{ "[T]",      flextile,         { -1, -1, SPLIT_VERTICAL, LEFT_TO_RIGHT, TATAMI, 0, NULL } }, // tatami mats
	{ "[]=",      tile,             {0} },
	{ "[M]",      monocle,          {0} },
	{ "TTT",      bstack,           {0} },
	{ "===",      bstackhoriz,      {0} },
	{ "|M|",      centeredmaster,   {0} },
	{ ">M>",      centeredfloatingmaster, {0} },
	{ "|||",      col,              {0} },
	{ "[D]",      deck,             {0} },
	{ "(@)",      spiral,           {0} },
	{ "[\\]",     dwindle,          {0} },
	{ "HHH",      grid,             {0} },
	{ "---",      horizgrid,        {0} },
	{ ":::",      gaplessgrid,      {0} },
	{ "###",      nrowgrid,         {0} },
	{ NULL,       NULL,             {0} },
};

static const unsigned int defaultlayouts[] = {
    0,  /* 0 clients */
    2,  /* 1 client */
    0,  /* 2 clients */
    18,  /* 3 clients */
    24, /* >= 4 clients */
};

/* key definitions */
#define MODKEY Mod4Mask
#define ALTKEY Mod1Mask
#define CAPSKEY 0xffe5
#define KP_ENTER 0xff8d

#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }
#define SHICMD(cmd) { .v = (const char*[]){ "/bin/sh", "-e", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = {
	"dmenu_run",
	"-m", dmenumon,
	"-fn", dmenufont,
	"-nb", normbgcolor,
	"-nf", normfgcolor,
	"-sb", selbgcolor,
	"-sf", selfgcolor,
	NULL
};
static const char *termcmd[]  = { "st", NULL };

/* This defines the name of the executable that handles the bar (used for signalling purposes) */
#define STATUSBAR "dwmblocks"

static Key keys[] = {
	/* modifier                     key            function                argument */
	{ MODKEY,                       XK_p,          spawn,                  {.v = dmenucmd } },
	{ MODKEY|ShiftMask,             XK_Return,     spawn,                  {.v = termcmd } },
	{ MODKEY|ShiftMask,             KP_ENTER,      spawn,                  {.v = termcmd } },
	{ MODKEY,                       XK_b,          togglebar,              {0} },
	{ MODKEY,                       XK_j,          focusstack,             {.i = +1 } },
	{ MODKEY,                       XK_k,          focusstack,             {.i = -1 } },
	{ MODKEY,                       XK_i,          incnmaster,             {.i = +1 } },
	{ MODKEY,                       XK_d,          incnmaster,             {.i = -1 } },
	{ MODKEY|ControlMask,           XK_i,          incnstack,              {.i = +1 } },
	{ MODKEY|ControlMask,           XK_u,          incnstack,              {.i = -1 } },
	{ MODKEY,                       XK_h,          setmfact,               {.f = -0.05} },
	{ MODKEY,                       XK_l,          setmfact,               {.f = +0.05} },
	{ MODKEY|ShiftMask,             XK_h,          setcfact,               {.f = +0.25} },
	{ MODKEY|ShiftMask,             XK_l,          setcfact,               {.f = -0.25} },
	{ MODKEY|ShiftMask,             XK_o,          setcfact,               {0} },
	{ MODKEY,                       XK_Return,     zoom,                   {0} },
	{ MODKEY|Mod4Mask,              XK_u,          incrgaps,               {.i = +1 } },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_u,          incrgaps,               {.i = -1 } },
	{ MODKEY|Mod4Mask,              XK_i,          incrigaps,              {.i = +1 } },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_i,          incrigaps,              {.i = -1 } },
	{ MODKEY|Mod4Mask,              XK_o,          incrogaps,              {.i = +1 } },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_o,          incrogaps,              {.i = -1 } },
	{ MODKEY|Mod4Mask,              XK_6,          incrihgaps,             {.i = +1 } },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_6,          incrihgaps,             {.i = -1 } },
	{ MODKEY|Mod4Mask,              XK_7,          incrivgaps,             {.i = +1 } },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_7,          incrivgaps,             {.i = -1 } },
	{ MODKEY|Mod4Mask,              XK_8,          incrohgaps,             {.i = +1 } },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_8,          incrohgaps,             {.i = -1 } },
	{ MODKEY|Mod4Mask,              XK_9,          incrovgaps,             {.i = +1 } },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_9,          incrovgaps,             {.i = -1 } },
	{ MODKEY|Mod4Mask,              XK_0,          togglegaps,             {0} },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_0,          defaultgaps,            {0} },
	{ MODKEY,                       XK_Tab,        view,                   {0} },
	{ MODKEY|ControlMask,           XK_z,          showhideclient,         {0} },
	{ MODKEY|ShiftMask,             XK_c,          killclient,             {0} },
	{ MODKEY|ShiftMask,             XK_q,          quit,                   {0} },
	{ MODKEY|ShiftMask,             XK_F5,         xrdb,                   {.v = NULL } },
	{ MODKEY,                       XK_t,          setlayout,              {.v = &layouts[0]} },
	{ MODKEY,                       XK_f,          setlayout,              {.v = &layouts[1]} },
	{ MODKEY,                       XK_m,          setlayout,              {.v = &layouts[2]} },
	{ MODKEY,                       XK_c,          setlayout,              {.v = &layouts[3]} },
	{ MODKEY|ControlMask,           XK_t,          rotatelayoutaxis,       {.i = +1 } },   /* flextile, 1 = layout axis */
	{ MODKEY|ControlMask,           XK_Tab,        rotatelayoutaxis,       {.i = +2 } },   /* flextile, 2 = master axis */
	{ MODKEY|ControlMask|ShiftMask, XK_Tab,        rotatelayoutaxis,       {.i = +3 } },   /* flextile, 3 = stack axis */
	{ MODKEY|ControlMask|Mod1Mask,  XK_Tab,        rotatelayoutaxis,       {.i = +4 } },   /* flextile, 4 = secondary stack axis */
	{ MODKEY|Mod5Mask,              XK_t,          rotatelayoutaxis,       {.i = -1 } },   /* flextile, 1 = layout axis */
	{ MODKEY|Mod5Mask,              XK_Tab,        rotatelayoutaxis,       {.i = -2 } },   /* flextile, 2 = master axis */
	{ MODKEY|Mod5Mask|ShiftMask,    XK_Tab,        rotatelayoutaxis,       {.i = -3 } },   /* flextile, 3 = stack axis */
	{ MODKEY|Mod5Mask|Mod1Mask,     XK_Tab,        rotatelayoutaxis,       {.i = -4 } },   /* flextile, 4 = secondary stack axis */
	{ MODKEY|ControlMask,           XK_Return,     mirrorlayout,           {0} },          /* flextile, flip master and stack areas */
	{ MODKEY,                       XK_space,      setlayout,              {0} },
	{ MODKEY|ShiftMask,             XK_space,      togglefloating,         {0} },
	{ MODKEY|ShiftMask,             XK_f,          fullscreen,             {0} },
	{ MODKEY,                       XK_0,          view,                   {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,          tag,                    {.ui = ~0 } },
	{ MODKEY|ControlMask,           XK_comma,      cyclelayout,            {.i = -1 } },
	{ MODKEY|ControlMask,           XK_period,     cyclelayout,            {.i = +1 } },
	{ ALTKEY,                       XK_j,  				focusmon,          {.i = -1 } },
	{ ALTKEY,                       XK_k, 				focusmon,          {.i = +1 } },
	{ ALTKEY|ShiftMask,             XK_j,	  			tagmon,            {.i = -1 } },
	{ ALTKEY|ShiftMask,             XK_k, 				tagmon,            {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_t|XK_h,  		spawn,             SHICMD("htop") },
	{ ShiftMask,           		    XK_Print,  			spawn,             SHCMD("flameshot gui") },
	{ MODKEY|ShiftMask,             XK_e,      			spawn,             SHCMD("select_emoji") },
	{ MODKEY|ShiftMask,             XK_m,      			spawn,             SHCMD("select_math") },
	{ MODKEY|ShiftMask,             XK_p,      			spawn,             SHCMD("simple-scan") },
	{ MODKEY|ShiftMask,             XK_b,      			spawn,             SHCMD("xdg-open localhost:5000") },
	{ MODKEY|ShiftMask,             XK_t,      			spawn,             SHCMD("latex2img") },
	{ MODKEY|ShiftMask,             XK_equal,  			spawn,             SHCMD("increase_volume") },
	{ MODKEY|ShiftMask,             XK_minus,  			spawn,             SHCMD("decrease_volume") },
	{ MODKEY|ShiftMask,             XK_w,     			spawn,             SHCMD("webcam") },
	{ MODKEY|ControlMask,           XK_c,	  			spawn,             SHCMD("select_color") },
	{ ALTKEY,           		    CAPSKEY,	  		spawn,             SHCMD("update_dwmblocks 5") },
	{ ControlMask|ALTKEY,           XK_Delete,	  		spawn,             SHCMD("lock") },
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
	{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
	/* click                event mask           button          function        argument */
	{ ClkLtSymbol,          0,                   Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,                   Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,                   Button1,        togglewin,      {0} },
	{ ClkWinTitle,          0,                   Button3,        showhideclient, {0} },
	{ ClkWinTitle,          0,                   Button2,        zoom,           {0} },
	{ ClkStatusText,        0,                   Button1,        sigstatusbar,   {.i = 1 } },
	{ ClkStatusText,        0,                   Button2,        sigstatusbar,   {.i = 2 } },
	{ ClkStatusText,        0,                   Button3,        sigstatusbar,   {.i = 3 } },
	{ ClkClientWin,         MODKEY,              Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,              Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,              Button3,        resizemouse,    {0} },
	{ ClkClientWin,         MODKEY|ShiftMask,    Button3,        dragcfact,      {0} },
	{ ClkTagBar,            0,                   Button1,        view,           {0} },
	{ ClkTagBar,            0,                   Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,              Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,              Button3,        toggletag,      {0} },
};

