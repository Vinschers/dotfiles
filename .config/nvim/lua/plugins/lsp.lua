return {
    { import = "lazyvim.plugins.extras.lang.ansible" },
    { import = "lazyvim.plugins.extras.lang.git" },
    { import = "lazyvim.plugins.extras.lang.python" },
    { import = "lazyvim.plugins.extras.lang.clangd" },
    { import = "lazyvim.plugins.extras.lang.docker" },
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.lang.rust" },
    { import = "lazyvim.plugins.extras.lang.yaml" },
    { import = "lazyvim.plugins.extras.lang.toml" },
    { import = "lazyvim.plugins.extras.lang.json" },
    { import = "lazyvim.plugins.extras.lang.java" },
    { import = "lazyvim.plugins.extras.lang.markdown" },
    { import = "lazyvim.plugins.extras.lang.tex" },
    { import = "lazyvim.plugins.extras.lang.tailwind" },
    { import = "lazyvim.plugins.extras.lang.sql" },

    -- { import = "lazyvim.plugins.extras.lsp.none-ls" },
    { import = "lazyvim.plugins.extras.editor.refactoring" },

    { import = "lazyvim.plugins.extras.coding.luasnip" },

    { import = "lazyvim.plugins.extras.formatting.prettier" },
    { import = "lazyvim.plugins.extras.formatting.black" },

    { import = "lazyvim.plugins.extras.test.core" },

    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                basedpyright = {
                    settings = {
                        basedpyright = {
                            analysis = {
                                typeCheckingMode = "standard",
                            },
                        },
                    },
                },
            },
        },
    },

    {
        "stevearc/conform.nvim",
        opts = function(_, opts)
            opts.formatters_by_ft = {
                c = { "clang_format" },
                cpp = { "clang_format" },
                html = { "prettier" },
                css = { "prettier" },
                scss = { "prettier" },
                js = { "prettier" },
            }

            opts.formatters.clang_format = {
                prepend_args = { "--style", "{BasedOnStyle: gnu, IndentWidth: 4, BreakBeforeBraces: Allman}" },
            }

            opts.formatters.prettier = {
                prepend_args = { "--config", os.getenv("HOME") .. "/.config/.prettierrc.yaml" },
            }

            opts.formatters.black = {
                prepend_args = { "--fast", "-l", "150" },
            }

            opts.formatters.shfmt = {
                prepend_args = { "--indent", "4" },
            }

            opts.formatters.stylua = {
                prepend_args = { "--config-path", os.getenv("HOME") .. "/.config/.stylua.toml" },
            }
        end,
    },

    {
        "mfussenegger/nvim-lint",
        opts = {
            linters_by_ft = {
                sh = { "shellcheck" },
                yaml = { "yamllint" },
                yml = { "yamllint" },
                tex = { "chktex" },
            },

            linters = {
                ["markdownlint-cli2"] = {
                    args = { "--config", os.getenv("HOME") .. "/.config/.markdownlint.jsonc" },
                },
            },
        },
    },

    -- {
    --     "nvimtools/none-ls.nvim",
    --     dependencies = {
    --         "gbprod/none-ls-shellcheck.nvim",
    --     },
    --     opts = function(_, opts)
    --         local nls = require("null-ls")
    --         opts.root_dir = opts.root_dir
    --             or require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git")
    --         opts.sources = vim.list_extend(opts.sources or {}, {
    --             nls.builtins.code_actions.refactoring,
    --             nls.builtins.code_actions.proselint,
    --             nls.builtins.code_actions.ts_node_action,
    --         })
    --
    --         nls.register(require("none-ls-shellcheck.code_actions"))
    --     end,
    -- },

    {
        "mfussenegger/nvim-dap",
        opts = function()
            local dap = require("dap")
            for _, lang in ipairs({ "c", "cpp" }) do
                dap.configurations[lang] = {
                    {
                        type = "codelldb",
                        request = "launch",
                        name = "Launch file",
                        cwd = "${workspaceFolder}",
                        program = "${fileDirname}/${fileBasenameNoExtension}",
                        initCommands = {
                            'platform shell compile "${file}"', -- Custom script to compile file
                        },
                        env = {
                            PATH = "${env:PATH}",
                        },
                    },
                }
            end
        end,
    },

    {
        "L3MON4D3/LuaSnip",
        config = function()
            require("luasnip.loaders.from_lua").lazy_load({ paths = { vim.fn.stdpath("config") .. "/lua/snippets" } })
        end,
    },

    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-emoji",
        },
        opts = function(_, opts)
            local luasnip = require("luasnip")
            local cmp = require("cmp")

            table.insert(opts.sources, { name = "emoji" })

            if not opts.completion.completeopt:find("noselect") then
                opts.completion.completeopt = opts.completion.completeopt .. ",noselect"
            end

            opts.mapping = vim.tbl_extend("force", opts.mapping, {
                ["<C-l>"] = cmp.mapping(function(fallback)
                    if luasnip.expand_or_jumpable() then
                        luasnip.jump(1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<C-h>"] = cmp.mapping(function(fallback)
                    if luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expandable() then
                        luasnip.expand()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            })
        end,
    },
}
