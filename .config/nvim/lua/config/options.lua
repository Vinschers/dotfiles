vim.opt.formatoptions:remove({ "c", "r", "o" }) -- This is a sequence of letters which describes how automatic formatting is to be done
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.linebreak = true
vim.opt.wildignore = {
	-- media
	"*.ai,*.bmp,*.gif,*.ico,*.jpg,*.jpeg,*.png,*.psd,*.webp",
	"*.avi,*.m4a,*.mp3,*.oga,*.ogg,*.wav,*.webm",
	"*.eot,*.otf,*.ttf,*.woff",
	"*.doc,*.pdf",
	-- archives
	"*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz",
	-- temp/system
	"*.*~,*~ ",
	"*.swp,.lock,.DS_Store,._*,tags.lock",
	-- version control
	".git,.svn",
}

vim.g.maplocalleader = " "
vim.g.autoformat = false
