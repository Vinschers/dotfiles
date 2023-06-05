local M = {
  "nvim-treesitter/nvim-treesitter",
  commit = "226c1475a46a2ef6d840af9caa0117a439465500",
  event = "BufReadPost",
  dependencies = {
    {
      "JoosepAlviste/nvim-ts-context-commentstring",
      event = "VeryLazy",
      commit = "729d83ecb990dc2b30272833c213cc6d49ed5214",
    },
    {
      "nvim-tree/nvim-web-devicons",
      event = "VeryLazy",
      commit = "0568104bf8d0c3ab16395433fcc5c1638efc25d4"
    },
    {
      "p00f/nvim-ts-rainbow",
      event = "VeryLazy",
    },
    {
      "windwp/nvim-ts-autotag",
      event = "VeryLazy",
    },
  },
}

function M.config()
  local treesitter = require "nvim-treesitter"
  local configs = require "nvim-treesitter.configs"

  configs.setup {
    ensure_installed = "all",
    -- ensure_installed = "all", -- one of "all" or a list of languages
    ignore_install = { "" },                                                  -- List of parsers to ignore installing
    sync_install = false,                                                          -- install languages synchronously (only applied to `ensure_installed`)

    highlight = {
      enable = true,       -- false will disable the whole extension
      disable = { "css", "help", "latex" }, -- list of language that will be disabled
    },
    autopairs = {
      enable = true,
    },
    indent = { enable = true, disable = { "python", "css" } },

    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },

    autotag = {
		enable = true,
	},
	rainbow = {
		enable = true,
		-- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
		extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
		max_file_lines = nil, -- Do not enable for files with more than n lines, int
		-- colors = {}, -- table of hex strings
		-- termcolors = {} -- table of colour name strings
	},

  }
end

return M
