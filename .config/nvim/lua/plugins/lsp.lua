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
	{ import = "lazyvim.plugins.extras.lang.tailwind" },
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
			opts.formatters_by_ft = {
				c = { "clang_format" },
				cpp = { "clang_format" },
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

			opts.formatters.shfmt = {
				prepend_args = { "--indent", "4" },
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
		"nvimtools/none-ls.nvim",
		dependencies = {
			"gbprod/none-ls-shellcheck.nvim",
		},
		opts = function(_, opts)
			local nls = require("null-ls")
			opts.root_dir = opts.root_dir
				or require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git")
			opts.sources = vim.list_extend(opts.sources or {}, {
				nls.builtins.code_actions.refactoring,
				nls.builtins.code_actions.proselint,
				nls.builtins.code_actions.ts_node_action,
			})

			nls.register(require("none-ls-shellcheck.code_actions"))
		end,
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
