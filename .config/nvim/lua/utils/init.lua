local M = {}

M.lsp_servers = {
	"lua_ls",
	"cssls",
	"html",
	"tsserver",
	"pyright",
	"bashls",
	"jsonls",
	"yamlls",
	"clangd",
	"jdtls",
	-- "texlab",
	"emmet_ls",
	"ansiblels",
	"dockerls",
}

-- https://github.com/jayp0521/mason-nvim-dap.nvim/blob/main/lua/mason-nvim-dap/mappings/source.lua
M.dap_servers = {
	-- "javadbg",
	"bash",
	"python",
	"node2",
}

M.fmt_lint_servers = {
	"prettier",
	"black",
	"isort",
	"stylua",
	"clang_format",
	"shfmt",
	"google_java_format",
    "latexindent",

	"flake8",
	"shellcheck",
	"yamllint",
	"chktex",
	"eslint_d",
	"proselint",
}

return M
