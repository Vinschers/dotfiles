local dap_status_ok, dap = pcall(require, "dap")
if not dap_status_ok then
	return
end

local dap_ui_status_ok, dapui = pcall(require, "dapui")
if not dap_ui_status_ok then
	return
end

dapui.setup({
	icons = { expanded = "▾", collapsed = "▸" },
	mappings = {
		-- Use a table to apply multiple mappings
		expand = { "<CR>", "<2-LeftMouse>" },
		open = "o",
		remove = "d",
		edit = "e",
		repl = "r",
	},
	sidebar = {
		-- You can change the order of elements in the sidebar
		elements = {
			-- Provide as ID strings or tables with "id" and "size" keys
			{
				id = "scopes",
				size = 0.25, -- Can be float or integer > 1
			},
			{ id = "breakpoints", size = 0.25 },
			{ id = "stacks", size = 0.25 },
			{ id = "watches", size = 00.25 },
		},
		size = 40,
		position = "left", -- Can be "left", "right", "top", "bottom"
	},
	tray = {
		elements = { "repl" },
		size = 10,
		position = "bottom", -- Can be "left", "right", "top", "bottom"
	},
	floating = {
		max_height = nil, -- These can be integers or a float between 0 and 1.
		max_width = nil, -- Floats will be treated as percentage of your screen.
		border = "single", -- Border style. Can be "single", "double" or "rounded"
		mappings = {
			close = { "q", "<Esc>" },
		},
	},
	windows = { indent = 1 },
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

dap.adapters.mix_task = {
	type = "executable",
	command = vim.fn.stdpath("data") .. "/lsp_servers/elixir/elixir-ls/debugger.sh",
	args = {},
}

dap.configurations.elixir = {
	{
		type = "mix_task",
		name = "mix test",
		task = "test",
		taskArgs = { "--trace" },
		request = "launch",
		startApps = true, -- for Phoenix projects
		projectDir = "${workspaceFolder}",
		requireFiles = {
			"test/**/test_helper.exs",
			"test/**/*_test.exs",
		},
	},
}

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
