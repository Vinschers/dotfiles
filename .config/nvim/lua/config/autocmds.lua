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

local function reload_colorscheme()
	local theme = require("plugins.colorscheme")[1].opts.colorscheme
	vim.notify(theme)
	vim.cmd.colorscheme(theme)
end

vim.api.nvim_create_autocmd("Signal", {
	pattern = "SIGWINCH",
	callback = reload_colorscheme,
})
