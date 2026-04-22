-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- vim.keymap.set("n", "<leader>fC", function()
--  require("neo-tree.command").execute({ action = "focus", dir = vim.fn.stdpath("config") })
-- end, { desc = "Open Neovim config" })

vim.keymap.set("i", "<C-h>", "<C-w>", { noremap = true, silent = true })
vim.keymap.set("i", "<C-BS>", "<C-w>", { noremap = true, silent = true })

vim.keymap.set("n", "X", "<cmd>bdelete<cr>", { desc = "Close buffer" })
vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, { desc = "Rename symbol" })
