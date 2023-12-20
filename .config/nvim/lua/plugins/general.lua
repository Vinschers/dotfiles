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
		event = "VeryLazy",
		opts = {
			size = 16,
			open_mapping = "<C-\\>",
		},
	},
}
