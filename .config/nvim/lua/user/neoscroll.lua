if vim.g.neovide
then
    return {}
end

local M = {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    config = function()
        require("neoscroll").setup()
    end,
}

return M
