vim.g.mapleader = " "
vim.keymap.set("n", "<leader>n", vim.cmd.NvimTreeFocus)
vim.keymap.set("n", "<leader>p", ":Telescope find_files hidden=true<CR>", { noremap = true })
vim.keymap.set("n", "<leader>f", ":Telescope live_grep hidden=true<CR>", { noremap = true })
vim.keymap.set("n", "<ESC>", "<cmd>nohlsearch<CR>", { silent = true })
vim.keymap.set("i", "<S-Tab>", "<C-d>", { silent = true })
vim.keymap.set({ "n", "v" }, "<C-Space>", vim.lsp.buf.code_action, {})
vim.keymap.set("n", "<C-W>", "<cmd>bdelete<cr>", { noremap = true })
vim.keymap.set("n", "<A-Tab>", "<cmd>bnext<cr>", { noremap = true })
vim.keymap.set("n", "<S-Tab>", "<cmd>bprevious<cr>", { noremap = true })