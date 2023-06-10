local M = {
	"norcalli/nvim-colorizer.lua",
    lazy = false,
}

function M.config()
	require("colorizer").setup({
		"*",
	})
end

return M
