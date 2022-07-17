--[[
lvim is the global options object

Linters should be
filled in as strings with either
a global executable or a path to
an executable
]]
-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT

vim.opt.timeoutlen = 300

vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

vim.opt.relativenumber = true

vim.opt.titlestring = "Neovim | %F"

local function compile_code()
    local Terminal = require("toggleterm.terminal").Terminal
    Terminal:new({ cmd = "compile '" .. vim.fn.expand("%") .. "'", hidden = true }):toggle()
end

local function run_code()
    local Terminal = require("toggleterm.terminal").Terminal
    Terminal:new({ cmd = "run_code '" .. vim.fn.expand('%') .. "'", hidden = true }):toggle()
end

local function run_ncdu()
    local Terminal = require("toggleterm.terminal").Terminal
    Terminal:new({ cmd = "ncdu", hidden = true }):toggle()
end

local function run_btop()
    local Terminal = require("toggleterm.terminal").Terminal
    Terminal:new({ cmd = "btop", hidden = true }):toggle()
end

-- general
lvim.log.level = "warn"
lvim.format_on_save = false
lvim.colorscheme = "tokyonight"
-- to disable icons and use a minimalist setup, uncomment the following
-- lvim.use_icons = false

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.normal_mode["<C-w>"] = ":BufferKill<cr>"
lvim.keys.normal_mode["K"] = "I<BS> <ESC>"

vim.keymap.set("n", "<F4>", compile_code)
vim.keymap.set("n", "<F5>", run_code)
lvim.keys.normal_mode["<F6>"] = ":lua require'dap'.continue()<cr>"
lvim.keys.normal_mode["<F9>"] = ":lua require'dap'.toggle_breakpoint()<cr>"
lvim.keys.normal_mode["<F10>"] = ":lua local row, _ = unpack(vim.api.nvim_win_get_cursor(0)); if (row < vim.api.nvim_buf_line_count(0)) then require'dap'.step_over() else require'dap'.continue() end<cr>"
lvim.keys.normal_mode["<F11>"] = ":lua local row, _ = unpack(vim.api.nvim_win_get_cursor(0)); if (row < vim.api.nvim_buf_line_count(0)) then require'dap'.step_into() else require'dap'.continue() end<cr>"

-- unmap a default keymapping
-- vim.keymap.del("n", "<C-Up>")
vim.keymap.del("i", "jj")
vim.keymap.del("i", "jk")
vim.keymap.del("i", "kj")

lvim.lsp.buffer_mappings.normal_mode = {
    ["gd"] = { vim.lsp.buf.definition, "Goto Definition" },
    ["gD"] = { vim.lsp.buf.declaration, "Goto declaration" },
    ["gr"] = { vim.lsp.buf.references, "Goto references" },
    ["gI"] = { vim.lsp.buf.implementation, "Goto Implementation" },
    ["gs"] = { vim.lsp.buf.signature_help, "show signature help" },
    ["gp"] = {
        function()
            require("lvim.lsp.peek").Peek "definition"
        end,
        "Peek definition",
    },
    ["gl"] = {
        function()
            local config = lvim.lsp.diagnostics.float
            config.scope = "line"
            vim.diagnostic.open_float(0, config)
        end,
        "Show line diagnostics",
    },
}
-- override a default keymapping
lvim.keys.insert_mode["<C-A-j>"] = "<Esc>:m .+1<CR>==gi"
lvim.keys.insert_mode["<C-A-k>"] = "<Esc>:m .-2<CR>==gi"
lvim.keys.insert_mode["<C-A-Up>"] = "<C-\\><C-N><C-w>k"
lvim.keys.insert_mode["<C-A-Down>"] = "<C-\\><C-N><C-w>j"
lvim.keys.insert_mode["<C-A-Left>"] = "<C-\\><C-N><C-w>h"
lvim.keys.insert_mode["<C-A-Right>"] = "<C-\\><C-N><C-w>l"

lvim.keys.normal_mode["<C-A-j>"] = ":m .+1<CR>=="
lvim.keys.normal_mode["<C-A-k>"] = ":m .-2<CR>=="

lvim.keys.visual_block_mode["<C-A-j>"] = ":m '>+1<CR>gv-gv"
lvim.keys.visual_block_mode["<C-A-k>"] = ":m '<-2<CR>gv-gv"

lvim.builtin.terminal.open_mapping = "<C-\\>"

