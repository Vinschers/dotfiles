local M = {
	"nvim-telescope/telescope.nvim",
	commit = "40c31fdde93bcd85aeb3447bb3e2a3208395a868",
	event = "Bufenter",
	cmd = { "Telescope" },
	dependencies = {
		{
			"ahmedkhalf/project.nvim",
			commit = "8c6bad7d22eef1b71144b401c9f74ed01526a4fb",
		},
		{
			"nvim-telescope/telescope-ui-select.nvim",
		},
		{
			"nvim-telescope/telescope-bibtex.nvim",
			config = function()
				require("telescope").load_extension("bibtex")
			end,
		},
	},
}

local actions = require("telescope.actions")

M.opts = {
	defaults = {
		prompt_prefix = " ",
		selection_caret = " ",
		path_display = { "smart" },
		file_ignore_patterns = {
			".git/",
			"node_modules",
			"gtk/",

			"%.jpg",
			"%.jpeg",
			"%.png",
			"%.svg",
			"%.otf",
			"%.ttf",
			"%.gif",
			"%.mp4",
			"%.mp3",
			"%.mkv",
			"%.zip",
			"%.tar.xz",
			"%.tar.gz",
			"%.rar",
			"%.so",
			"%.out",
		},
		mappings = {
			i = {
				["<Down>"] = actions.move_selection_next,
				["<Up>"] = actions.move_selection_previous,
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
			},
		},
		load_extensions = { "yank_history", "bibtex" },
		extensions = {
			["ui-select"] = {
				require("telescope.themes").get_dropdown({
					-- even more opts
				}),
			},
			bibtex = {
				-- Depth for the *.bib file
				depth = 1,
				-- Custom format for citation label
				custom_formats = {},
				-- Format to use for citation label.
				-- Try to match the filetype by default, or use 'plain'
				format = "",
				-- Path to global bibliographies (placed outside of the project)
				global_files = {},
				-- Define the search keys to use in the picker
				search_keys = { "author", "year", "title" },
				-- Template for the formatted citation
				citation_format = "{{author}} ({{year}}), {{title}}.",
				-- Only use initials for the authors first name
				citation_trim_firstname = true,
				-- Max number of authors to write in the formatted citation
				-- following authors will be replaced by "et al."
				citation_max_auth = 2,
				-- Context awareness disabled by default
				context = false,
				-- Fallback to global/directory .bib files if context not found
				-- This setting has no effect if context = false
				context_fallback = true,
				-- Wrapping in the preview window is disabled by default
				wrap = true,
			},
		},
	},
}

return M
