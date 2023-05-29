local lsp = require("lsp-zero").preset({})

lsp.preset("recommended")

lsp.ensure_installed({
	"tsserver",
	"eslint",
})

lsp.on_attach(function(client, bufnr)
	client.server_capabilities.semanticTokensProvider = nil
	lsp.default_keymaps({ buffer = bufnr })
end)

require("lspconfig").tsserver.setup({})

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

lsp.setup({})