-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
local _, actions = pcall(require, "telescope.actions")
lvim.builtin.telescope.defaults.mappings = {
    -- for input mode
    i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-p>"] = actions.cycle_history_prev,
        ["<C-n>"] = actions.cycle_history_next,
    },
    -- for normal mode
    n = {
        ["j"] = actions.move_selection_next,
        ["k"] = actions.move_selection_previous,
        ["p"] = actions.cycle_history_prev,
        ["n"] = actions.cycle_history_next,
    },
}

-- Use which-key to add extra bindings with the leader-key prefix
lvim.builtin.which_key.mappings["l"]["g"] = { vim.lsp.buf.hover, "Show hover" }
lvim.builtin.which_key.mappings["l"]["s"] = { "<cmd>SymbolsOutline<cr>", "Show symbols outline" }
-- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
lvim.builtin.which_key.mappings["l"]["t"] = {
    name = "+Trouble",
    r = { "<cmd>Trouble lsp_references<cr>", "References" },
    f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
    d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
    q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
    l = { "<cmd>Trouble loclist<cr>", "LocationList" },
    w = { "<cmd>Trouble workspace_diagnostics<cr>", "Wordspace Diagnostics" },
}
lvim.builtin.which_key.mappings["F"] = { "<cmd>Telescope live_grep theme=ivy<cr>", "Find text" }
lvim.builtin.which_key.mappings["t"] = {
    name = "Vimtex",
    c = { "<cmd>VimtexCompile<CR>", "Compile" },
    C = { "<cmd>VimtexClean!<CR> <cmd>VimtexClearCache vim.fn.expand('%')<CR> <cmd>!rm *_vimtex_selected*<CR>",
        "Clean auxiliary and cache files" },
    d = { "<cmd>VimtexDocPackage<CR>", "Download documentation of package under cursor" },
    e = { "<cmd>VimtexErrors<CR>", "Check errors log" },
    i = { "<cmd>VimtexTocOpen<CR>", "Open index" },
    m = { "<cmd>VimtexToggleMain<CR>", "Change main project file" },
    s = { "<cmd>VimtexStop<CR>", "Stop compilation" },
    v = { "<cmd>VimtexView<CR>", "Open preview" },
    w = { "<cmd>VimtexCountWords!<CR>", "Count number of words" },
}
lvim.builtin.which_key.mappings["T"] = {
    name = "Terminal",
    n = { run_ncdu, "NCDU" },
    b = { run_btop, "btop" },
    f = { "<cmd>ToggleTerm direction=float<cr>", "Float" },
    h = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", "Horizontal" },
    v = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", "Vertical" },
}

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.notify.active = true
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = true

lvim.builtin.bufferline.options.always_show_bufferline = true

lvim.builtin.treesitter.rainbow.enable = true

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
    "bash",
    "c",
    "css",
    "dart",
    "java",
    "javascript",
    "json",
    "lua",
    "python",
    "rust",
    "yaml",
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true

lvim.builtin.dap.active = true

-- generic LSP settings

-- ---@usage disable automatic installation of servers
-- lvim.lsp.automatic_servers_installation = false

-- ---configure a server manually. !!Requires `:LvimCacheReset` to take effect!!
-- ---see the full default list `:lua print(vim.inspect(lvim.lsp.automatic_configuration.skipped_servers))`
-- vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pyright" })
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pyright", opts)

-- ---remove a server from the skipped list, e.g. eslint, or emmet_ls. !!Requires `:LvimCacheReset` to take effect!!
-- ---`:LvimInfo` lists which server(s) are skiipped for the current filetype
-- vim.tbl_map(function(server)
--   return server ~= "emmet_ls"
-- end, lvim.lsp.automatic_configuration.skipped_servers)

-- -- you can set a custom on_attach function that will be used for all the language servers
-- -- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end

-- -- set a formatter, this will override the language server formatting capabilities (if it exists)
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
    { command = "black", filetypes = { "python" } },
    { command = "isort", filetypes = { "python" } },
    { command = "clang-format", filetype = { "c", "cpp", "cs", "java" },
        extra_args = { "--style", "{BasedOnStyle: gnu, IndentWidth: 4}" } },
}

vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "clangd" })

-- -- set additional linters
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
    { command = "flake8", filetypes = { "python" } },
    {
        -- each linter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
        command = "shellcheck",
        ---@usage arguments to pass to the formatter
        -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
        extra_args = { "--severity", "warning" },
    },
    {
        command = "codespell",
        ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
        filetypes = { "javascript", "python" },
    },
}


