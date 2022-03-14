local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/code_actions
local code_actions = null_ls.builtins.code_actions

null_ls.setup({
	debug = false,
	sources = {
		formatting.prettier,
		formatting.black.with({ extra_args = { "-l", "130" } }),
		formatting.stylua,
		formatting.clang_format.with({
			extra_args = { "--style", "{BasedOnStyle: gnu, IndentWidth: 4}" },
			filetypes = { "c", "cpp" },
		}),
		formatting.shellharden,

		diagnostics.flake8.with({ extra_args = { "--max-line-length", "130" } }),
		-- diagnostics.cppcheck.with({ extra_args = {"--enable=all"} }),
		diagnostics.shellcheck,
		diagnostics.yamllint,

		code_actions.shellcheck,
	},
})
