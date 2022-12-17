vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "qf", "help", "man", "lspinfo", "spectre_panel" },
	callback = function()
		vim.cmd([[
      nnoremap <silent> <buffer> q :close<CR> 
      set nobuflisted 
    ]])
	end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

vim.cmd("autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif")

vim.api.nvim_create_autocmd({ "VimResized" }, {
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
})

vim.api.nvim_create_autocmd({ "CmdWinEnter" }, {
	callback = function()
		vim.cmd("quit")
	end,
})

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
	callback = function()
		vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
	end,
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	pattern = { "*.java" },
	callback = function()
		vim.lsp.codelens.refresh()
	end,
})

vim.api.nvim_create_autocmd({ "VimEnter" }, {
	callback = function()
		vim.cmd("hi link illuminatedWord LspReferenceText")
	end,
})

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
	callback = function()
		local line_count = vim.api.nvim_buf_line_count(0)
		if line_count >= 5000 then
			vim.cmd("IlluminatePauseBuf")
		end
	end,
})

vim.cmd([[
    autocmd BufRead * autocmd FileType <buffer> ++once
      \ if &ft !~# 'commit\|rebase' && line("'\"") > 1 && line("'\"") <= line("$") | exe 'normal! g`"' | endif
]])
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	pattern = { ".Xresources" },
	callback = function()
		os.execute("xrdb ~/.Xresources")
	end,
})
-- vim.api.nvim_create_autocmd({ "BufWritePost" }, {
-- 	pattern = { "*/.config/lightdm/*" },
-- 	callback = function()
-- 		os.execute("sudo cp -r ~/.config/lightdm /etc")
-- 	end,
-- })
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	pattern = { "local_environment.sh" },
	callback = function()
		os.execute(
			'git --git-dir=$HOME/.dotfiles-git/ --work-tree=$HOME update-index --assume-unchanged "$SCRIPTS_DIR/shell/local_environment.sh"'
		)
	end,
})
vim.api.nvim_create_autocmd({ "VimLeave" }, {
	pattern = { "*.tex" },
	callback = function()
		if STARTED_INKSCAPE_WATCH then
			os.execute("killall inkscape-figures")
		end

		local directory = vim.fn.expand("%:p"):match("(.*[\\/])")
		local cmd = '[ -f "'
			.. directory
			.. '".latex-cache/*.pdf ] && cp "'
			.. directory
			.. '".latex-cache/*.pdf "'
			.. directory
			.. '"'
		os.execute(cmd)
	end,
})
