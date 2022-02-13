local colorschemes = {"tokyonight", "system76", "material", "neon"}
local _, i, status_ok
local num_colors = #(colorschemes)

status_ok = false
i = 1

while (not status_ok and i <= num_colors) do
    local colorscheme = colorschemes[i]
    status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
    i = i + 1
end

if not status_ok then
    vim.notify("colorschemes not found!")
    return
end
