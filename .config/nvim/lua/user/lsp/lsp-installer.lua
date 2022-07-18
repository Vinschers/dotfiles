local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
	return
end

lsp_installer.setup()

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
	return
end

local function file_exists(name)
	local f = io.open(name, "r")
	if f ~= nil then
		io.close(f)
		return true
	else
		return false
	end
end

local opts = {}

for _, server in pairs(lsp_installer.get_installed_servers()) do
	server = server.name
	opts = {
		on_attach = require("user.lsp.handlers").on_attach,
		capabilities = require("user.lsp.handlers").capabilities,
	}

    if file_exists("user.lsp.settings." .. server) then
        local new_opts = require("user.lsp.settings." .. server)
        opts = vim.tbl_deep_extend("force", new_opts, opts)
    end

	lspconfig[server].setup(opts)
end
