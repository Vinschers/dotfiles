set encoding=UTF-8
set number relativenumber
set inccommand=split

"Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

set tabstop=4
set softtabstop=4
set expandtab
set shiftwidth=4
set autoindent

set updatetime=100
set notimeout

set completeopt=menuone,noinsert,noselect
" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
