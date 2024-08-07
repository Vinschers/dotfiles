local map = vim.keymap.set
local del = vim.keymap.del

-- del({ "n" }, "<leader>l")

-- Buffers
map({ "n", "x", "v" }, "<C-t>", "<cmd>ene<cr>")
map({ "n" }, "<F1>", "")

map({ "n" }, "Ç", ":")
map({ "i" }, "<C-l>", "\\")
map({ "n", "i" }, "<C-a>", "ggVG")

map({ "n" }, "<Esc>", "<Esc><cmd>noh<cr><cmd>lua require('notify').dismiss()<cr>")
map({ "n" }, "<leader>h", "<Esc><cmd>noh<cr><cmd>lua require('notify').dismiss()<cr>", { desc = "Clear highlights" })

map({ "v" }, "p", "P")

map({ "n", "i" }, "<F4>", ":! compile " .. vim.fn.expand("%") .. ">/dev/null<cr><cr>", { desc = "Compile file" })
map({ "n", "i" }, "<F6>", "<cmd>lua require('dap').continue()<cr>")
map({ "n", "i" }, "<F9>", "<cmd>lua require('dap').toggle_breakpoint()<cr>")
map({ "n", "i" }, "<F10>", "<cmd>lua require('dap').step_over()<cr>")
map({ "n", "i" }, "<F11>", "<cmd>lua require('dap').step_into()<cr>")

map({ "n" }, "<leader>C", "<cmd>set spell! spelllang=en_us,pt,fr,de<cr>", { desc = "Toggle spell check" })

-- For Neovide
map({ "n" }, "<c-c>", '"+y')
map({ "v" }, "<c-c>", '"+y')

-- map({ "n" }, "<c-v>", '"+p')
map({ "i" }, "<c-v>", "<c-r>+", { noremap = true })
map({ "c" }, "<c-v>", "<c-r>+", { noremap = true })
map({ "i" }, "<c-r>", "<c-v>", { noremap = true })
