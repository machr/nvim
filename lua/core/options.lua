-- M is Module
local M = {}

M.config = function()
	-- General UI
	vim.opt.showmode = false
	vim.opt.cursorline = true
	vim.opt.number = true
	vim.opt.relativenumber = true
	vim.opt.signcolumn = "yes"
	vim.opt.termguicolors = true
	vim.opt.mouse = "nvi"
	vim.opt.scrolloff = 10
	vim.opt.updatetime = 100
	vim.opt.conceallevel = 0

	-- Clipboard
	vim.opt.clipboard = "unnamedplus"

	-- Search
	vim.opt.ignorecase = true
	vim.opt.smartcase = true
	vim.opt.infercase = true

	-- Indentation
	vim.opt.autoindent = true
	vim.opt.smartindent = true
	vim.opt.expandtab = true
	vim.opt.tabstop = 2
	vim.opt.shiftwidth = 2
	vim.opt.softtabstop = 2

	-- Line wrapping
	vim.opt.breakindent = true
	vim.opt.breakindentopt = "shift:2"

	-- Folding
	vim.opt.foldenable = false
	vim.opt.foldmethod = "indent"
	vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

	-- Timings
	vim.opt.timeoutlen = 300
	vim.opt.ttimeoutlen = 10

	-- Backspace behavior
	vim.opt.backspace = { "start", "eol", "indent" }

	-- Filetype settings
	vim.g.do_filetype_lua = 1
	vim.filetype.add({
		pattern = {
			[".*%.blade%.php"] = "blade",
		},
	})

	-- Theme (optional - set explicitly or remove)
	-- vim.opt.background = "dark" -- or "light"
end

return M
