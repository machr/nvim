return {
	"windwp/nvim-ts-autotag",
	lazy = true,
	event = "InsertEnter",
	ft = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"handlebars",
		"html",
		"vue",
		"svelte",
		"blade",
		"jsx",
		"tsx",
	},
	config = function()
		require("nvim-ts-autotag").setup({
			opts = {
				enable_close = true,
				enable_rename = true,
				enable_close_on_slash = true,
			},
		})
	end,
}
