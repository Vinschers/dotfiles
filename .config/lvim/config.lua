--[[
lvim is the global options object

Linters should be
filled in as strings with either
a global executable or a path to
an executable
]]
-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT

function COMPILE_CODE()
    local Terminal = require("toggleterm.terminal").Terminal
    Terminal:new({ cmd = "compile '" .. vim.fn.expand("%") .. "'", hidden = true }):toggle()
end

function RUN_CODE()
    local Terminal = require("toggleterm.terminal").Terminal
    Terminal:new({ cmd = "run_code '" .. vim.fn.expand('%') .. "'", hidden = true }):toggle()
end

function RUN_NCDU()
    local Terminal = require("toggleterm.terminal").Terminal
    Terminal:new({ cmd = "ncdu", hidden = true }):toggle()
end

function RUN_BTOP()
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

require("user.neovim").config()

lvim.builtin.notify.active = true
lvim.builtin.terminal.active = true
lvim.builtin.alpha.active = true
lvim.builtin.cheat = { active = true }
lvim.builtin.dap.active = true
lvim.lsp.diagnostics.virtual_text = true
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

require("user.builtin").config()

vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, {
    "clangd",
    "jdtls",
})

if lvim.builtin.dap.active then
    lvim.builtin.dap.on_config_done = function (dap)
        require("user.dap").config(dap)
    end
end

require("user.lsp").config()

require("user.plugins").config()

require("user.autocommands").config()

require("user.keybindings").config()
