return {
  "FabijanZulj/blame.nvim",
  config = function()
    require("blame").setup({
      date_format = "%m.%d.%Y",
      virtual_style = "right_align",
      max_summary_width = 30,
      colors = nil,
      blame_options = nil,
      merge_consecutive = false,
      mappings = {
        commit_info = "i",
        stack_push = "<TAB>",
        stack_pop = "<BS>",
        show_commit = "<CR>",
        close = { "<esc>", "q" },
      }
    })

    -- Keymaps
    vim.keymap.set("n", "<leader>gb", "<cmd>BlameToggle<cr>", { desc = "Toggle git blame" })
    vim.keymap.set("n", "<leader>gB", "<cmd>BlameToggle window<cr>", { desc = "Toggle git blame window" })
  end,
}