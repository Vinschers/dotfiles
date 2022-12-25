local cmp_status_ok, tokyonight = pcall(require, "tokyonight")
if not cmp_status_ok then
	return
end

tokyonight.setup({
    style = "moon",
    transparent = true,
    styles = {
        sidebars = "transparent",
        floats = "transparent",
    }
})

vim.cmd[[colorscheme tokyonight]]
