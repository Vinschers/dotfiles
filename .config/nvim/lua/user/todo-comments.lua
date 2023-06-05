local M = {
	"folke/todo-comments.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
}

function M.config()
    require("todo-comments").setup()
end

return M
