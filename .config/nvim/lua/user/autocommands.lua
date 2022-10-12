-- Use 'q' to quit from common plugins
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "qf", "help", "man", "lspinfo", "spectre_panel", "lir" },
	callback = function()
		vim.cmd([[
      nnoremap <silent> <buffer> q :close<CR> 
      set nobuflisted 
    ]])
	end,
})

-- Remove statusline and tabline when in Alpha
vim.api.nvim_create_autocmd({ "User" }, {
	pattern = { "AlphaReady" },
	callback = function()
		vim.cmd([[
      set showtabline=0 | autocmd BufUnload <buffer> set showtabline=2
      set laststatus=0 | autocmd BufUnload <buffer> set laststatus=3
    ]])
	end,
})

-- Set wrap and spell in markdown and gitcommit
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

vim.cmd("autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif")

-- Fixes Autocomment
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
	callback = function()
		vim.cmd("set formatoptions-=cro")
	end,
})

-- Highlight Yanked Text
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
	callback = function()
		vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
	end,
})

vim.cmd([[
    augroup _auto_resize
        autocmd!
        autocmd VimResized * tabdo wincmd = 
    augroup end
]])

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    pattern = { ".Xresources" },
    callback = function ()
        os.execute("xrdb ~/.Xresources")
    end,
})

STARTED_INKSCAPE_WATCH = false
vim.api.nvim_create_autocmd({ "VimEnter" }, {
    pattern = { "*.tex" },
    callback = function ()
        local is_running = os.execute("isrunning inkscape-figures")

        if is_running ~= 0 then
            os.execute("inkscape-figures watch")
            STARTED_INKSCAPE_WATCH = true
        end
    end
})

vim.api.nvim_create_autocmd({ "VimLeave" }, {
    pattern = { "*.tex" },
    callback = function ()
        if STARTED_INKSCAPE_WATCH then
            os.execute("killall inkscape-figures")
        end

        local directory = vim.fn.expand("%:p"):match("(.*[\\/])")
        local cmd = "[ -f \"" .. directory .. "\".latex-cache/*.pdf ] && cp \"" .. directory .. "\".latex-cache/*.pdf \"" .. directory .. "\""
        os.execute(cmd)
    end,
})
