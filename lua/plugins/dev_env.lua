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

	-- === LSP + typescript-tools.nvim ===
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		dependencies = {
			"pmizio/typescript-tools.nvim",
			"nvim-lua/plenary.nvim",
			"nvimtools/none-ls.nvim",
			"nvimtools/none-ls-extras.nvim",
		},
		config = function()
			local null_ls = require("null-ls")

			-- Diagnostics config
			vim.diagnostic.config({
				virtual_text = true,
				signs = true,
				underline = true,
				update_in_insert = false,
			})

			-- Volar for Vue (new vim.lsp API)
			vim.lsp.config("volar", {
				filetypes = { "vue" },
				init_options = {
					typescript = { tsdk = "/usr/local/lib/node_modules/typescript/lib" },
				},
			})
			vim.lsp.enable("volar")

			-- TypeScript / Next.js / React (using typescript-tools.nvim)
			require("typescript-tools").setup({
				filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
				settings = {
					tsserver_file_preferences = {
						includeInlayParameterNameHints = "all",
						includeInlayFunctionParameterTypeHints = true,
						includeInlayVariableTypeHints = true,
						includeInlayPropertyDeclarationTypeHints = true,
					},
					complete_function_calls = true,
				},
				on_attach = function(client, bufnr)
					client.server_capabilities.documentFormattingProvider = false
					-- Keymaps for TypeScript specific actions
					local opts = { buffer = bufnr, silent = true }
					vim.keymap.set("n", "<leader>oi", ":TSToolsOrganizeImports<CR>", opts)
					vim.keymap.set("n", "<leader>ru", ":TSToolsRemoveUnused<CR>", opts)
					vim.keymap.set("n", "<leader>am", ":TSToolsAddMissingImports<CR>", opts)
				end,
			})

			-- ESLint LSP for Next.js/React linting (new vim.lsp API)
			vim.lsp.config("eslint", {
				filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
				settings = {
					workingDirectories = { mode = "auto" },
				},
				on_attach = function(client, bufnr)
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = bufnr,
						command = "EslintFixAll",
					})
				end,
			})
			vim.lsp.enable("eslint")

			-- Go (gopls) (new vim.lsp API)
			vim.lsp.config("gopls", {
				settings = {
					gopls = {
						gofumpt = true,
						analyses = {
							unusedparams = true,
							unusedwrite = true,
							fieldalignment = true,
						},
						staticcheck = true,
					},
				},
			})
			vim.lsp.enable("gopls")

			-- none-ls setup (only for formatters not handled by conform.nvim)
			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.sql_formatter,
				},
				on_attach = function(client, bufnr)
					local opts = { buffer = bufnr, silent = true }

					-- Manual formatting (for SQL files via none-ls)
					vim.keymap.set("n", ",f", function()
						vim.lsp.buf.format({ async = true })
					end, opts)
					vim.keymap.set("v", ",f", function()
						vim.lsp.buf.format({ async = true })
					end, opts)

					-- Diagnostics float
					vim.keymap.set("n", "<leader>de", vim.diagnostic.open_float, opts)
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
