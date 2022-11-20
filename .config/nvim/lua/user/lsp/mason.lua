local lsp_servers = {
	"sumneko_lua",
	"cssls",
	"html",
	"tsserver",
	"pyright",
	"bashls",
	"jsonls",
	"yamlls",
	"clangd",
	"jdtls"
}

-- https://github.com/jayp0521/mason-nvim-dap.nvim/blob/main/lua/mason-nvim-dap/mappings/source.lua
local dap_servers = {
    "javadbg",
    "bash",
    "python"
}

local fmt_lint_servers = {
    "prettier",
    "black",
    "isort",
    "stylua",
    "clang_format",
    -- "dart_format",
    "shfmt",
    -- "latexindent",
    -- "google_java_format",

    "flake8",
    "shellcheck",
    "yamllint",
    -- "chktex",
    "eslint_d",
}

local settings = {
	ui = {
		border = "none",
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
	log_level = vim.log.levels.INFO,
	max_concurrent_installers = 4,
}

require("mason").setup(settings)
require("mason-lspconfig").setup({
	ensure_installed = lsp_servers,
	automatic_installation = true,
})
require("mason-nvim-dap").setup({
    ensure_installed = dap_servers,
    automatic_installation = true,
})
require("mason-null-ls").setup({
    ensure_installed = fmt_lint_servers,
    automatic_installation = true,
})


local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
	return
end

local opts = {}

for _, server in pairs(lsp_servers) do
	opts = {
		on_attach = require("user.lsp.handlers").on_attach,
		capabilities = require("user.lsp.handlers").capabilities,
	}

	server = vim.split(server, "@")[1]

	local require_ok, conf_opts = pcall(require, "user.lsp.settings." .. server)
	if require_ok then
		opts = vim.tbl_deep_extend("force", conf_opts, opts)
	end

	lspconfig[server].setup(opts)
end
