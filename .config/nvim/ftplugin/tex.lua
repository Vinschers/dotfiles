STARTED_INKSCAPE_WATCH = false

local is_running = os.execute("isrunning inkscape-figures")

if is_running ~= 0 then
	os.execute("inkscape-figures watch")
	STARTED_INKSCAPE_WATCH = true
end

vim.opt.conceallevel = 1

require("luasnip").config.set_config({
	-- Enable autotriggered snippets
	enable_autosnippets = true,

	update_events = "TextChanged, TextChangedI",
	store_selection_keys = "<Tab>",
})
