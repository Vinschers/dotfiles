return {
	{
		"nvimdev/dashboard-nvim",
		opts = function(_, opts)
			local logo = [[
		            ⢀⣀⣤⣤⣶⣶⣶⣿⣿⣷⣶⣶⣦⣤⣄⡀            
		         ⣀⣴⣾⡿⠟⠋⠉⠁       ⠉⠙⠛⠿⣿⣦⣄         
		       ⣠⣾⡿⠋⠁⢰⣤⡀              ⠉⠻⣿⣦⡀      
		     ⣠⣾⡟⠁   ⠘⢿⣿⣦⣤⣄            ⢀⣈⣿⣿⣶⣾⣿⣿⣷⡆
		    ⣴⣿⠋      ⣾⣿⣿⣿⣿⣿⡆     ⢀⣠⣤⣶⡿⠿⠛⠋⠉⢻⣷⣄⣽⡿⠃
		   ⣼⣿⠃      ⢠⣿⣿⣿⣿⣿⣿  ⣀⣤⣶⣾⣿⣛⣉⣁⣤⡤   ⣠⣿⣿⡏  
		  ⢰⣿⠃       ⠈⠉⠛⠻⣿⣿⣿⣷⣿⣿⠿⣿⣻⣿⣿⣿⣿⠏ ⣀⣴⣾⠟⠋⢻⣷  
		  ⣿⡟          ⣀⣴⣿⡿⣋⣭⣷⣾⣿⣿⣿⣿⣿⠟⢁⣤⣾⠿⠋⠁  ⠘⣿⡇ 
		  ⣿⡇       ⣠⣴⣿⣿⡿⣫⣾⣿⣿⣿⣿⣿⣿⣿⣿⣯⣾⡿⠛⠁      ⣿⡇ 
		  ⣿⡇    ⣠⣴⡿⠟⣽⢿⣿⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠁         ⣿⡇ 
		  ⣿⣧ ⢀⣴⣾⠿⠋⢠⣾⣵⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇          ⢠⣿⡇ 
		  ⠸⣿⣶⡿⠛⠁ ⠔⠛⠛⠋⠉⣉⣥⣶⣿⠿⠛⠻⢿⣿⣿⣿⡀          ⣼⡿  
		 ⢀⣾⣿⣿⡄   ⢀⣠⣴⣶⡿⠟⠋⠁      ⢙⣿⣷⣶⣄       ⣸⣿⠃  
		⢠⣿⣿⣁⣻⣿⣤⣶⡿⠿⠛⠉           ⠸⣿⣿⣿⡿ ⣀   ⢀⣼⡿⠃   
		⠈⠻⠿⠟⠛⠛⢿⣷⣀               ⠈⣉⣻⣿⣾⡟  ⣠⣾⠟⠁    
		       ⠙⢿⣷⣄⡀             ⠛⠛⠛⠛⣀⣴⣾⠟⠁      
		         ⠉⠻⢿⣷⣦⣄⣀⡀       ⢀⣀⣤⣴⣾⠿⠋⠁        
		            ⠈⠉⠛⠻⠿⠿⢿⣿⣿⣿⠿⠿⠿⠛⠋⠉            
            ]]
			logo = string.rep("\n", 4) .. logo .. "\n\n"
			opts.config.header = vim.split(logo, "\n")

            -- stylua: ignore
            opts.config.center = {
                { action = "Telescope find_files",                                      desc = " Find file",        icon = "",     key = "f" },
                { action = "Telescope live_grep",                                       desc = " Find text",        icon = " ",    key = "F" },
                { action = "Telescope oldfiles",                                        desc = " Recent files",     icon = "󰄉",     key = "r" },
                { action = "ene | startinsert",                                         desc = " New file",         icon = " ",    key = "n" },
                { action = [[lua require("lazyvim.util").telescope.config_files()()]],  desc = " Config Neovim",    icon = " ",    key = "c" },
                { action = 'lua require("persistence").load()',                         desc = " Restore Session",  icon = " ",    key = "s" },
                { action = "qa",                                                        desc = " Quit",             icon = " ",    key = "q" },
            }

			for _, button in ipairs(opts.config.center) do
				button.desc = button.desc .. string.rep(" ", 36 - #button.desc)
				button.key_format = "  %s"
			end
		end,
	},
}
