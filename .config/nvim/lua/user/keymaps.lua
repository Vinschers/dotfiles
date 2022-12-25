-- Shorten function name
local keymap = vim.keymap.set
-- Silent keymap option
local opts = { silent = true }

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "

keymap("n", "Ç", ":", opts)
keymap("i", "<C-l>", "\\", opts)
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

keymap("n", "c", '"_c', opts)
keymap("v", "c", '"_c', opts)

keymap("n", "<C-A-j>", "<Esc>:m .+1<CR>", opts)
keymap("n", "<C-A-k>", "<Esc>:m .-2<CR>", opts)

keymap("n", "<F1>", "", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Close buffers
keymap("n", "<S-q>", "<cmd>Bdelete!<CR>", opts)

-- Debugging
keymap("n", "<F6>", ":lua require'dap'.continue()<cr>", opts)
keymap("n", "<F9>", ":lua require'dap'.toggle_breakpoint()<cr>", opts)
keymap(
	"n",
	"<F10>",
	":lua local row, _ = unpack(vim.api.nvim_win_get_cursor(0)); if (row < vim.api.nvim_buf_line_count(0)) then require'dap'.step_over() else require'dap'.continue() end<cr>",
	opts
)
keymap(
	"n",
	"<F11>",
	":lua local row, _ = unpack(vim.api.nvim_win_get_cursor(0)); if (row < vim.api.nvim_buf_line_count(0)) then require'dap'.step_into() else require'dap'.continue() end<cr>",
	opts
)

keymap(
	"n",
	"<C-i>",
	"<cmd>silent exec '!inkscape-figures edit \"'.b:vimtex.root.'/figures/\" > /dev/null 2>&1 &'<CR><CR>:redraw!<CR>'",
	opts
)

-- Better paste
keymap("v", "p", '"_dP', opts)
keymap("v", "<C-A-j>", ":m .+1<CR>==", opts)
keymap("v", "<C-A-k>", ":m .-2<CR>==", opts)

-- Save
keymap("n", "<C-s>", ":w<cr>", opts)

keymap("n", "<F4>", ":! compile " .. vim.fn.expand("%") .. ">/dev/null<cr><cr>", opts)
keymap("n", "<F5>", ":lua _RUN_CODE()<cr>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

keymap("x", "<C-A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<C-A-k>", ":move '<-2<CR>gv-gv", opts)

-- Insert --
keymap("i", "<C-a>", "<ESC>ggVG", opts)
keymap("i", "<C-f>", "<cmd>Telescope find_files<cr>", opts)
keymap("i", "<C-t>", ":ene <BAR> startinsert <CR>", opts)
keymap("i", "<C-w>", "<cmd>Bdelete!<CR>", opts)

keymap(
	"i",
	"<C-f>",
	"<Esc><cmd>silent exec '.!inkscape-figures create \"'.getline('.').'\" \"'.b:vimtex.root.'/figures/\"'<CR><CR>:w<CR>'",
	opts
)
