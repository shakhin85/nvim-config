return {
  "ellisonleao/glow.nvim",
  cmd = "Glow",
  ft = { "markdown" },
  config = function()
    require("glow").setup({
      -- glow binary path (optional, will use system glow if available)
      glow_path = "", -- leave empty to use system glow

      -- Install glow automatically if not found (Linux/macOS only)
      install_path = "~/.local/bin",

      -- Border style for glow window: 'single', 'double', 'rounded', 'solid', 'shadow'
      border = "rounded",

      -- Style to use: 'dark', 'light', or custom path to JSON style file
      style = "dark",

      -- Pager to use when preview is larger than window
      pager = false,

      -- Width of the glow window (percentage or absolute)
      width = 120,

      -- Height of the glow window (percentage or absolute)
      height = 100,

      -- Width ratio of the glow window to the editor
      width_ratio = 0.8,

      -- Height ratio of the glow window to the editor
      height_ratio = 0.8,
    })

    -- Keymaps that work alongside markdown-preview
    local keymap = vim.keymap.set

    -- Glow preview (terminal-based, works in headless environments)
    keymap("n", "<leader>zg", "<cmd>Glow<cr>", { desc = "Glow preview (terminal)" })

    -- Alternative: use <leader>zvg for consistency with markdown-preview keybindings
    keymap("n", "<leader>zvg", "<cmd>Glow<cr>", { desc = "Glow preview (terminal)" })
  end,
}
