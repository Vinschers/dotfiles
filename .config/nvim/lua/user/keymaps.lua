-- Shorten function name
local keymap = vim.keymap.set
-- Silent keymap option
local opts = { silent = true }

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "

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

keymap("n", "<C-a>", "ggVG", opts)
keymap("n", "<C-t>", ":ene <BAR> startinsert <CR>", opts)
keymap("n", "<C-w>", "<cmd>Bdelete!<CR>", opts)

keymap("n", "c", "\"_c")

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Close buffers
keymap("n", "<S-q>", "<cmd>Bdelete!<CR>", opts)

-- Debugging
keymap("n", "<F6>", ":lua require'dap'.continue()<cr>", opts)
keymap("n", "<F9>", ":lua if (vim.bo.filetype == 'java') then require('jdtls.dap').setup_dap_main_class_configs() end require'dap'.toggle_breakpoint()<cr>", opts)
keymap("n", "<F10>", ":lua local row, _ = unpack(vim.api.nvim_win_get_cursor(0)); if (row < vim.api.nvim_buf_line_count(0)) then require'dap'.step_over() else require'dap'.continue() end<cr>", opts)
keymap("n", "<F11>", ":lua local row, _ = unpack(vim.api.nvim_win_get_cursor(0)); if (row < vim.api.nvim_buf_line_count(0)) then require'dap'.step_into() else require'dap'.continue() end<cr>", opts)

-- Better paste
keymap("v", "p", '"_dP', opts)

-- Save
keymap("n", "<C-s>", ":w<cr>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Insert --
keymap("i", "<C-a>", "<ESC>ggVG", opts)
keymap("i", "<C-f>", "<cmd>Telescope find_files<cr>", opts)
keymap("i", "<C-t>", ":ene <BAR> startinsert <CR>", opts)
keymap("i", "<C-w>", "<cmd>Bdelete!<CR>", opts)
