local M = {}

function M.config()
  local set = vim.keymap.set
  local opts = { noremap = true, silent = true }

  ---------------------
  -- window management
  ---------------------
  --  set("n", "<C-h>", "<C-w>h", opts)
  set("n", "<C-j>", "<C-w>j", opts)
  set("n", "<C-k>", "<C-w>k", opts)
  set("n", "<c-l>", "<C-w>l", opts)
  set("n", "<c-h>", "<C-w>h", opts)
  set("n", "<c-n>", "<C-^>", opts)
  set('n', 'L', 'Lzz', opts)
  set('n', 'H', 'Hzz', opts)
  
  set('n', '<leader>q', '<Cmd>q<CR>')
  set('n', '<leader>w', '<Cmd>w<CR>')
end

return M
