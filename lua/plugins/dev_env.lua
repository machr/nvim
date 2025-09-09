return {

	-- === Neo-tree ===
	{
		"nvim-neo-tree/neo-tree.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
			"s1n7ax/nvim-window-picker",
		},
		config = function()
			require("window-picker").setup()

			require("neo-tree").setup({
				open_files_in_last_window = true, -- ensures files open in main editing area
				default_component_configs = {
					indent = { with_expanders = true },
				},
				window = {
					position = "left",
					mapping_options = { noremap = true, nowait = true },
					mappings = {
						["<CR>"] = "open", -- enter opens file in main window
						["o"] = "open_with_window_picker",
						["x"] = "close_node",
						["X"] = "cut_to_clipboard",
						["W"] = "close_all_nodes",
						["h"] = "toggle_hidden",
						["<leader>\\"] = "open_vsplit",
						["<leader>-"] = "open_split",
					},
				},
				filesystem = {
					follow_current_file = { enable = true },
					filtered_items = {
						hide_dotfiles = false,
						hide_gitignored = true,
						hide_by_name = { ".github", "node_modules", ".gitignore", "package-lock.json" },
						never_show = { ".git" },
					},
				},
			})

			local opts = { noremap = true, silent = true }

			-- Reveal current file in sidebar without stealing focus
			vim.keymap.set("n", "<leader>e", function()
				local manager = require("neo-tree.sources.manager")
				local state = manager.get_state("filesystem")
				if not state or not state.winid then
					-- open sidebar if closed
					vim.cmd("Neotree reveal reveal_force_cwd")
				else
					-- reveal current file but keep focus in main window
					require("neo-tree.command").execute({ action = "reveal", focus = false })
				end
			end, opts)

			-- Toggle sidebar
			vim.keymap.set("n", "<leader>b", function()
				local manager = require("neo-tree.sources.manager")
				local state = manager.get_state("filesystem")
				if state and state.winid then
					manager.close("filesystem")
				else
					vim.cmd("Neotree reveal reveal_force_cwd")
				end
			end, opts)
		end,
	},
	-- === Which-key for leader hints ===
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			require("which-key").setup({})
		end,
	},

	-- === LSP + typescript.nvim ===
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		dependencies = {
			"jose-elias-alvarez/typescript.nvim",
			"nvimtools/none-ls.nvim",
			"nvimtools/none-ls-extras.nvim",
		},
		config = function()
			local lspconfig = require("lspconfig")
			local typescript = require("typescript")
			local null_ls = require("null-ls")

			-- Diagnostics config
			vim.diagnostic.config({
				virtual_text = true,
				signs = true,
				underline = true,
				update_in_insert = false,
			})

			-- Volar for Vue
			lspconfig.volar.setup({
				filetypes = { "vue" },
				init_options = {
					typescript = { tsdk = "/usr/local/lib/node_modules/typescript/lib" },
				},
			})

			-- TypeScript / Next.js
			typescript.setup({
				server = {
					filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
					root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
					on_attach = function(client, bufnr)
						client.server_capabilities.documentFormattingProvider = false
					end,
				},
			})

			-- none-ls setup
			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.prettier,
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.formatting.sql_formatter,
					null_ls.builtins.diagnostics.eslint_d,
				},
				on_attach = function(client, bufnr)
					local opts = { buffer = bufnr, silent = true }

					-- Manual formatting
					vim.keymap.set("n", ",f", function()
						vim.lsp.buf.format({ async = true })
					end, opts)
					vim.keymap.set("v", ",f", function()
						vim.lsp.buf.format({ async = true })
					end, opts)

					-- Diagnostics float
					vim.keymap.set("n", "<leader>de", vim.diagnostic.open_float, opts)

					-- Auto-format on save
					if client.supports_method("textDocument/formatting") then
						vim.api.nvim_create_autocmd("BufWritePre", {
							buffer = bufnr,
							callback = function()
								vim.lsp.buf.format({ async = false })
							end,
						})
					end
				end,
			})
		end,
	},

	-- === Telescope ===
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope Find Files" })
			vim.keymap.set("n", "<leader>g", builtin.live_grep, { desc = "Telescope Live Grep" })
			vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Telescope Diagnostics" })
		end,
	},
}
