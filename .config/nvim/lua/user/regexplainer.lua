local M = {
    "bennypowers/nvim-regexplainer",
    event = "VeryLazy",

    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "MunifTanjim/nui.nvim"
    }
}

function M.config()
    require("regexplainer").setup({
        auto = true
    })
end

return M
