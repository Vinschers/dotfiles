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
	dashboard.button("e", " " .. " New file", ":ene <BAR> startinsert <CR>"),
	dashboard.button("p", " " .. " Find project", ":Telescope projects<CR>"),
	dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),
	dashboard.button("F", " " .. " Find text", ":Telescope live_grep <CR>"),
	dashboard.button("c", " " .. " Config", ":e ~/.config/nvim/init.lua<CR>:cd %:h<CR>"),
	dashboard.button("q", " " .. " Quit", ":qa<CR>"),
}

dashboard.section.header.opts = {
    hl = "Label",
    position = "center"
}
dashboard.section.header.type = "text"

alpha.setup(dashboard.opts)
