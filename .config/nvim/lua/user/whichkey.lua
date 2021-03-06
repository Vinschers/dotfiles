local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
	return
end

local setup = {
	plugins = {
		marks = true, -- shows a list of your marks on ' and `
		registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
		spelling = {
			enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
			suggestions = 20, -- how many suggestions should be shown in the list?
		},
		-- the presets plugin, adds help for a bunch of default keybindings in Neovim
		-- No actual key bindings are created
		presets = {
			operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
			motions = true, -- adds help for motions
			text_objects = true, -- help for text objects triggered after entering an operator
			windows = true, -- default bindings on <c-w>
			nav = true, -- misc bindings to work with windows
			z = true, -- bindings for folds, spelling and others prefixed with z
			g = true, -- bindings for prefixed with g
		},
	},
	-- add operators that will trigger motion and text object completion
	-- to enable all native operators, set the preset / operators plugin above
	-- operators = { gc = "Comments" },
	key_labels = {
		-- override the label used to display some keys. It doesn't effect WK in any other way.
		-- For example:
		-- ["<space>"] = "SPC",
		-- ["<cr>"] = "RET",
		-- ["<tab>"] = "TAB",
	},
	icons = {
		breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
		separator = "➜", -- symbol used between a key and it's label
		group = "+", -- symbol prepended to a group
	},
	popup_mappings = {
		scroll_down = "<c-d>", -- binding to scroll down inside the popup
		scroll_up = "<c-u>", -- binding to scroll up inside the popup
	},
	window = {
		border = "rounded", -- none, single, double, shadow
		position = "bottom", -- bottom, top
		margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
		padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
		winblend = 0,
	},
	layout = {
		height = { min = 4, max = 25 }, -- min and max height of the columns
		width = { min = 20, max = 50 }, -- min and max width of the columns
		spacing = 3, -- spacing between columns
		align = "left", -- align columns left, center or right
	},
	ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
	hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
	show_help = true, -- show help message on the command line when the popup is visible
	triggers = "auto", -- automatically setup triggers
	-- triggers = {"<leader>"} -- or specify a list manually
	triggers_blacklist = {
		-- list of mode / prefixes that should never be hooked by WhichKey
		-- this is mostly relevant for key maps that start with a native binding
		-- most people should not need to change this
	},
}

