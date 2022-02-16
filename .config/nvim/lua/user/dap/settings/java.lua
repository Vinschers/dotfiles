local M = {}

M.setup = function(dap)
	dap.configurations.java = {
		javaExec = "java",
		mainClass = "your.package.name.MainClassName",

		name = "Launch YourClassName",
		request = "launch",
		type = "java",
	}
end

return M
