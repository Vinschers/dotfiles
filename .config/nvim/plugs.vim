call plug#begin()

"Theme
"Plug 'NLKNguyen/papercolor-theme'
Plug 'sainnhe/edge'
Plug 'vim-airline/vim-airline-themes'

"Syntax highlight
Plug 'sheerun/vim-polyglot'

Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

"Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'vim-airline/vim-airline'

Plug 'glepnir/dashboard-nvim'

Plug 'junegunn/fzf.vim'

Plug 'APZelos/blamer.nvim'
Plug 'airblade/vim-gitgutter'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update

"Plug 'neovim/nvim-lspconfig'
"Plug 'hrsh7th/nvim-compe'
"Plug 'mattn/efm-langserver'

"Plug 'kyazdani42/nvim-web-devicons'
"Plug 'folke/lsp-colors.nvim'
"Plug 'folke/trouble.nvim'

"if has('nvim')
  "Plug 'gelguy/wilder.nvim', { 'do': ':UpdateRemotePlugins' }
"else
  "Plug 'gelguy/wilder.nvim'

  " To use Python remote plugin features in Vim, can be skipped
  "Plug 'roxma/nvim-yarp'
  "Plug 'roxma/vim-hug-neovim-rpc'
"endif


" Plug 'mg979/vim-visual-multi', {'branch': 'master'}

call plug#end()