lvim.builtin.alpha.dashboard.section = {
    header = {
        type = "text",
        val = {
            "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣤⣤⣶⣶⣶⣿⣿⣷⣶⣶⣦⣤⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
            "⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣴⣾⡿⠟⠋⠉⠁⠀⠀⠀⠀⠀⠀⠀⠉⠙⠛⠿⣿⣦⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀",
            "⠀⠀⠀⠀⠀⠀⠀⣠⣾⡿⠋⠁⢰⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠻⣿⣦⡀⠀⠀⠀⠀⠀⠀",
            "⠀⠀⠀⠀⠀⣠⣾⡟⠁⠀⠀⠀⠘⢿⣿⣦⣤⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣈⣿⣿⣶⣾⣿⣿⣷⡆",
            "⠀⠀⠀⠀⣴⣿⠋⠀⠀⠀⠀⠀⠀⣾⣿⣿⣿⣿⣿⡆⠀⠀⠀⠀⠀⢀⣠⣤⣶⡿⠿⠛⠋⠉⢻⣷⣄⣽⡿⠃",
            "⠀⠀⠀⣼⣿⠃⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⣿⠀⠀⣀⣤⣶⣾⣿⣛⣉⣁⣤⡤⠀⠀⠀⣠⣿⣿⡏⠀⠀",
            "⠀⠀⢰⣿⠃⠀⠀⠀⠀⠀⠀⠀⠈⠉⠛⠻⣿⣿⣿⣷⣿⣿⠿⣿⣻⣿⣿⣿⣿⠏⠀⣀⣴⣾⠟⠋⢻⣷⠀⠀",
            "⠀⠀⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣴⣿⡿⣋⣭⣷⣾⣿⣿⣿⣿⣿⠟⢁⣤⣾⠿⠋⠁⠀⠀⠘⣿⡇⠀",
            "⠀⠀⣿⡇⠀⠀⠀⠀⠀⠀⠀⣠⣴⣿⣿⡿⣫⣾⣿⣿⣿⣿⣿⣿⣿⣿⣯⣾⡿⠛⠁⠀⠀⠀⠀⠀⠀⣿⡇⠀",
            "⠀⠀⣿⡇⠀⠀⠀⠀⣠⣴⡿⠟⣽⢿⣿⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡇⠀",
            "⠀⠀⣿⣧⠀⢀⣴⣾⠿⠋⢠⣾⣵⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⡇⠀",
            "⠀⠀⠸⣿⣶⡿⠛⠁⠀⠔⠛⠛⠋⠉⣉⣥⣶⣿⠿⠛⠻⢿⣿⣿⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⡿⠀⠀",
            "⠀⢀⣾⣿⣿⡄⠀⠀⠀⢀⣠⣴⣶⡿⠟⠋⠁⠀⠀⠀⠀⠀⠀⢙⣿⣷⣶⣄⠀⠀⠀⠀⠀⠀⠀⣸⣿⠃⠀⠀",
            "⢠⣿⣿⣁⣻⣿⣤⣶⡿⠿⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⣿⣿⡿⠀⣀⠀⠀⠀⢀⣼⡿⠃⠀⠀⠀",
            "⠈⠻⠿⠟⠛⠛⢿⣷⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣉⣻⣿⣾⡟⠀⠀⣠⣾⠟⠁⠀⠀⠀⠀",
            "⠀⠀⠀⠀⠀⠀⠀⠙⢿⣷⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠛⠛⠛⠛⣀⣴⣾⠟⠁⠀⠀⠀⠀⠀⠀",
            "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠻⢿⣷⣦⣄⣀⡀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣤⣴⣾⠿⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀",
            "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠛⠻⠿⠿⢿⣿⣿⣿⠿⠿⠿⠛⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
        },
        opts = {
            position = "center",
            hl = "Label",
        }
    },
    buttons = {
        entries = {
            { "f", "  Find File", "<CMD>Telescope find_files<CR>" },
            { "n", "  New File", "<CMD>ene!<CR>" },
            { "P", "  Recent Projects ", "<CMD>Telescope projects<CR>" },
            { "r", "  Recently Used Files", "<CMD>Telescope oldfiles<CR>" },
            { "F", "  Find Word", "<CMD>Telescope live_grep<CR>" },
            {
                "c",
                "  Configuration",
                "<CMD>edit " .. require("lvim.config"):get_user_config_path() .. " <CR>",
            },
            { "q", "  Quit Neovim", ":qa<CR>" }
        }
    }
}

