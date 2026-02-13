M = {}

M.config = function()
  vim.cmd([[
    augroup _nvim_telescope_fold_workaround
      autocmd!
      autocmd BufRead * autocmd BufWinEnter * ++once normal! zx zR
    augroup END

    augroup _help
      autocmd!
      autocmd BufEnter * if &buftype == 'help' && winwidth(0) == &columns | wincmd L | endif
    augroup END

    augroup _init_on_file_open
      autocmd!
      " Change the working directory on initial open, handling both files and directories
      autocmd VimEnter * if argc() > 0 | let dir = argv(0) | if dir =~ '^oil://' | let dir = substitute(dir, '^oil://', '', '') | endif | if isdirectory(dir) | exe 'lcd ' . dir | else | exe 'lcd ' . expand('%:p:h') | endif | endif
    augroup END

  ]])

  local go_group = vim.api.nvim_create_augroup("_go", { clear = true })
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = go_group,
    pattern = "*.go",
    callback = function(args)
      local ok, conform = pcall(require, "conform")
      if ok then
        conform.format({ bufnr = args.buf, async = false, lsp_fallback = true })
        return
      end

      local clients = vim.lsp.get_active_clients({ bufnr = args.buf })
      if #clients > 0 then
        vim.lsp.buf.format({ bufnr = args.buf, async = false })
      end
    end,
  })
  -- Notes: _help
  -- When opening the help buffer, upon open, set the buffer to the right most vertical split.
  -- The winwidth() check is to determine whether a help buffer is already open, if so, do not issue the wincmd.
  -- The reason for this is because telescope.nvim issues a close window command when closing the prompt buffer and when
  -- the BufEnter event is triggered which then tries to issue the wincmd, you will get an error stating that a split
  -- cannot be issued while a window is closing.
  --
  -- Notes: _init_on_file_open
  -- When opening a file or directory directly with neovim, I want the current working directory to be the directory
  -- containing the file OR the directory itself if it is passed in instead of a file.
end

return M
