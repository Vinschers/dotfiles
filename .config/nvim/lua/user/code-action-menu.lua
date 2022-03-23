local status_ok, camenu = pcall(require, "code_action_menu")
if not status_ok then
	return
end

vim.g.code_action_menu_show_details = false
