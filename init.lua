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

-- Leader key ( space )
vim.g.mapleader = " "

require("core.options").config()
require("core.mappings").config()
require("core.autocommands").config()
require("lazy").setup({
	"michaeljsmith/vim-indent-object",
	{
		"windwp/nvim-autopairs",
		config = true,
	},
	{ import = "plugins" },
})