local nopts = {
	mode = "n", -- NORMAL mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

local nmappings = {
	["e"] = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
	["h"] = { "<cmd>nohlsearch<CR>", "No Highlight" },
	["Q"] = { "<cmd>qa!<CR>", "Close all" },

	["f"] = { "<cmd>Telescope find_files<cr>", "Find files" },
	["F"] = { "<cmd>Telescope live_grep theme=ivy<cr>", "Find Text" },
	["P"] = { "<cmd>Telescope projects<cr>", "Projects" },
	["b"] = { "<cmd>Telescope buffers<cr>", "Buffers" },

    ["c"] = { "<cmd>Cheat<cr>", "Cheat" },

	["/"] = { "<cmd>lua require('Comment.api').toggle_current_linewise()<cr>", "Comment" },

	p = {
		name = "Packer",
		c = { "<cmd>PackerCompile<cr>", "Compile" },
		i = { "<cmd>PackerInstall<cr>", "Install" },
		s = { "<cmd>PackerSync<cr>", "Sync" },
		S = { "<cmd>PackerStatus<cr>", "Status" },
		u = { "<cmd>PackerUpdate<cr>", "Update" },
	},

	g = {
		name = "Git",
		g = { "<cmd>lua _LAZYGIT_TOGGLE()<CR>", "Lazygit" },
		j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
		k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
		l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
		p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
		r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
		R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
		s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
		u = { "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", "Undo Stage Hunk" },
		o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
		b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
		c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
		d = { "<cmd>Gitsigns diffthis HEAD<cr>", "Diff" },
	},

	l = {
		name = "LSP",
		a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
		d = { "<cmd>Telescope lsp_document_diagnostics<cr>", "Document Diagnostics" },
		g = { "<cmd>lua vim.diagnostic.open_float({ border = 'rounded' })<cr>", "Show dialog" },
		w = { "<cmd>Telescope lsp_workspace_diagnostics<cr>", "Workspace Diagnostics" },
		f = { "<cmd>lua vim.lsp.buf.format{async=true}<cr>", "Format" },
        F = {
            name = "Flutter tools",
            d = { "<cmd>FlutterDevices<cr>", "Devices" },
            r = { "<cmd>FlutterRun<cr>", "Run" },
            R = { "<cmd>FlutterRestart<cr>", "Restart" },
            q = { "<cmd>FlutterQuit<cr>", "Quit" },
            l = { "<cmd>FlutterLspRestart<cr>", "Restart LSP server" },
        },
		i = { "<cmd>LspInfo<cr>", "Info" },
		I = { "<cmd>LspInstallInfo<cr>", "Installer Info" },
		j = { "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", "Next Diagnostic" },
		k = { "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>", "Prev Diagnostic" },
		l = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
		q = { "<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>", "Quickfix" },
		r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
		S = { "<cmd>SymbolsOutline<cr>", "Document Symbols" },
		t = {
			name = "+Trouble",
			r = { "<cmd>Trouble lsp_references<cr>", "References" },
			f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
			d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
			q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
			l = { "<cmd>Trouble loclist<cr>", "LocationList" },
			w = { "<cmd>Trouble workspace_diagnostics<cr>", "Wordspace Diagnostics" },
		},
	},
	s = {
		name = "Search",
		b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
		c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
		h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
		M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
		r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
		R = { "<cmd>Telescope registers<cr>", "Registers" },
		k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
		C = { "<cmd>Telescope commands<cr>", "Commands" },
	},

	T = {
		name = "Terminal",
		g = { "<cmd>lua _LAZYGIT_TOGGLE()<CR>", "Lazygit" },
		u = { "<cmd>lua _NCDU_TOGGLE()<cr>", "NCDU" },
		f = { "<cmd>ToggleTerm direction=float<cr>", "Float" },
		h = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", "Horizontal" },
		v = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", "Vertical" },
	},

	d = {
		name = "DAP debugger",
		b = { "Toggle breakpoint", "<cmd>lua require'dap'.toggle_breakpoint()<cr>" },
		c = { "Continue", "<cmd>lua require'dap'.continue()<cr>" },
		i = { "Step into", "<cmd>lua require'dap'.step_into()<cr>" },
		o = { "Step over", "<cmd>lua require'dap'.step_over()<cr>" },
		O = { "Step out", "<cmd>lua require'dap'.step_out()<cr>" },
		r = { "Toggle repl", "<cmd>lua require'dap'.repl.toggle()<cr>" },
		l = { "Run last", "<cmd>lua require'dap'.run_last()<cr>" },
		u = { "Toggle dapui", "<cmd>lua require'dapui'.toggle()<cr>" },
		t = { "Terminate", "<cmd>lua require'dap'.terminate()<cr>" },
	},

	t = {
		name = "Vimtex",
		c = { "<cmd>VimtexCompile<CR>", "Compile" },
		C = {
			"<cmd>VimtexClean!<CR> <cmd>VimtexClearCache vim.fn.expand('%')<CR> <cmd>!rm *_vimtex_selected*<CR>",
			"Clean auxiliary and cache files",
		},
		d = { "<cmd>VimtexDocPackage<CR>", "Download documentation of package under cursor" },
		e = { "<cmd>VimtexErrors<CR>", "Check errors log" },
		i = { "<cmd>VimtexTocOpen<CR>", "Open index" },
		m = { "<cmd>VimtexToggleMain<CR>", "Change main project file" },
		s = { "<cmd>VimtexStop<CR>", "Stop compilation" },
		v = { "<cmd>VimtexView<CR>", "Open preview" },
		w = { "<cmd>VimtexCountWords!<CR>", "Count number of words" },
	},
}

local vopts = {
	mode = "v", -- NORMAL mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

local vmappings = {
	["/"] = { '<ESC><CMD>lua require("Comment.api").toggle_linewise_op(vim.fn.visualmode())<CR>', "Comment" },
}

which_key.setup(setup)
which_key.register(nmappings, nopts)
which_key.register(vmappings, vopts)
