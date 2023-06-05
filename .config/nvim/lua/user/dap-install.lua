local M = {
	"ravenxrz/DAPInstall.nvim",
	commit = "8798b4c36d33723e7bba6ed6e2c202f84bb300de",
	lazy = true,
	config = function()
		require("dap_install").setup({})
		require("dap_install").config("python", {})
	end,
}

return M
