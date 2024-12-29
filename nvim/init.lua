require("config.lazy")

-- Execute complete written buffer which is currently open.
vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>")
-- Execute current line.
vim.keymap.set("n", "<space>x", ":.lua<CR>")
-- Execute current selection.
vim.keymap.set("v", "<space>x", ":lua<CR>")

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Show line numbers.
vim.opt.number = true
-- Allow for copying to and from clipboard
vim.opt.clipboard = "unnamedplus"
