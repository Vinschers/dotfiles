local jdtls = require("jdtls")

local jdtls_path = vim.fn.stdpath("data") .. "/jdtls"
local java_debug_path = jdtls_path .. "/java-debug"

local workspace_dir = vim.fn.stdpath("data") .. "/eclipse/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

local config = {
	cmd = {
		"java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-Xms1g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",
		"-jar",
		jdtls_path .. "/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar",
		"-configuration",
		jdtls_path .. "/config_linux/",
		"-data",
		workspace_dir,
	},

	root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" }),

	settings = {
		java = {
			implementationsCodeLens = {
				enabled = true,
			},
		},
	},

	init_options = {
		bundles = {
			vim.fn.glob(
				java_debug_path .. "/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar"
			),
		},
		extendedClientCapabilities = extendedClientCapabilities,
	},
	capabilities = capabilities,
	on_attach = function(client, bufnr)
		require("user.lsp.handlers").on_attach(client, bufnr)
		jdtls.setup_dap({ hotcodereplace = "auto" })
		jdtls.setup.add_commands()
		require("jdtls.dap").setup_dap_main_class_configs()
	end,
}
jdtls.start_or_attach(config)
