return {
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
				default_component_configs = {
					indent = { with_expanders = true },
				},
				window = {
					position = "left",
					mapping_options = { noremap = true, nowait = true },
					mappings = {
						["o"] = "open_with_window_picker",
						["x"] = "close_node",
						["X"] = "cut_to_clipboard",
						["W"] = "close_all_nodes",
						["h"] = "toggle_hidden",
						["<leader>\\"] = "open_vsplit",
						["<leader>-"] = "open_split",
						["<leader>r"] = "noop", -- disable rename to avoid conflict
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
					event_handlers = {
						{
							event = "file_opened",
							handler = function(_)
								-- auto-close Neo-tree after opening a file
								require("neo-tree").close_all()
							end,
						},
					},
				},
			})

			-- === Keymaps ===
			local opts = { noremap = true, silent = true }

			-- Reveal current file (like ⇧⌘E)
			vim.keymap.set(
				"n",
				"<leader>e",
				":Neotree reveal reveal_force_cwd<CR>",
				vim.tbl_extend("force", opts, { desc = "Reveal current file in Neo-tree" })
			)

			-- Toggle Neo-tree open/close (like ⌘B)
			vim.keymap.set("n", "<leader>b", function()
				local manager = require("neo-tree.sources.manager")
				local state = manager.get_state("filesystem")
				if state and state.winid then
					manager.close("filesystem")
				else
					vim.cmd("Neotree reveal reveal_force_cwd")
				end
			end, vim.tbl_extend("force", opts, { desc = "Toggle Neo-tree" }))
		end,
	},
}
