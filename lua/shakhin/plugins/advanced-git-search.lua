return {
  "aaronhallaert/advanced-git-search.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "tpope/vim-fugitive",
    "tpope/vim-rhubarb",
    "ibhagwan/fzf-lua",
  },
  config = function()
    require("advanced_git_search.fzf").setup({
      -- fugitive or diffview
      diff_plugin = "diffview",
      -- customize git in previewer
      -- e.g. flags such as { "--no-pager" }, or { "-c", "delta.side-by-side=false" }
      git_flags = {},
      -- customize git diff in previewer
      -- e.g. flags such as { "--raw" }
      git_diff_flags = {},
      -- Show builtin git pickers when executing "show_custom_functions" or :AdvancedGitSearch
      show_builtin_git_pickers = false,
    })

    -- Telescope integration
    require("telescope").load_extension("advanced_git_search")

    -- Keymaps
    vim.keymap.set("n", "<leader>gs", function()
      require("telescope").extensions.advanced_git_search.advanced_git_search()
    end, { desc = "Advanced git search" })

    vim.keymap.set("n", "<leader>gS", function()
      require("telescope").extensions.advanced_git_search.search_log_content()
    end, { desc = "Search git log content" })

    vim.keymap.set("n", "<leader>gl", function()
      require("telescope").extensions.advanced_git_search.diff_commit_line()
    end, { desc = "Search commits affecting current line" })

    vim.keymap.set("n", "<leader>gL", function()
      require("telescope").extensions.advanced_git_search.diff_commit_file()
    end, { desc = "Search commits affecting current file" })

    vim.keymap.set("v", "<leader>gl", function()
      require("telescope").extensions.advanced_git_search.diff_commit_line()
    end, { desc = "Search commits affecting selection" })
  end,
}