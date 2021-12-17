let g:PaperColor_Theme_Options = {
  \   'language': {
  \     'python': {
  \       'highlight_builtins' : 1
  \     },
  \     'cpp': {
  \       'highlight_standard_library': 1
  \     },
  \     'c': {
  \       'highlight_builtins' : 1
  \     }
  \   }
  \ }

if has('termguicolors')
  set termguicolors
endif

" The configuration options should be placed before `colorscheme edge`.
let g:edge_style = 'neon'
let g:edge_enable_italic = 1
let g:edge_disable_italic_comment = 1

set background=dark
"colorscheme PaperColor
colorscheme edge

let g:python_highlight_all = 1
"let g:airline_theme='papercolor'

let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline_powerline_fonts = 1
