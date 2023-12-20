return {
	{ import = "lazyvim.plugins.extras.dap.core" },
	{ import = "lazyvim.plugins.extras.coding.yanky" },
	{ import = "lazyvim.plugins.extras.util.project" },
	{ import = "lazyvim.plugins.extras.util.dot" },
	{ import = "lazyvim.plugins.extras.test.core" },

	{
		"akinsho/bufferline.nvim",
		opts = function(_, opts)
			opts.options.always_show_bufferline = true
		end,
	},

	{
		"NvChad/nvim-colorizer.lua",
		opts = {
			filetypes = { "*" },
		},
	},

	{
		"karb94/neoscroll.nvim",
		event = "VeryLazy",
		opts = {},
	},

	{
		"nvim-lualine/lualine.nvim",
		opts = function(_, opts)
			opts.sections.lualine_y = { { "location", padding = { left = 0, right = 1 } } }
			opts.sections.lualine_z = { { "progress" } }
		end,
	},

	{
		"nvim-neo-tree/neo-tree.nvim",
		opts = {
			filesystem = {
				filtered_items = {
					hide_dotfiles = false,
					hide_gitignored = false,
				},
				window = {
					mappings = {
						["L"] = "open_nofocus",
					},
				},
				commands = {
					open_nofocus = function(state)
						require("neo-tree.sources.filesystem.commands").open(state)
						vim.schedule(function()
							vim.cmd([[Neotree focus]])
						end)
					end,
				},
			},
			window = {
				mappings = {
					["l"] = "open",
					["h"] = "close_node",
				},
			},
		},
	},

	{
		"akinsho/toggleterm.nvim",
		dependencies = {
			"folke/which-key.nvim",
			opts = {
				defaults = {
					["<leader>T"] = { name = "+Toggleterm" },
				},
			},
		},
		event = "VeryLazy",
		keys = {
			{
				"<F5>",
				function()
					local Terminal = require("toggleterm.terminal").Terminal
					local run_code = Terminal:new({
						cmd = "run '" .. vim.fn.expand("%") .. "'",
						hidden = true,
						direction = "float",
						shading_factor = 2,
						float_opts = {
							border = "curved",
						},
					})
					run_code:toggle()
				end,
				desc = "Run file",
			},
			{
				"<leader>Tn",
				function()
					local Terminal = require("toggleterm.terminal").Terminal
					local ncdu = Terminal:new({ cmd = "ncdu --color off", hidden = true })
					ncdu:toggle()
				end,
				desc = "NCDU",
			},
		},
		opts = {
			size = 16,
			open_mapping = "<C-\\>",
		},
	},
}
