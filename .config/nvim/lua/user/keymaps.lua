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

keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)
keymap("n", "<C-w>", ":bdelete!<CR>", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize +2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize -2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Running code
keymap("n", "<F4>", ":lua _COMPILE_CODE()<cr>", opts)
keymap("n", "<F5>", ":lua _RUN_CODE()<cr>", opts)

-- Debugging
keymap("n", "<F6>", ":lua require'dap'.continue()<cr>", opts)
keymap("n", "<F9>", ":lua if (vim.bo.filetype == 'java') then require('jdtls.dap').setup_dap_main_class_configs() end require'dap'.toggle_breakpoint()<cr>", opts)
keymap("n", "<F10>", ":lua local row, _ = unpack(vim.api.nvim_win_get_cursor(0)); if (row < vim.api.nvim_buf_line_count(0)) then require'dap'.step_over() else require'dap'.continue() end<cr>", opts)
keymap("n", "<F11>", ":lua local row, _ = unpack(vim.api.nvim_win_get_cursor(0)); if (row < vim.api.nvim_buf_line_count(0)) then require'dap'.step_into() else require'dap'.continue() end<cr>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<C-A-j>", ":m .+1<CR>==", opts)
keymap("v", "<C-A-k>", ":m .-2<CR>==", opts)
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
