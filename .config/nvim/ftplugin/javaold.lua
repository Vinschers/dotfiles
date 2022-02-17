local jdtls = require("jdtls")
-- If you started neovim within `~/dev/xy/project-1` this would resolve to `project-1`
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

local workspace_folder = vim.fn.stdpath("data") .. "/eclipse/" .. project_name
--                                               ^^
--                                               string concattenation in Lua

local jdtls_path = "/usr/share/java/jdtls"
local java_debug_path = vim.fn.stdpath("data") .. "/java-debug"


local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

local config = {
	settings = {
		java = {
			--[[ signatureHelp = { enabled = true },
			contentProvider = { preferred = "fernflower" },
			completion = {
				favoriteStaticMembers = {
					"org.hamcrest.MatcherAssert.assertThat",
					"org.hamcrest.Matchers.*",
					"org.hamcrest.CoreMatchers.*",
					"org.junit.jupiter.api.Assertions.*",
					"java.util.Objects.requireNonNull",
					"java.util.Objects.requireNonNullElse",
					"org.mockito.Mockito.*",
				},
			}, ]]
		},
	},
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
		"/home/scherer/.local/share/jdtls/plugins/org.eclipse.equinox.launcher_1.6.400*.jar",
		"-configuration",
		"/home/scherer/.local/share/jdtls/config_linux",
		"-data",
		"/home/scherer/eclipse",
	},
	init_options = {
		bundles = {
			-- java_debug_path .. "/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar",
		},
		-- extendedClientCapabilities = extendedClientCapabilities,
	},
	--[[ on_attach = function(client, bufnr)
        require("user.lsp.handlers").on_attach(client, bufnr)

		jdtls.add_commands()
		jdtls.setup_dap({ hotcodereplace = "auto" })
	end,
	capabilities = capabilities, ]]
}

jdtls.start_or_attach(config)
