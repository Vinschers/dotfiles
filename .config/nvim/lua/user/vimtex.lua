local M = {
	"lervag/vimtex",
	lazy = false,
}

function M.config()
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
				.. "library.bib ] || bibexport --terse --output-file "
				.. directory
				.. "library.bib "
				.. latex_cache
				.. "/*.aux 2>/dev/null"
			os.execute(update_bib_cmd)
		end,
	})
end

return M
