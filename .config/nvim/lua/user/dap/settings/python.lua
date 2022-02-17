local M = {}

M.setup = function(dap)
	local venv = os.getenv("VIRTUAL_ENV")
    local python_path = ''

    if (venv == nil) then
        python_path = '/usr/bin/python3'
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
end

return M
