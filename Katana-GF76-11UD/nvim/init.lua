require("init_setup")
require("lazy_setup")
require("nvim_tree_setup")
require("colors_setup")
require("lsp_setup")
require("treesitter_setup")
require("telescope_setup")
require("keymap_setup")
require("nvim-ts-autotag").setup({})
require("nvim-lightbulb").setup({ autocmd = { enabled = true } })
require("Comment").setup({ comment_empty = false })
require("lualine").setup({})
require("autoclose").setup()
require("bufferline").setup({
	options = {
		indicator = {
			style = "none",
		},
	},
})
require("gitsigns").setup({})
require("scrollbar").setup({ handlers = { gitsigns = true } })
require("indent_blankline").setup({})

vim.cmd([[
    augroup cmdline
    autocmd!
    autocmd CmdlineLeave : echo ''
    autocmd VimLeave * set guicursor=a:ver25
    augroup end
]])

-- vim.cmd([[
--     augroup diagnostic
--     autocmd!
--     autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false, scope="cursor"})
--     augroup end
-- ]])

vim.diagnostic.config({
	virtual_text = false,
	float = { border = "rounded" },
})

vim.cmd([[
    augroup fmt
    autocmd!
    autocmd BufWritePre * Neoformat
    augroup end
]])

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
