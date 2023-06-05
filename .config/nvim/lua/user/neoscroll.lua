local M = {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    config = function()
        require("neoscroll").setup()
    end,
}

return M