-- Additional Plugins
lvim.plugins = {
    { "folke/tokyonight.nvim" },
    {
        "folke/trouble.nvim",
        cmd = "TroubleToggle",
    },
    {
        "nacro90/numb.nvim",
        event = "BufRead",
        config = function()
            require("numb").setup {
                show_numbers = true, -- Enable 'number' for the window while peeking
                show_cursorline = true, -- Enable 'cursorline' for the window while peeking
            }
        end,
    },
    {
        "kevinhwang91/nvim-bqf",
        event = { "BufRead", "BufNew" },
        config = function()
            require("bqf").setup({
                auto_enable = true,
                preview = {
                    win_height = 12,
                    win_vheight = 12,
                    delay_syntax = 80,
                    border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
                },
                func_map = {
                    vsplit = "",
                    ptogglemode = "z,",
                    stoggleup = "",
                },
                filter = {
                    fzf = {
                        action_for = { ["ctrl-s"] = "split" },
                        extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
                    },
                },
            })
        end,
    },
    {
        "kevinhwang91/rnvimr",
        cmd = "RnvimrToggle",
        config = function()
            vim.g.rnvimr_draw_border = 1
            vim.g.rnvimr_pick_enable = 1
            vim.g.rnvimr_bw_enable = 1
        end,
    },
    {
        "f-person/git-blame.nvim",
        event = "BufRead",
        config = function()
            vim.cmd "highlight default link gitblame SpecialComment"
            vim.g.gitblame_enabled = 1
        end,
    },
    {
        "windwp/nvim-ts-autotag",
        config = function()
            require("nvim-ts-autotag").setup()
        end,
    },
    {
        "p00f/nvim-ts-rainbow",
    },
    {
        "romgrk/nvim-treesitter-context",
        config = function()
            require("treesitter-context").setup {
                enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
                throttle = true, -- Throttles plugin updates (may improve performance)
                max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
                patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
                    -- For all filetypes
                    -- Note that setting an entry here replaces all other patterns for this entry.
                    -- By setting the 'default' entry below, you can control which nodes you want to
                    -- appear in the context window.
                    default = {
                        'class',
                        'function',
                        'method',
                    },
                },
            }
        end
    },
    {
        "norcalli/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup({ "*" }, {
                RGB = true, -- #RGB hex codes
                RRGGBB = true, -- #RRGGBB hex codes
                RRGGBBAA = true, -- #RRGGBBAA hex codes
                rgb_fn = true, -- CSS rgb() and rgba() functions
                hsl_fn = true, -- CSS hsl() and hsla() functions
                css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
                css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
            })
        end,
    },
    {
        "ray-x/lsp_signature.nvim",
        event = "BufRead",
        config = function() require "lsp_signature".on_attach() end,
    },
    {
        "simrat39/symbols-outline.nvim",
        cmd = "SymbolsOutline",
    },
    {
        "karb94/neoscroll.nvim",
        event = "WinScrolled",
        config = function()
            require('neoscroll').setup({
                -- All these keys will be mapped to their corresponding default scrolling animation
                mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>',
                    '<C-y>', '<C-e>', 'zt', 'zz', 'zb' },
                hide_cursor = true, -- Hide cursor while scrolling
                stop_eof = true, -- Stop at <EOF> when scrolling downwards
                use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
                respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
                cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
                easing_function = nil, -- Default easing function
                pre_hook = nil, -- Function to run before the scrolling animation starts
                post_hook = nil, -- Function to run after the scrolling animation ends
            })
        end
    },
    {
        "ethanholz/nvim-lastplace",
        event = "BufRead",
        config = function()
            require("nvim-lastplace").setup({
                lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
                lastplace_ignore_filetype = {
                    "gitcommit", "gitrebase", "svn", "hgcommit",
                },
                lastplace_open_folds = true,
            })
        end,
    },
    {
        "folke/todo-comments.nvim",
        event = "BufRead",
        config = function()
            require("todo-comments").setup()
        end,
    },
    {
        "tpope/vim-surround",
        keys = { "c", "d", "y" },
        -- make sure to change the value of `timeoutlen` if it's not triggering correctly, see https://github.com/tpope/vim-surround/issues/117
        setup = function()
         vim.o.timeoutlen = 500
        end
    },
    {
        "lervag/vimtex"
    }
}

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
-- vim.api.nvim_create_autocmd("BufEnter", {
--   pattern = { "*.json", "*.jsonc" },
--   -- enable wrap mode for json files only
--   command = "setlocal wrap",
-- })
vim.api.nvim_create_autocmd("FileType", {
    pattern = "zsh",
    callback = function()
        -- let treesitter use bash highlight for zsh files as well
        require("nvim-treesitter.highlight").attach(0, "bash")
    end,
})

vim.api.nvim_command("set whichwrap-=h,l")
