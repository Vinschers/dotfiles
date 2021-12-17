autocmd VimEnter * GitGutterSignsDisable

let g:blamer_delay = 100
let g:blamer_show_in_visual_modes = 0
let g:blamer_show_in_insert_modes = 0

nnoremap <C-g> :BlamerToggle<CR>  :GitGutterSignsToggle<CR>
