
return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot", -- lazy load on :Copilot or when another plugin requires it
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false }, -- handled by copilot-cmp
        panel = { enabled = false },
        filetypes = {
          markdown = true,
          help = true,
          -- disable for specific filetypes if needed
        },
      })
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "copilot.lua" },
    config = function()
      require("copilot_cmp").setup()
    end,
  },
}
