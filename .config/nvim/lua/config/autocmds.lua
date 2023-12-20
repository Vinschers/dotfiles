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
