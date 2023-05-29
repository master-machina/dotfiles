local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
	print("Installing lazy.nvim....")
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
	print("Done.")
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{ "VidocqH/lsp-lens.nvim" },
	{ "mfussenegger/nvim-jdtls" },
	{ "nvim-tree/nvim-tree.lua" },
	{ "sbdchd/neoformat" },
	{ "m4xshen/autoclose.nvim" },
	{ "windwp/nvim-ts-autotag" },
	{ "kosayoda/nvim-lightbulb" },
	{ "akinsho/bufferline.nvim" },
	{ "lewis6991/gitsigns.nvim" },
	{ "nvim-treesitter/nvim-treesitter", ["do"] = ":TSUpdate" },
	{ "numToStr/Comment.nvim" },
	{ "kyazdani42/nvim-web-devicons" },
	{ "nvim-lualine/lualine.nvim" },
	{ "nvim-lua/plenary.nvim" },
	{ "nvim-telescope/telescope.nvim" },
	{ "Shatur/neovim-ayu" },
	{ "petertriho/nvim-scrollbar" },
	{ "onsails/lspkind.nvim" },
	{ "lukas-reineke/indent-blankline.nvim" },
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v2.x",
		dependencies = {
			{ "neovim/nvim-lspconfig" },
			{
				"williamboman/mason.nvim",
				build = function()
					pcall(vim.cmd, "MasonUpdate")
				end,
			},
			{ "williamboman/mason-lspconfig.nvim" },
			{ "hrsh7th/nvim-cmp" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "L3MON4D3/LuaSnip" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "rafamadriz/friendly-snippets" },
		},
	},
})
