return {
	"lervag/vimtex",
	lazy = false, -- lazy-loading will disable inverse search
	config = function()
		vim.api.nvim_create_autocmd({ "FileType" }, {
			group = vim.api.nvim_create_augroup("lazyvim_vimtex_conceal", { clear = true }),
			pattern = { "bib", "tex" },
			callback = function()
				vim.wo.conceallevel = 2
			end,
		})

		vim.g.vimtex_mappings_disable = { ["n"] = { "K" } } -- disable `K` as it conflicts with LSP hover
		vim.g.vimtex_quickfix_method = vim.fn.executable("pplatex") == 1 and "pplatex" or "latexlog"

		require("luasnip").config.set_config({
			-- Enable autotriggered snippets
			enable_autosnippets = true,

			update_events = "TextChanged, TextChangedI",
			store_selection_keys = "<Tab>",
		})

		vim.api.nvim_create_autocmd({ "BufUnload" }, {
			pattern = { "*.tex" },
			callback = function()
				local directory = '"' .. vim.fn.expand("<afile>:p"):match("(.*[\\/])") .. '"'
				local latex_cache = directory .. ".latex-cache"
				local cp_pdf_cmd = '[ "$(ls -1 '
					.. latex_cache
					.. '/*.pdf 2>/dev/null | wc -l)" -gt 0 ] && cp '
					.. latex_cache
					.. "/*.pdf "
					.. directory
					.. "; rm -f "
					.. directory
					.. "*.log"
				os.execute(cp_pdf_cmd)

				local update_bib_cmd = "[ -f "
					.. directory
					.. "library.bib ] || { rm -f "
					.. directory
					.. "export.bib && bibexport --terse --output-file "
					.. directory
					.. "export.bib "
					.. latex_cache
					.. "/*.aux 2>/dev/null; }"
				os.execute(update_bib_cmd)
			end,
		})

		vim.g.vimtex_imaps_enabled = 0

		vim.g.vimtex_view_method = "zathura"
		vim.g.tex_conceal = "abdmgs"
		vim.g.vimtex_indent_enabled = 0

		vim.cmd([[
            " Use `am` and `im` for the inline math text object
            omap am <Plug>(vimtex-a$)
            xmap am <Plug>(vimtex-a$)
            omap im <Plug>(vimtex-i$)
            xmap im <Plug>(vimtex-i$)

            " Use `ai` and `ii` for the item text object
            omap ai <Plug>(vimtex-am)
            xmap ai <Plug>(vimtex-am)
            omap ii <Plug>(vimtex-im)
            xmap ii <Plug>(vimtex-im)
        ]])
	end,
}
