local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
vim.opt.guicursor = "v-c:block,n-i-ci-ve:ver25,r-cr:hor20,o:hor50"

vim.filetype.add({
	pattern = {
		[".*%.blade%.php"] = "blade",
	},
})

-- init.lua

-- Set leader key
vim.g.mapleader = " "

-- Core configs (options, mappings, autocommands)
require("core.options").config()
require("core.mappings").config()
require("core.autocommands").config()

-- Lazy.nvim setup
require("lazy").setup({
	-- Example single plugins
	"michaeljsmith/vim-indent-object",
	{
		"windwp/nvim-autopairs",
		config = true,
	},

	-- Import your plugin specs folder
	{ import = "plugins" }, -- this will load plugins/*.lua

	-- Our full dev environment for 2025 Vue/Next.js
	{ import = "plugins.dev_env" }, -- loads plugins/dev_env.lua
})
