local cmp_status_ok, tokyonight = pcall(require, "tokyonight")
if not cmp_status_ok then
	return
end

tokyonight.setup({
    style = "night",
})

vim.cmd[[colorscheme tokyonight]]
