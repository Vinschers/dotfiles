vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    pattern = { "*.Xresources" },
    callback = function()
        os.execute("xrdb ~/.Xresources 2> /dev/null")
    end,
})
vim.api.nvim_create_autocmd({ "BufEnter" }, {
    pattern = { "*.Xresources" },
    callback = function()
        vim.cmd(":set ft=xdefaults")
    end,
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    pattern = { "eww.scss" },
    callback = function()
        os.execute("eww reload")
    end,
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    pattern = { "*/ags/*.scss" },
    callback = function()
        os.execute('ags --run-js "scss();" >/dev/null')
    end,
})

vim.api.nvim_create_autocmd("Signal", {
    pattern = "SIGWINCH",
    callback = function()
        package.loaded["plugins.colorscheme"] = nil
        package.loaded["config.keymaps"] = nil

        local theme = require("plugins.colorscheme")[1].opts.colorscheme

        vim.keymap.set({ "n" }, "<S-r>", "<Esc><cmd>colorscheme " .. theme .. "<cr>")
    end,
})

vim.api.nvim_create_autocmd({ "BufRead" }, {
    pattern = { "*/librewolf.overrides.cfg" },
    callback = function()
        vim.bo.filetype = "js"
    end,
})
