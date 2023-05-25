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
	{ "m4xshen/autoclose.nvim" },
	{ "windwp/nvim-ts-autotag" },
	{ "kosayoda/nvim-lightbulb" },
	{ "akinsho/bufferline.nvim" },
	{ "lewis6991/gitsigns.nvim" },
	{ "nvim-treesitter/nvim-treesitter", ["do"] = ":TSUpdate" },
	{ "numToStr/Comment.nvim" },
	{ "kyazdani42/nvim-web-devicons" },
	{ "nvim-tree/nvim-tree.lua" },
	{ "nvim-lualine/lualine.nvim" },
	{ "nvim-lua/plenary.nvim" },
	{ "nvim-telescope/telescope.nvim" },
	{ "sbdchd/neoformat" },
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
			{ "williamboman/mason-lspconfig.nvim" }, -- Optional
			{ "hrsh7th/nvim-cmp" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "L3MON4D3/LuaSnip" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "rafamadriz/friendly-snippets" },
		},
	},
})

vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.number = true
vim.opt.scrolloff = 1
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.cindent = true
vim.opt.showmode = true
vim.opt.showcmd = true
vim.opt.showmatch = true
vim.opt.incsearch = true
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.termguicolors = true
vim.opt.linespace = 0
vim.opt.pumheight = 20
vim.wo.number = true
vim.wo.signcolumn = "yes"
vim.o.wrap = false
vim.o.updatetime = 100
vim.o.hlsearch = true
vim.o.mouse = "a"
vim.o.clipboard = "unnamedplus"
vim.o.breakindent = false
vim.o.undofile = false
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.background = "dark"
vim.o.guifont = "JetBrainsMono Nerd Font:h9"
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.neoformat_try_node_exe = 1
vim.g.neovide_refresh_rate = 144
vim.g.neovide_confirm_quit = false
vim.g.neovide_cursor_trail_size = 0
vim.g.neovide_padding_top = 4
vim.g.neovide_padding_bottom = 4
vim.g.neovide_padding_right = 4
vim.g.neovide_padding_left = 4
vim.g.neovide_scale_factor = 1
vim.g.neovide_cursor_animate_command_line = false
vim.g.neovide_cursor_animate_in_insert_mode = false
vim.opt.termguicolors = true

local lsp = require("lsp-zero").preset({})

lsp.on_attach(function(client, bufnr)
	lsp.default_keymaps({ buffer = bufnr })
end)

require("lspconfig").lua_ls.setup(lsp.nvim_lua_ls())

lsp.setup()

local cmp = require("cmp")
local cmp_select_opts = { behavior = cmp.SelectBehavior.Select }
local lspkind = require("lspkind")

require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
	sources = {
		{ name = "path" },
		{ name = "nvim_lsp" },
		{ name = "luasnip", option = { show_autosnippets = false } },
		{ name = "buffer" },
	},
	mapping = {
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<C-e>"] = cmp.mapping.abort(),
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
		["<S-Tab>"] = cmp.mapping.select_prev_item(cmp_select_opts),
		["<Tab>"] = cmp.mapping.select_next_item(cmp_select_opts),
		["<C-p>"] = cmp.mapping(function()
			if cmp.visible() then
				cmp.select_prev_item(cmp_select_opts)
			else
				cmp.complete()
			end
		end),
		["<C-n>"] = cmp.mapping(function()
			if cmp.visible() then
				cmp.select_next_item(cmp_select_opts)
			else
				cmp.complete()
			end
		end),
	},
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	formatting = { format = lspkind.cmp_format({}) },
})

require("ayu").colorscheme()
require("bufferline").setup({ options = { separator_style = "slant" } })
require("lualine").setup({ options = { theme = "ayu" } })
require("Comment").setup({ comment_empty = false })
require("gitsigns").setup({})
require("nvim-ts-autotag").setup({})
require("nvim-lightbulb").setup({ autocmd = { enabled = true } })

require("nvim-treesitter.configs").setup({
	auto_install = true,
	highlight = { enable = true },
	indent = { enable = true },
	additional_vim_regex_highlighting = false,
})

require("indent_blankline").setup({})

require("nvim-tree").setup({
	reload_on_bufenter = true,
	sync_root_with_cwd = true,
	renderer = { root_folder_label = false },
})

require("telescope").setup({
	extensions = { file_browser = { hijack_netrw = true } },
	defaults = { file_ignore_patterns = { "node%_modules/.*" } },
})

require("autoclose").setup()
vim.cmd([[
    augroup fmt
    autocmd!
    autocmd BufWritePre * Neoformat
    augroup end
]])

vim.cmd([[
    augroup cmdline
    autocmd!
    autocmd CmdlineLeave : echo ''
    autocmd VimLeave * set guicursor=a:ver25
    augroup end
]])

vim.cmd([[
    augroup diagnostic
    autocmd!
    autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false, scope="cursor"})
    augroup end
]])

vim.diagnostic.config({
	virtual_text = false,
	float = { border = "rounded" },
})

local signs = {
	Error = "",
	Warning = "",
	Hint = "",
	Information = "",
}

for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

require("scrollbar").setup({
	handlers = {
		gitsigns = true,
	},
})

vim.keymap.set("n", "<C-P>", ":Telescope find_files hidden=true<CR>", { noremap = true })
vim.keymap.set("n", "<C-F>", ":Telescope live_grep hidden=true<CR>", { noremap = true })
vim.keymap.set("n", "<C-N>", ":NvimTreeFocus <CR>", { noremap = true })
vim.keymap.set("n", "<S-N>", ":NvimTreeClose <CR>", { noremap = true })
vim.keymap.set("n", "<ESC>", "<cmd>nohlsearch<CR>", { silent = true })
vim.keymap.set("i", "<S-Tab>", "<C-d>", { silent = true })
vim.keymap.set({ "n", "v" }, "<C-Space>", vim.lsp.buf.code_action, {})
vim.keymap.set("n", "<C-W>", "<cmd>bdelete<cr>", { noremap = true })
vim.keymap.set("n", "<A-Tab>", "<cmd>bnext<cr>", { noremap = true })
vim.keymap.set("n", "<S-Tab>", "<cmd>bprevious<cr>", { noremap = true })

require("indent_blankline").setup({
	-- for example, context is off by default, use this to turn it on
	show_current_context = true,
	show_current_context_start = true,
})

-- vim.cmd([[highlight IndentBlanklineContextChar guifg=#e6b450 ]])
