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


-- https://github.com/prettier-solidity/prettier-plugin-solidity
null_ls.setup({
	debug = false,
	sources = {
		formatting.prettier,
		formatting.black.with({ extra_args = { "--fast", "-l", "130" } }),
		formatting.isort,
		formatting.stylua,
		formatting.clang_format.with({ extra_args = { "--style", "{BasedOnStyle: gnu, IndentWidth: 4}" } }),
		formatting.dart_format,
		formatting.shfmt,
		formatting.latexindent,
		formatting.google_java_format.with({ extra_args = { "-a" } }),
        formatting.bibclean,

		diagnostics.flake8,
		diagnostics.shellcheck,
		diagnostics.yamllint,
		diagnostics.chktex,

		code_actions.shellcheck,
		code_actions.eslint_d,
        code_actions.proselint,
	},
})
