return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    -- Add Mason bin directory to PATH for formatters
    local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
    if vim.fn.isdirectory(mason_bin) == 1 then
      vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
    end

    conform.setup({
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        svelte = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        mdx = { "prettier" },
        graphql = { "prettier" },
        liquid = { "prettier" },
        lua = { "stylua" },
        python = { "isort", "black" },
        sql = { "sqlfluff" },
      },
      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 3000,
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>mp", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      })
    end, { desc = "Format file or range (in visual mode)" })

    -- Autopep8 formatting keymap
    vim.keymap.set({ "n", "v" }, "<leader>ma", function()
      print("Formatting with autopep8...")
      conform.format({
        formatters = { "autopep8" },
        lsp_fallback = false,
        async = false,
        timeout_ms = 1000,
      })
    end, { desc = "Format Python file with autopep8" })

    -- Ruff formatting keymap
    vim.keymap.set({ "n", "v" }, "<leader>mr", function()
      print("Formatting with ruff...")
      conform.format({
        formatters = { "ruff_format" },
        lsp_fallback = false,
        async = false,
        timeout_ms = 1000,
      })
    end, { desc = "Format Python file with ruff" })
  end,
}
