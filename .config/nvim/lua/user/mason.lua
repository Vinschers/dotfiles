local M = {
	"williamboman/mason.nvim",
	commit = "4546dec8b56bc56bc1d81e717e4a935bc7cd6477",
	cmd = "Mason",
	event = "BufReadPre",
	dependencies = {
		{
			"williamboman/mason-lspconfig.nvim",
			commit = "93e58e100f37ef4fb0f897deeed20599dae9d128",
			lazy = true,
		},
		{
			"jayp0521/mason-nvim-dap.nvim",
			lazy = true,
		},
	},
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

function M.config()
	require("mason").setup(settings)

	require("mason-lspconfig").setup()
	require("mason-nvim-dap").setup()
end

return M
