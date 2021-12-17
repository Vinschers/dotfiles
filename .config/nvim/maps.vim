nnoremap <leader>; A;<esc>

nnoremap <leader>j :tabp<CR>
nnoremap <C-t> :tabnew<CR>
nnoremap <leader>k :tabn<CR>
nnoremap <C-k> <C-w>k
nnoremap <C-j> <C-w>j
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-Left> <C-W><
nnoremap <C-Right> <C-W>>
nnoremap <C-w> :q<CR>
"Clear highlight after search
nnoremap <ESC> :noh<CR>

"Swap lines (Alt+↑ in vscode)
nnoremap <A-C-j> :m .+1<CR>==
nnoremap <A-C-k> :m .-2<CR>==
vnoremap <A-C-j> :m '>+1<CR>gv=gv
vnoremap <A-C-k> :m '<-2<CR>gv=gv
