return {
  "ThePrimeagen/refactoring.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("refactoring").setup({
      prompt_func_return_type = {
        go = false,
        java = false,
        cpp = false,
        c = false,
        h = false,
        hpp = false,
        cxx = false,
      },
      prompt_func_param_type = {
        go = false,
        java = false,
        cpp = false,
        c = false,
        h = false,
        hpp = false,
        cxx = false,
      },
      printf_statements = {},
      print_var_statements = {},
    })

    -- Telescope integration
    require("telescope").load_extension("refactoring")

    -- Keymaps for refactoring
    vim.keymap.set("x", "<leader>re", function() require("refactoring").refactor("Extract Function") end, { desc = "Extract Function" })
    vim.keymap.set("x", "<leader>rf", function() require("refactoring").refactor("Extract Function To File") end, { desc = "Extract Function To File" })
    vim.keymap.set("x", "<leader>rv", function() require("refactoring").refactor("Extract Variable") end, { desc = "Extract Variable" })
    vim.keymap.set("n", "<leader>rI", function() require("refactoring").refactor("Inline Function") end, { desc = "Inline Function" })
    vim.keymap.set({ "n", "x" }, "<leader>ri", function() require("refactoring").refactor("Inline Variable") end, { desc = "Inline Variable" })

    -- Extract block doesn't need visual mode
    vim.keymap.set("n", "<leader>rb", function() require("refactoring").refactor("Extract Block") end, { desc = "Extract Block" })
    vim.keymap.set("n", "<leader>rbf", function() require("refactoring").refactor("Extract Block To File") end, { desc = "Extract Block To File" })

    -- Debug helpers
    vim.keymap.set("n", "<leader>rp", function() require("refactoring").debug.printf({below = false}) end, { desc = "Debug Print" })
    vim.keymap.set("n", "<leader>rv", function() require("refactoring").debug.print_var({normal = true}) end, { desc = "Debug Print Var" })
    vim.keymap.set("x", "<leader>rv", function() require("refactoring").debug.print_var({}) end, { desc = "Debug Print Var" })
    vim.keymap.set("n", "<leader>rc", function() require("refactoring").debug.cleanup({}) end, { desc = "Debug Cleanup" })

    -- Telescope refactoring menu
    vim.keymap.set({ "n", "x" }, "<leader>rr", function() require("telescope").extensions.refactoring.refactors() end, { desc = "Refactoring menu" })
  end,
}