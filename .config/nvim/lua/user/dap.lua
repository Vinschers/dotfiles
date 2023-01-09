local dap_status_ok, dap = pcall(require, "dap")
if not dap_status_ok then
	return
end

local dap_ui_status_ok, dapui = pcall(require, "dapui")
if not dap_ui_status_ok then
	return
end

local dap_install_status_ok, dap_install = pcall(require, "dap-install")
if not dap_install_status_ok then
	return
end

dap_install.setup({})

dap_install.config("python", {})
-- add other configs here

dapui.setup({
	expand_lines = true,
	icons = { expanded = "", collapsed = "", circular = "" },
	mappings = {
		-- Use a table to apply multiple mappings
		expand = { "<CR>", "<2-LeftMouse>" },
		open = "o",
		remove = "d",
		edit = "e",
		repl = "r",
		toggle = "t",
	},
	layouts = {
		{
			elements = {
				{ id = "scopes", size = 0.33 },
				{ id = "breakpoints", size = 0.17 },
				{ id = "stacks", size = 0.25 },
				{ id = "watches", size = 0.25 },
			},
			size = 0.33,
			position = "right",
		},
		{
			elements = {
				{ id = "repl", size = 0.45 },
				{ id = "console", size = 0.55 },
			},
			size = 0.27,
			position = "bottom",
		},
	},
	floating = {
		max_height = 0.9,
		max_width = 0.5, -- Floats will be treated as percentage of your screen.
		border = vim.g.border_chars, -- Border style. Can be 'single', 'double' or 'rounded'
		mappings = {
			close = { "q", "<Esc>" },
		},
	},
})

vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "DiagnosticSignError", linehl = "", numhl = "" })

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
dap.configurations.asm = dap.configurations.cpp
-- dap.configurations.rust = dap.configurations.cpp

local function sep_os_replacer(str)
	local result = str
	local path_sep = package.config:sub(1, 1)
	result = result:gsub("/", path_sep)
	return result
end

local function join_path(...)
	local result = table.concat({ ... }, "/")
	return result
end

dap.configurations.dart = {
	{
		type = "dart",
		request = "launch",
		name = "Launch flutter",
		dartSdkPath = sep_os_replacer(join_path(vim.fn.expand("~/"), "/flutter/bin/cache/dart-sdk/")),
		flutterSdkPath = sep_os_replacer(join_path(vim.fn.expand("~/"), "/flutter")),
		program = sep_os_replacer("${workspaceFolder}/lib/main.dart"),
		cwd = "${workspaceFolder}",
	},
}

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
    args = {NODE2_DIR},
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
