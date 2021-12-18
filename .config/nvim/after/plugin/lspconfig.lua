local nvim_lsp = require('lspconfig')
local coq = require "coq"

local protocol = require'vim.lsp.protocol'

local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end  -- Mappings.
    local opts = { noremap=true, silent=true }

    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<C-d>', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<C-f>', '<cmd>lua vim.lsp.buf.formatting_sync()<CR>', opts)

    protocol.CompletionItemKind = {
        '', -- Text
        '', -- Method
        '', -- Function
        '', -- Constructor
        '', -- Field
        '', -- Variable
        '', -- Class
        'ﰮ', -- Interface
        '', -- Module
        '', -- Property
        '', -- Unit
        '', -- Value
        '', -- Enum
        '', -- Keyword
        '﬌', -- Snippet
        '', -- Color
        '', -- File
        '', -- Reference
        '', -- Folder
        '', -- EnumMember
        '', -- Constant
        '', -- Struct
        '', -- Event
        'ﬦ', -- Operator
        '', -- TypeParameter
    }
end

--local servers = {}
local servers = { 'pyright', 'vimls', 'bashls', 'ccls' }

for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup(coq.lsp_ensure_capabilities({
        on_attach = on_attach
    }))
end

nvim_lsp.java_language_server.setup(coq.lsp_ensure_capabilities({
    on_attach = on_attach,
    cmd = {'jdtls'}
}))

--[[
nvim_lsp.efm.setup{
    init_options = { documentFormatting = true },
    settings = {
        rootMakers = {'.git'},
        languages = {
            python = {
                {formatCommand = 'black', formatStdin = true}
            }
        }
    },
    filetypes = { 'python', 'cpp', 'lua' }
}
]]

--[[
nvim_lsp.diagnosticls.setup ({
    on_attach = on_attach,
    filetypes = { "python" },
    init_options = {
        filetypes = {
            python = {"flake8"},
        },
        linters = {
            flake8 = {
                debounce = 100,
                sourceName = "flake8",
                command = "flake8",
                args = {
                    "--format",
                    "%(row)d:%(col)d:%(code)s:%(code)s: %(text)s",
                    "%filepath",
                },
                formatPattern = {
                    "^(\\d+):(\\d+):(\\w+):(\\w).+: (.*)$",
                    {
                        line = 1,
                        column = 2,
                        message = {"[", 3, "] ", 5},
                        security = 4
                    }
                },
                securities = {
                    E = "error",
                    W = "warning",
                    F = "info",
                    B = "hint",
                },
            },
        },
        formatters = {
            black = {
                command = 'black',
                rootPatterns = { 'requirements.txt' },
                args = { '%filename' }
            }
        },
        formatFiletypes = {
            python = 'black'
        }
    }
})
]]

-- icon
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    -- This sets the spacing and the prefix, obviously.
    virtual_text = {
      spacing = 4,
      prefix = ''
    }
  }
)
