STARTED_INKSCAPE_WATCH = false

local is_running = os.execute("isrunning inkscape-figures")

if is_running ~= 0 then
    os.execute("inkscape-figures watch")
    STARTED_INKSCAPE_WATCH = true
end


local directory = vim.fn.expand("%:p"):match("(.*[\\/])")
local cmd_get_file = "grep -lr --exclude-dir=\"" .. directory .. ".latex-cache\" '\\\\documentclass' \"" .. directory .. "\"*.tex 2> /dev/null | cut -f1 -d."

is_running = os.execute("isrunning $(" .. cmd_get_file .. ").pdf")

if is_running ~= 0 then
    local cmd = "[ -f \"$(" .. cmd_get_file .. ").pdf\" ] && sioyek \"$(" .. cmd_get_file .. ").pdf\" 1> /dev/null 2> /dev/null &"
    os.execute(cmd)
end

vim.cmd(":autocmd BufWritePost * silent !compile $(" .. cmd_get_file .. ").tex &")
