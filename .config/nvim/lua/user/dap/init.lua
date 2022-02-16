local status_ok, _ = pcall(require, "dap")
if not status_ok then
	return
end

vim.fn.sign_define("DapBreakpoint", {
	text = "🛑",
	texthl = "LspDiagnosticsSignError",
	linehl = "",
	numhl = "",
})
vim.fn.sign_define("DapBreakpointRejected", {
	text = "🛑",
	texthl = "LspDiagnosticsSignHint",
	linehl = "",
	numhl = "",
})
vim.fn.sign_define("DapStopped", {
	text = "",
	texthl = "LspDiagnosticsSignInformation",
	linehl = "DiagnosticUnderlineInfo",
	numhl = "LspDiagnosticsSignInformation",
})


require("user.dap.dapui")
require("user.dap.settings")
