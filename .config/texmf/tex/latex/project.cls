\NeedsTeXFormat{LaTeX2e}
\LoadClassWithOptions{article}
\ProvidesClass{project}[2022/11/17 Project class]

% ----- Packages --------------------------------------------------------------

% Better fonts with accents
\RequirePackage[T1]{fontenc}
\usepackage[utf8]{inputenc}

% Required for starred commands
\RequirePackage{suffix}

% Math symbols
\RequirePackage{amsmath}
\RequirePackage{amsfonts}
\RequirePackage{amsthm}
\RequirePackage{amssymb}
\RequirePackage{centernot}

% Nice lists
\RequirePackage{enumerate}
\RequirePackage[shortlabels]{enumitem}

% Nice images, figures, and listings
\RequirePackage{graphicx}
\RequirePackage{grffile}
\RequirePackage[all]{xy}
\RequirePackage{wrapfig}
\RequirePackage{fancyvrb}
\RequirePackage{listings}
\RequirePackage{pgfplots}
\RequirePackage{xcolor}

% Header & Page Setup
\RequirePackage{fancyhdr}

% Links
\RequirePackage{hyperref}

% Misc
\RequirePackage{indentfirst}
\RequirePackage{titling}
\RequirePackage{nameref}
\RequirePackage{lipsum}
\RequirePackage{xparse}
\RequirePackage{siunitx}


\let\CLASSsection\section
\let\CLASSsubsection\subsection

\RenewDocumentCommand{\section}{som}{%
	\IfBooleanTF{#1}
	{% there's a *
		\CLASSsection*{#3}\markboth{#3}{}%
	}
	{% no *
		\IfNoValueTF{#2}
		{% no opt arg
			\CLASSsection{#3}%
		}
		{% opt arg
			\CLASSsection[#2]{#3}%
		}%
	}%
}

\RenewDocumentCommand{\subsection}{som}{%
	\IfBooleanTF{#1}
	{% there's a *
		\CLASSsubsection*{#3}\markright{#3}%
	}
	{% no *
		\IfNoValueTF{#2}
		{% no opt arg
			\CLASSsubsection{#3}%
		}
		{% opt arg
			\CLASSsubsection[#2]{#3}%
		}%
	}%
}

\pgfplotsset{compat = newest}
