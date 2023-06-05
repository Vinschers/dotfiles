local M = {
    "jose-elias-alvarez/null-ls.nvim",
    event = "BufReadPre",
    commit = "60b4a7167c79c7d04d1ff48b55f2235bf58158a7",
    dependencies = {
        {
            "nvim-lua/plenary.nvim",
            commit = "9a0d3bf7b832818c042aaf30f692b081ddd58bd9",
            lazy = true,
        },
    },
}

function M.config()
    local null_ls = require "null-ls"
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
    local formatting = null_ls.builtins.formatting
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
    local diagnostics = null_ls.builtins.diagnostics
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/code_actions
    local code_actions = null_ls.builtins.code_actions

    -- https://github.com/prettier-solidity/prettier-plugin-solidity
    null_ls.setup {
        debug = false,
        sources = {
            formatting.prettier,
            formatting.black.with({ extra_args = { "--fast", "-l", "130" } }),
            formatting.isort,
            formatting.stylua,
            formatting.clang_format.with({ extra_args = { "--style", "{BasedOnStyle: gnu, IndentWidth: 4}" } }),
            formatting.dart_format,
            formatting.shfmt,
            formatting.latexindent,
            formatting.google_java_format.with({ extra_args = { "-a" } }),
            formatting.bibclean,

            diagnostics.flake8,
            diagnostics.shellcheck,
            diagnostics.yamllint,
            diagnostics.chktex,

            code_actions.shellcheck,
            code_actions.eslint_d,
            code_actions.proselint,
        },
    }
end

return M
