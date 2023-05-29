vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

require("nvim-tree").setup({
	reload_on_bufenter = true,
	sync_root_with_cwd = true,
	sort_by = "case_sensitive",
	view = {
		width = 30,
		side = "right",
	},
	renderer = {
		group_empty = true,
		root_folder_label = false,
	},
	filters = {
		dotfiles = false,
	},
})
