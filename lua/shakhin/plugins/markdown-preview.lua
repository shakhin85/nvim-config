return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  ft = { "markdown" },
  build = function()
    -- Detect OS and use appropriate build command
    local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1

    if is_windows then
      -- Windows: use cmd.exe to run npm install
      vim.fn.system("cd app && npm install")
    else
      -- Linux/Unix: use the standard install function
      vim.fn["mkdp#util#install"]()
    end
  end,
  config = function()
    -- Configuration
    vim.g.mkdp_auto_start = 0 -- Don't auto-start preview
    vim.g.mkdp_auto_close = 1 -- Auto-close preview when changing buffers
    vim.g.mkdp_refresh_slow = 0 -- Refresh on save or leaving insert mode
    vim.g.mkdp_browser = "" -- Use system default browser
    vim.g.mkdp_echo_preview_url = 1 -- Echo preview URL in command line
    vim.g.mkdp_preview_options = {
      mkit = {},
      katex = {},
      uml = {},
      maid = {},
      disable_sync_scroll = 0, -- Enable sync scroll
      sync_scroll_type = "middle",
      hide_yaml_meta = 1,
      sequence_diagrams = {},
      flowchart_diagrams = {},
      content_editable = false,
      disable_filename = 0,
      toc = {},
    }

    -- Keymaps that integrate with telekasten prefix
    local keymap = vim.keymap.set

    -- Toggle markdown preview
    keymap("n", "<leader>zv", "<cmd>MarkdownPreviewToggle<cr>", { desc = "Toggle markdown preview" })

    -- Alternative keymaps
    keymap("n", "<leader>zvp", "<cmd>MarkdownPreview<cr>", { desc = "Start markdown preview" })
    keymap("n", "<leader>zvs", "<cmd>MarkdownPreviewStop<cr>", { desc = "Stop markdown preview" })
  end,
}
