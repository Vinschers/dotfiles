local status_ok, vimtex = pcall(require, "vimtex")
if not status_ok then
	return
end

vim.g.vimtex_view_method = 'zathura'

vim.g.vimtex_context_pdf_viewer = 1
vim.g.vimtex_view_general_viewer = 'okular'
vim.g.vimtex_view_general_options = '--unique file:@pdf\\#src:@line@tex'

vim.g.vimtex_compiler_latexmk = {
    build_dir = '',
    callback = 1,
    continuous = 1,
    executable = 'latexmk',
    hooks = {},
    options = {
        '-verbose',
        '-file-line-error',
        '-synctex=1',
        '-interaction=nonstopmode',
    },
}
