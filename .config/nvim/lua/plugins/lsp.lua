return {
	{ import = "lazyvim.plugins.extras.lang.python" },
	{ import = "lazyvim.plugins.extras.lang.clangd" },
	{ import = "lazyvim.plugins.extras.lang.docker" },
	{ import = "lazyvim.plugins.extras.lang.typescript" },
	{ import = "lazyvim.plugins.extras.lang.rust" },
	{ import = "lazyvim.plugins.extras.lang.yaml" },
	{ import = "lazyvim.plugins.extras.lang.json" },
	{ import = "lazyvim.plugins.extras.lang.java" },
	{ import = "lazyvim.plugins.extras.lang.markdown" },
	{ import = "lazyvim.plugins.extras.lang.tex" },
	"elkowar/yuck.vim",

	{ import = "lazyvim.plugins.extras.lsp.none-ls" },

	{ import = "lazyvim.plugins.extras.formatting.prettier" },
	{ import = "lazyvim.plugins.extras.formatting.black" },

	{ import = "lazyvim.plugins.extras.test.core" },

	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				pyright = {},
			},
		},
	},

	{
		"stevearc/conform.nvim",
		opts = function(_, opts)
			vim.g.autoformat = false

			opts.formatters_by_ft = {
				c = { "clang_format" },
			}

			opts.formatters.clang_format = {
				prepend_args = { "--style", "{BasedOnStyle: gnu, IndentWidth: 4, BreakBeforeBraces: Allman}" },
			}

			opts.formatters.prettier = {
				prepend_args = { "--config", os.getenv("HOME") .. "/.config/.prettierrc.yaml" },
			}

			opts.formatters.black = {
				prepend_args = { "--fast", "-l", "150" },
			}
		end,
	},

	{
		"mfussenegger/nvim-lint",
		opts = {
			linters_by_ft = {
				-- Use the "*" filetype to run linters on all filetypes.
				-- ['*'] = { 'global linter' },
				-- Use the "_" filetype to run linters on filetypes that don't have other linters configured.
				-- ['_'] = { 'fallback linter' },
				sh = { "shellcheck" },
				yaml = { "yamllint" },
				yml = { "yamllint" },
				tex = { "chktex" },
			},
		},
	},

	{
		"mfussenegger/nvim-dap",
		opts = function()
			local dap = require("dap")
			for _, lang in ipairs({ "c", "cpp" }) do
				dap.configurations[lang] = {
					{
						type = "codelldb",
						request = "launch",
						name = "Launch file",
						cwd = "${workspaceFolder}",
						program = "${fileDirname}/${fileBasenameNoExtension}",
						initCommands = {
							"platform shell compile ${file}", -- Custom script to compile file
						},
						env = {
							PATH = "${env:PATH}",
						},
					},
				}
			end
		end,
	},
}
