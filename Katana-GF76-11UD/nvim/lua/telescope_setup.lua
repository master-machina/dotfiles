require("telescope").setup({
	extensions = {
		file_browser = {
			hijack_netrw = true,
		},
	},
	defaults = {
		file_ignore_patterns = {
			".git",
			"node%_modules/.*",
			"package-lock.json",
		},
	},
})
