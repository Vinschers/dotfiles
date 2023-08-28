local M = {
	"kylechui/nvim-surround",
	version = "*", -- Use for stability; omit to use `main` branch for the latest features
	event = "VeryLazy",
}

function M.config()
	require("nvim-surround").setup({
        surrounds = {
            ["e"] = {
                add = function ()
                    local config = require("nvim-surround.config")
                    local environment = config.get_input("Enter the environment name: ")

                    if environment then
                        return { {"\\begin{" .. environment .. "}"}, {"\\end{" .. environment .. "}"} }
                    end
                end,
            }
        }
	})
end

return M
