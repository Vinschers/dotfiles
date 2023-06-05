local M = {
	"goolord/alpha-nvim",
	event = "VimEnter",
	commit = "dafa11a6218c2296df044e00f88d9187222ba6b0",
}

function M.config()
	local alpha = require("alpha")
	local dashboard = require("alpha.themes.dashboard")
	dashboard.section.header.val = {
		"            ⢀⣀⣤⣤⣶⣶⣶⣿⣿⣷⣶⣶⣦⣤⣄⡀            ",
		"         ⣀⣴⣾⡿⠟⠋⠉⠁       ⠉⠙⠛⠿⣿⣦⣄         ",
		"       ⣠⣾⡿⠋⠁⢰⣤⡀              ⠉⠻⣿⣦⡀      ",
		"     ⣠⣾⡟⠁   ⠘⢿⣿⣦⣤⣄            ⢀⣈⣿⣿⣶⣾⣿⣿⣷⡆",
		"    ⣴⣿⠋      ⣾⣿⣿⣿⣿⣿⡆     ⢀⣠⣤⣶⡿⠿⠛⠋⠉⢻⣷⣄⣽⡿⠃",
		"   ⣼⣿⠃      ⢠⣿⣿⣿⣿⣿⣿  ⣀⣤⣶⣾⣿⣛⣉⣁⣤⡤   ⣠⣿⣿⡏  ",
		"  ⢰⣿⠃       ⠈⠉⠛⠻⣿⣿⣿⣷⣿⣿⠿⣿⣻⣿⣿⣿⣿⠏ ⣀⣴⣾⠟⠋⢻⣷  ",
		"  ⣿⡟          ⣀⣴⣿⡿⣋⣭⣷⣾⣿⣿⣿⣿⣿⠟⢁⣤⣾⠿⠋⠁  ⠘⣿⡇ ",
		"  ⣿⡇       ⣠⣴⣿⣿⡿⣫⣾⣿⣿⣿⣿⣿⣿⣿⣿⣯⣾⡿⠛⠁      ⣿⡇ ",
		"  ⣿⡇    ⣠⣴⡿⠟⣽⢿⣿⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠁         ⣿⡇ ",
		"  ⣿⣧ ⢀⣴⣾⠿⠋⢠⣾⣵⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇          ⢠⣿⡇ ",
		"  ⠸⣿⣶⡿⠛⠁ ⠔⠛⠛⠋⠉⣉⣥⣶⣿⠿⠛⠻⢿⣿⣿⣿⡀          ⣼⡿  ",
		" ⢀⣾⣿⣿⡄   ⢀⣠⣴⣶⡿⠟⠋⠁      ⢙⣿⣷⣶⣄       ⣸⣿⠃  ",
		"⢠⣿⣿⣁⣻⣿⣤⣶⡿⠿⠛⠉           ⠸⣿⣿⣿⡿ ⣀   ⢀⣼⡿⠃   ",
		"⠈⠻⠿⠟⠛⠛⢿⣷⣀               ⠈⣉⣻⣿⣾⡟  ⣠⣾⠟⠁    ",
		"       ⠙⢿⣷⣄⡀             ⠛⠛⠛⠛⣀⣴⣾⠟⠁      ",
		"         ⠉⠻⢿⣷⣦⣄⣀⡀       ⢀⣀⣤⣴⣾⠿⠋⠁        ",
		"            ⠈⠉⠛⠻⠿⠿⢿⣿⣿⣿⠿⠿⠿⠛⠋⠉            ",
	}
	dashboard.section.buttons.val = {
		dashboard.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
		dashboard.button("F", " " .. " Find text", ":Telescope live_grep <CR>"),
		dashboard.button(
			"p",
			" " .. " Find project",
			":lua require('telescope').extensions.projects.projects()<CR>"
		),
		dashboard.button("r", "󰄉 " .. " Recent files", ":Telescope oldfiles <CR>"),
		dashboard.button("e", " " .. " New file", ":ene<CR>"),
		dashboard.button(
			"c",
			" " .. " Config Neovim",
			":cd " .. vim.fn.stdpath("config") .. "<CR>:Telescope find_files<CR>"
		),
		dashboard.button("q", " " .. " Quit", ":qa<CR>"),
	}

	dashboard.section.header.opts.hl = "Include"
	dashboard.section.buttons.opts.hl = "Keyword"

	dashboard.opts.opts.noautocmd = true
	alpha.setup(dashboard.opts)
end

return M
