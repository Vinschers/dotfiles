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

	vim.api.nvim_create_autocmd({ "VimLeave" }, {
		pattern = { "*.tex" },
		callback = function()
			local directory = vim.fn.expand("%:p"):match("(.*[\\/])")
			local cmd = '[ "$(ls -1 "'
				.. directory
				.. '".latex-cache/*.pdf 2>/dev/null | wc -l)" -gt 0 ] && cp "'
				.. directory
				.. '".latex-cache/*.pdf "'
				.. directory
				.. '"; rm "'
				.. directory
				.. '"*.log'
			os.execute(cmd)
		end,
	})
end

return M
