return {
    { import = "lazyvim.plugins.extras.dap.core" },
    { import = "lazyvim.plugins.extras.coding.yanky" },
    { import = "lazyvim.plugins.extras.util.project" },
    { import = "lazyvim.plugins.extras.util.dot" },
    { import = "lazyvim.plugins.extras.test.core" },
    { import = "lazyvim.plugins.extras.ui.mini-indentscope" },
    { import = "lazyvim.plugins.extras.coding.mini-surround" },
    { import = "lazyvim.plugins.extras.coding.neogen" },
    { import = "lazyvim.plugins.extras.coding.codeium" },

    { "sainnhe/everforest" },
    { "shaunsingh/nord.nvim" },
    { "catppuccin/nvim" },

    { "folke/flash.nvim",                                    enabled = false },

    {
        "akinsho/bufferline.nvim",
        opts = function(_, opts)
            opts.options.always_show_bufferline = true
        end,
    },

    {
        "nvim-telescope/telescope.nvim",
        keys = {
            { "<leader>fF", "<cmd>Telescope live_grep<cr>", desc = "Find text" },
        },
    },

    {
        "NvChad/nvim-colorizer.lua",
        opts = {
            filetypes = { "*" },
        },
    },

    {
        "karb94/neoscroll.nvim",
        event = "VeryLazy",
        opts = {},
    },

    {
        "nvim-lualine/lualine.nvim",
        opts = function(_, opts)
            opts.sections.lualine_y = { { "location", padding = { left = 0, right = 1 } } }
            opts.sections.lualine_z = { { "progress" } }
        end,
    },

    {
        "nvim-neo-tree/neo-tree.nvim",
        opts = {
            filesystem = {
                filtered_items = {
                    hide_dotfiles = false,
                    hide_gitignored = false,
                },
                window = {
                    mappings = {
                        ["L"] = "open_nofocus",
                    },
                },
                commands = {
                    open_nofocus = function(state)
                        require("neo-tree.sources.filesystem.commands").open(state)
                        vim.schedule(function()
                            vim.cmd([[Neotree focus]])
                        end)
                    end,
                },
            },
            window = {
                mappings = {
                    ["l"] = "open",
                    ["h"] = "close_node",
                },
            },
        },
    },

    {
        "akinsho/toggleterm.nvim",
        dependencies = {
            "folke/which-key.nvim",
            opts = {
                spec = {
                    ["<leader>T"] = { name = "+Toggleterm" },
                },
            },
        },
        event = "VeryLazy",
        keys = {
            {
                "<F5>",
                function()
                    local Terminal = require("toggleterm.terminal").Terminal
                    local run_code = Terminal:new({
                        cmd = "run '" .. vim.fn.expand("%") .. "'",
                        hidden = true,
                        direction = "float",
                        shading_factor = 2,
                        float_opts = {
                            border = "curved",
                        },
                    })
                    run_code:toggle()
                end,
                desc = "Run file",
            },
            {
                "<leader>Tn",
                function()
                    local Terminal = require("toggleterm.terminal").Terminal
                    local ncdu = Terminal:new({ cmd = "ncdu --color off", hidden = true })
                    ncdu:toggle()
                end,
                desc = "NCDU",
            },
        },
        opts = {
            size = 16,
            open_mapping = "<C-\\>",
        },
    },

    {
        "nvim-neotest/neotest",
        opts = {
            adapters = {
                ["neotest-python"] = {},
                ["neotest-jest"] = {},
                ["neotest-rust"] = {},
                ["neotest-java"] = {},
                ["neotest-gtest"] = {},
            },
        },
    },

    {
        "xeluxee/competitest.nvim",
        dependencies = {
            "MunifTanjim/nui.nvim",
            {
                "folke/which-key.nvim",
                opts = {
                    spec = {
                        ["<leader>tc"] = { name = "+CompetiTest" },
                    },
                },
            },
        },
        keys = {
            { "<leader>tcr", "<cmd>CompetiTest run<cr>",               desc = "CompetiTest run tests" },
            { "<leader>tcc", "<cmd>CompetiTest receive contest<cr>",   desc = "CompetiTest get contest" },
            { "<leader>tcp", "<cmd>CompetiTest receive problem<cr>",   desc = "CompetiTest get problem" },
            { "<leader>tct", "<cmd>CompetiTest receive testcases<cr>", desc = "CompetiTest get test cases" },
        },
        opts = {
            received_problems_path = "$(CWD)/$(PROBLEM)/main.$(FEXT)",
            received_contests_directory = "$(CWD)",
            received_contests_problems_path = "$(PROBLEM)/main.$(FEXT)",
            testcases_directory = "./tests",
            testcases_input_file_format = "input$(TCNUM)",
            testcases_output_file_format = "output$(TCNUM)",
            template_file = {
                cpp = vim.fn.stdpath("config") .. "/templates/competitest.cpp",
                py = vim.fn.stdpath("config") .. "/templates/competitest.py",
            },
            evaluate_template_modifiers = true,
            date_format = "%d/%m/%Y %X",

            compile_command = {
                c = { exec = "gcc", args = { "-Wall", "-g", "-O2", "-lm", "$(FNAME)", "-o", "$(FNOEXT)" } },
                cpp = { exec = "g++", args = { "-Wall", "-g", "$(FNAME)", "-o", "$(FNOEXT)" } },
            },
        },
    },

    {
        "echasnovski/mini.bufremove",

        keys = {
            {
                "<C-w>",
                function()
                    local bd = require("mini.bufremove").delete
                    if vim.bo.modified then
                        local choice =
                            vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
                        if choice == 1 then -- Yes
                            vim.cmd.write()
                            bd(0)
                        elseif choice == 2 then -- No
                            bd(0, true)
                        end
                    else
                        bd(0)
                    end
                end,
                desc = "Delete Buffer",
            },
        },
    },
}
