return {
  "mg979/vim-visual-multi",
  event = "VeryLazy",
  init = function()
    -- Must be set before plugin loads
    vim.g.VM_maps = {
      ["Find Under"] = "<leader>mn",
      ["Find Subword Under"] = "<leader>mn",
      ["Add Cursor Down"] = "<C-Down>",
      ["Add Cursor Up"] = "<C-Up>",
    }
  end,
}