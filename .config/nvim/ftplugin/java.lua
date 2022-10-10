local status_ok, jdtls = pcall(require, "jdtls")
if not status_ok then
	return
end

local workspace_path = vim.fn.stdpath("data") .. "/jdtls-workspace/"
local JAVA_LS_EXECUTABLE = "jdtls"

jdtls.start_or_attach({
	on_attach = function(client, bufnr)
		require("user.lsp.handlers").on_attach(client, bufnr)
		require("jdtls").setup_dap({ hotcodereplace = "auto" })
		require("jdtls.setup").add_commands()
        require("jdtls.dap").setup_dap_main_class_configs()
	end,
	flags = {
		allow_incremental_sync = true,
		server_side_fuzzy_completion = true,
	},
	settings = {
		["java.format.settings.url"] = vim.fn.stdpath("config") .. "/.java-google-formatter.xml",
		["java.format.settings.profile"] = "GoogleStyle",
	},
	init_options = {
		bundles = {
			vim.fn.glob(
				vim.fn.stdpath("data")
					.. "/lsp_servers/jdtls/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar"
			),
		},
	},
	cmd = { JAVA_LS_EXECUTABLE, workspace_path .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t") },
})
