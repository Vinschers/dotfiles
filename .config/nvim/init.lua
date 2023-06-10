require("config.options")
require("config.lazy")
require("config.autocommands")
require("config.keymaps")

if vim.g.neovide
then
    vim.opt.guifont = "monospace:h12"
else
    vim.opt.guifont = "monospace:h17"
end
