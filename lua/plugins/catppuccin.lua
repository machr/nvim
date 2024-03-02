return {
	-- {
  -- "catppuccin/nvim",
  -- name = "catppuccin",
  --priority = 1000,
  --  config = function()
    -- require("catppuccin").setup()

    -- setup must be called before loading
    -- vim.cmd.colorscheme "catppuccin"
  -- end,
  -- }

    "bluz71/vim-nightfly-guicolors",
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- load the colorscheme here
      vim.cmd([[colorscheme nightfly]])
    end,

}
