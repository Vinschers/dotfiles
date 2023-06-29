local M = {
	"NvChad/nvim-colorizer.lua",
	lazy = false,
}

function M.config()
	require("colorizer").setup({
		filetypes = { "*" },
	})
end

return M
