local status_ok, dap = pcall(require, "dap")
if not status_ok then
	return
end

-- BELOW CODE WAS TAKEN FROM https://github.com/hallettj/dot-vim/blob/master/home/.config/nvim/lua/config/init.lua


-- Require all other `.lua` files in the same directory

local info = debug.getinfo(1, "S")
local module_directory = string.match(info.source, "^@(.*)/")
local module_filename = string.match(info.source, "/([^/]*)$")

-- Apparently the name of this module is given as an argument when it is
-- required, and apparently we get that argument with three dots.
local module_name = ... or "settings"

local function scandir(directory)
	local i, t, popen = 0, {}, io.popen
	local pfile = popen('ls -a "' .. directory .. '"')
	for filename in pfile:lines() do
		i = i + 1
		t[i] = filename
	end
	pfile:close()
	return t
end

local settings_files = vim.tbl_filter(function(filename)
	local is_lua_module = string.match(filename, "[.]lua$")
	local is_this_file = filename == module_filename
	return is_lua_module and not is_this_file
end, scandir(module_directory))

for _, filename in ipairs(settings_files) do
	local settings_module = string.match(filename, "(.+).lua$")
	require(module_name .. "." .. settings_module).setup(dap)
end
