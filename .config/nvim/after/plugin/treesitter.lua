require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    disable = {},
  },
  indent = {
    enable = false,
    disable = {},
  },
  ensure_installed = {
      "java",
      "python",
      "c",
      "cpp",
      "bash",
      "lua",
  },
}
