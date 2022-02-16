local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

-- Install your plugins here
return packer.startup(function(use)
	-- Core stuff
	use("wbthomason/packer.nvim") -- Have packer manage itself
	use("nvim-lua/popup.nvim") -- An implementation of the Popup API from vim in Neovim
	use("nvim-lua/plenary.nvim") -- Useful lua functions used ny lots of plugins

	-- Colorschemes
	use "lunarvim/colorschemes" -- A bunch of colorschemes you can try out
	use("sainnhe/edge")
    use("folke/tokyonight.nvim")
    use("mangeshrex/uwu.vim")
    use("rafamadriz/neon")
    use("marko-cerovac/material.nvim")
    use("nekonako/xresources-nvim")
    use("shaunsingh/nord.nvim")
    use("navarasu/onedark.nvim")
    use("dracula/vim")
    use("nxvu699134/vn-night.nvim")

	-- Completion
	use("hrsh7th/nvim-cmp") -- The completion plugin
	use("hrsh7th/cmp-buffer") -- buffer completions
	use("hrsh7th/cmp-path") -- path completions
	use("hrsh7th/cmp-cmdline") -- cmdline completions
	use("saadparwaiz1/cmp_luasnip") -- snippet completions
    use("hrsh7th/cmp-nvim-lsp")
    use("hrsh7th/cmp-nvim-lua")
	-- snippets
	use("L3MON4D3/LuaSnip") -- snippet engine
	use("rafamadriz/friendly-snippets") -- a bunch of snippets to use

	-- LSP
	use("neovim/nvim-lspconfig") -- enable LSP
	use("williamboman/nvim-lsp-installer") -- simple to use language server installer
	use("tamago324/nlsp-settings.nvim") -- language server settings defined in json for
	use("antoinemadec/FixCursorHold.nvim") -- This is needed to fix lsp doc highlight
    use("mfussenegger/nvim-jdtls")
    use("jose-elias-alvarez/null-ls.nvim") -- Null-LS

	-- Telescope
	use("nvim-telescope/telescope.nvim")
    use("nvim-telescope/telescope-media-files.nvim")

	-- Treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	})
    use("p00f/nvim-ts-rainbow")

    -- Autopairs
    use("windwp/nvim-autopairs")

    -- Debugging
    use("mfussenegger/nvim-dap")

    -- Comments
    use("numToStr/Comment.nvim")
    use("JoosepAlviste/nvim-ts-context-commentstring")

	-- Git
	use("lewis6991/gitsigns.nvim")

    -- NvimTree
    use("kyazdani42/nvim-tree.lua")
    use("kyazdani42/nvim-web-devicons")

    -- Bufferline
    use("akinsho/bufferline.nvim")

    -- Lualine
    use("nvim-lualine/lualine.nvim")

    -- Toggleterm
    use("akinsho/toggleterm.nvim")

    -- Impatient
    use("lewis6991/impatient.nvim")

    -- Indent line
    use("lukas-reineke/indent-blankline.nvim")

    -- alpha
    use("goolord/alpha-nvim")
    use("antoinemadec/FixCursorHold.nvim") -- This is needed to fix lsp doc highlight

    -- whichkey
    use("folke/which-key.nvim")

    -- Colorizer
    use("norcalli/nvim-colorizer.lua")

    -- Tetris
    use("alec-gibson/nvim-tetris")

    -- Debugging
    use("mfussenegger/nvim-dap")
    use("rcarriga/nvim-dap-ui")

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
