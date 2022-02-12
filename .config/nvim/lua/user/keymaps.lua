local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation

keymap("n", "<C-c>", "lh:noh<CR>", opts) -- Closes open floats and clears highlights

keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)
keymap("n", "<C-w>", ":bdelete<CR>", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Git
keymap("n", "<leader>gp", ":Gitsigns prev_hunk<CR>", opts)
keymap("n", "<leader>gn", ":Gitsigns next_hunk<CR>", opts)
keymap("n", "<leader>gr", ":Gitsigns preview_hunk<CR>", opts)

-- Telescope
keymap("n", "<leader>tf", "<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ previewer = false }))<cr>", opts)
keymap("n", "<leader>tg", ":Telescope live_grep<cr>", opts)
keymap("n", "<leader>tb", ":Telescope git_branches<cr>", opts)
keymap("n", "<leader>th", ":Telescope help_tags<cr>", opts)
keymap("n", "<leader>tm", ":Telescope media_files<cr>", opts)

-- NvimTree
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", opts)

-- Null-LS
keymap("n", "<leader>f", ":Format<CR>", opts)

-- Toggleterm
keymap("n", "<leader>lg", ":lua _LAZYGIT_TOGGLE()<CR>", opts)
keymap("n", "<leader>ht", ":lua _HTOP_TOGGLE()<CR>", opts)
keymap("n", "<leader>py", ":lua _PYTHON_TOGGLE()<CR>", opts)
keymap("n", "<leader>nc", ":lua _NCDU_TOGGLE()<CR>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Terminal --
-- Better terminal navigation
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)
