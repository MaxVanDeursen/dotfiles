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

-- Navigate to next and previous option in quicklist.
vim.keymap.set("n", "<M-j>", "<cmd>cnext<CR>")
vim.keymap.set("n", "<M-k>", "<cmd>cprev<CR>")

vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("custom-term-open", { clear = true }),
  callback = function()
  end
})

-- Create small terminal within NeoVim.
vim.keymap.set("n", "<space>st", function()
  vim.cmd.vnew()
  vim.cmd.term()
  vim.cmd.wincmd("J")
  vim.api.nvim_win_set_height(0, 10)
end)
-- Remap escape to go to normal mode
vim.cmd("tnoremap <Esc> <C-\\><C-n>")
