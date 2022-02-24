local M = {}

M.setup = function(dap)
	dap.adapters.lldb = {
		type = "executable",
		command = "lldb-vscode", -- adjust as needed
		name = "lldb",
	}

	dap.configurations.cpp = {
		{
			name = "Launch",
			type = "lldb",
			request = "launch",
			program = "${fileDirname}/${fileBasenameNoExtension}",
			cwd = "${workspaceFolder}",
			stopOnEntry = false,
			args = {},
			initCommands = {
				"platform shell compile ${file}", -- Custom script to compile file
			},
			env = {
				PATH = "${env:PATH}",
			},

			-- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
			--
			--    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
			--
			-- Otherwise you might get the following error:
			--
			--    Error on launch: Failed to attach to the target process
			--
			-- But you should be aware of the implications:
			-- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
			runInTerminal = false,
		},
	}

	-- If you want to use this for rust and c, add something like this:
	dap.configurations.c = dap.configurations.cpp
	-- dap.configurations.rust = dap.configurations.cpp
end

return M