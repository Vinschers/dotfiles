local M = {
	"mfussenegger/nvim-dap",
	commit = "6b12294a57001d994022df8acbe2ef7327d30587",
	event = "VeryLazy",
}

function M.config()
	local dap = require("dap")

	local dap_ui_status_ok, dapui = pcall(require, "dapui")
	if not dap_ui_status_ok then
		return
	end

	dap.listeners.after.event_initialized["dapui_config"] = function()
		dapui.open()
	end

	dap.listeners.before.event_terminated["dapui_config"] = function()
		dapui.close()
	end

	dap.listeners.before.event_exited["dapui_config"] = function()
		dapui.close()
	end

	local venv = os.getenv("VIRTUAL_ENV")
	local python_path = ""

	if venv == nil then
		python_path = "/usr/bin/python3"
	else
		python_path = string.format("%s/bin/python", venv)
	end

	dap.adapters.python = {
		type = "executable",
		command = python_path,
		args = { "-m", "debugpy.adapter" },
	}

	dap.configurations.python = {
		{
			-- The first three options are required by nvim-dap
			type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
			request = "launch",
			name = "Launch file",
			justMyCode = false,
			redirectOutput = true,

			-- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

			program = "${file}", -- This configuration will launch the current file if used.
			pythonPath = function()
				return python_path
			end,
		},
	}

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
		},
	}

	dap.configurations.c = dap.configurations.cpp
	dap.configurations.asm = dap.configurations.cpp
	-- dap.configurations.rust = dap.configurations.cpp

	dap.adapters.bash = {
		type = "executable",
		command = "bash-debug-adapter",
		name = "bash",
		args = {},
	}

	local BASHDB_DIR = require("mason-registry").get_package("bash-debug-adapter"):get_install_path()
		.. "/extension/bashdb_dir"
	dap.configurations.sh = {
		{
			type = "bash",
			request = "launch",
			name = "Bash: Launch file",
			program = "${file}",
			cwd = "${fileDirname}",
			pathBashdb = BASHDB_DIR .. "/bashdb",
			pathBashdbLib = BASHDB_DIR,
			pathBash = "bash",
			pathCat = "cat",
			pathMkfifo = "mkfifo",
			pathPkill = "pkill",
			env = {},
			args = {},
		},
	}

	local NODE2_DIR = require("mason-registry").get_package("node-debug2-adapter"):get_install_path()
		.. "/out/src/nodeDebug.js"

	dap.adapters.node2 = {
		type = "executable",
		command = "node",
		args = { NODE2_DIR },
	}

	dap.configurations.javascript = {
		{
			name = "Javascript: Launch file",
			type = "node2",
			request = "launch",
			program = "${file}",
			cwd = vim.fn.getcwd(),
			sourceMaps = true,
			protocol = "inspector",
			console = "integratedTerminal",
		},
	}
end

return M
