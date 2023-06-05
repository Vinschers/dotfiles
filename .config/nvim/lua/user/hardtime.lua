local M = {
	"m4xshen/hardtime.nvim",
	event = "VeryLazy",
	dependencies = {
		{
			"rcarriga/nvim-notify",
		},
	},
}

function M.config()
	require("hardtime").setup({
		disable_mouse = false,
	})
end
return M
