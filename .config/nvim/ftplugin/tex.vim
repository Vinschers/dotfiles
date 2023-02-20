set wrap
set conceallevel=1

let g:vimtex_imaps_enabled = 0

let g:vimtex_view_method = "zathura"
let g:tex_conceal = "abdmgs"
let g:vimtex_indent_enabled = 0

" Use with tree-sitter
" let g:vimtex_syntax_enabled = 0
" let g:vimtex_syntax_conceal_disable = 1


" Use `dsm` to delete surrounding math (replacing the default shorcut `ds$`)
nmap dsm <Plug>(vimtex-env-delete-math)

" Use `am` and `im` for the inline math text object
omap am <Plug>(vimtex-a$)
xmap am <Plug>(vimtex-a$)
omap im <Plug>(vimtex-i$)
xmap im <Plug>(vimtex-i$)

" Use `ai` and `ii` for the item text object
omap ai <Plug>(vimtex-am)
xmap ai <Plug>(vimtex-am)
omap ii <Plug>(vimtex-im)
xmap ii <Plug>(vimtex-im)
