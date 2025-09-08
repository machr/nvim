return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				lua = { "stylua" },
				go = { "goimports", "gofmt" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				javascript = { "prettier" },
				typescriptreact = { "prettier" },
				html = { "prettier" },
				css = { "prettier" },
			},
			format_on_save = {
				-- I recommend these options. See :help conform.format for details.
				lsp_format = true,
				timeout_ms = 500,
			},
		})
		vim.keymap.set({ "n", "v" }, ",-f", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 500,
			})
		end)
	end,
}
