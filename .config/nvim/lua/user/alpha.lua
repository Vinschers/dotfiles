local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
	return
end

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
	dashboard.button("p", " " .. " Find project", ":Telescope projects<CR>"),
	dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),
	dashboard.button("e", " " .. " New file", ":ene<CR>"),
	dashboard.button("c", " " .. " Config Neovim", ":cd " .. vim.fn.stdpath("config") .. "<CR>:Telescope find_files<CR>"),
	dashboard.button("s", " " .. " Config Suckless", ":cd ~/.config/suckless/<CR>:Telescope find_files<CR>"),
	dashboard.button("x", " " .. " Config sxhkd", ":e ~/.config/sxhkd/sxhkdrc<CR>"),
	dashboard.button("q", " " .. " Quit", ":qa<CR>"),
}

dashboard.section.header.opts = {
    hl = "Label",
    position = "center"
}
dashboard.section.header.type = "text"

alpha.setup(dashboard.opts)
