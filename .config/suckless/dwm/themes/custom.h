#define BAR_BG "#132738"
#define BAR_FG "#fcfdfe"
#define NORMAL_BORDER "#282737"
#define SELECTED_BORDER "#61afef"
#define UNSELECTED_WINDOW "#132738"
#define ACTIVE_GROUP "#132738"
#define SELECTED_WINDOW "#212171"

static char c000000[]                    = "#000000"; // placeholder value

static char normfgcolor[]                = BAR_FG;
static char normbgcolor[]                = BAR_BG;
static char normbordercolor[]            = NORMAL_BORDER;
static char normfloatcolor[]             = NORMAL_BORDER;

static char selfgcolor[]                 = BAR_FG;              /* dmenu selected fg */
static char selbgcolor[]                 = "#5555ff";           /* dmenu selected bg */
static char selbordercolor[]             = SELECTED_BORDER;
static char selfloatcolor[]              = SELECTED_BORDER;

static char titlenormfgcolor[]           = BAR_FG;
static char titlenormbgcolor[]           = BAR_BG;
static char titlenormbordercolor[]       = NORMAL_BORDER;
static char titlenormfloatcolor[]        = NORMAL_BORDER;

static char titleselfgcolor[]            = BAR_FG;
static char titleselbgcolor[]            = BAR_BG;
static char titleselbordercolor[]        = SELECTED_BORDER;
static char titleselfloatcolor[]         = SELECTED_BORDER;

static char tagsnormfgcolor[]            = "#d1d1ff";
static char tagsnormbgcolor[]            = BAR_BG;
static char tagsnormbordercolor[]        = NORMAL_BORDER;
static char tagsnormfloatcolor[]         = NORMAL_BORDER;

static char tagsselfgcolor[]             = "#effcfe";
static char tagsselbgcolor[]             = "#1460d2";
static char tagsselbordercolor[]         = SELECTED_BORDER;
static char tagsselfloatcolor[]          = SELECTED_BORDER;

static char urgfgcolor[]                 = "#000000";
static char urgbgcolor[]                 = "#f7575d";
static char urgbordercolor[]             = "#f7575d";
static char urgfloatcolor[]              = "#f7575d";


static char hidnormfgcolor[]             = "#1460d2";
static char hidselfgcolor[]              = "#227799";
static char hidnormbgcolor[]             = BAR_BG;
static char hidselbgcolor[]              = BAR_BG;

static char *colors[][ColCount] = {
	/*                       fg                bg                border                float */
	[SchemeNorm]         = { normfgcolor,      normbgcolor,      normbordercolor,      normfloatcolor },
	[SchemeSel]          = { selfgcolor,       selbgcolor,       selbordercolor,       selfloatcolor },
	[SchemeTitleNorm]    = { titlenormfgcolor, titlenormbgcolor, titlenormbordercolor, titlenormfloatcolor },
	[SchemeTitleSel]     = { titleselfgcolor,  titleselbgcolor,  titleselbordercolor,  titleselfloatcolor },
	[SchemeTagsNorm]     = { tagsnormfgcolor,  tagsnormbgcolor,  tagsnormbordercolor,  tagsnormfloatcolor },
	[SchemeTagsSel]      = { tagsselfgcolor,   tagsselbgcolor,   tagsselbordercolor,   tagsselfloatcolor },
	[SchemeHidNorm]      = { hidnormfgcolor,   hidnormbgcolor,   c000000,              c000000 },
	[SchemeHidSel]       = { hidselfgcolor,    hidselbgcolor,    c000000,              c000000 },
	[SchemeUrg]          = { urgfgcolor,       urgbgcolor,       urgbordercolor,       urgfloatcolor },
};
