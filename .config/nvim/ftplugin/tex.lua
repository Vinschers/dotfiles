STARTED_INKSCAPE_WATCH = false

local is_running = os.execute("isrunning inkscape-figures")

if is_running ~= 0 then
    os.execute("inkscape-figures watch")
    STARTED_INKSCAPE_WATCH = true
end

vim.opt.conceallevel = 1
vim.g.tex_conceal = "abdmg"
