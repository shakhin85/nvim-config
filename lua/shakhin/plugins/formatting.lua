return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    -- Helper function to find tool in .venv first, then fall back to Mason
    local function get_tool_cmd(name)
      local cwd = vim.fn.getcwd()
      local venv_tool

      -- Check .venv first
      if vim.fn.has("win32") == 1 then
        venv_tool = cwd .. "\\.venv\\Scripts\\" .. name .. ".exe"
      else
        venv_tool = cwd .. "/.venv/bin/" .. name
      end

      if vim.fn.executable(venv_tool) == 1 then
        return venv_tool
      end

      -- Fall back to Mason
      local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
      if vim.fn.has("win32") == 1 then
        return mason_bin .. "\\" .. name .. ".cmd"
      else
        return mason_bin .. "/" .. name
      end
    end

    -- Add Mason bin directory to PATH for formatters
    local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
    if vim.fn.isdirectory(mason_bin) == 1 then
      vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
    end

    conform.setup({
      formatters = {
        -- Ruff formatters
        ruff_fix = {
          command = get_tool_cmd("ruff"),
          args = {
            "check",
            "--fix",
            "--select", "F401,I001,UP",  -- F401: unused imports, I001: isort, UP: pyupgrade
            "--stdin-filename", "$FILENAME",
            "-",
          },
        },
        ruff_format = {
          command = get_tool_cmd("ruff"),
        },
        ruff_organize_imports = {
          command = get_tool_cmd("ruff"),
        },
        -- Black formatter
        black = {
          command = get_tool_cmd("black"),
        },
        -- Autopep8 formatter
        autopep8 = {
          command = get_tool_cmd("autopep8"),
        },
        -- SQL formatter
        sqlfluff = {
          command = vim.fn.stdpath("data") .. "/mason/bin/sqlfluff.cmd",
          args = { "format", "--dialect", "tsql", "$FILENAME" },
          stdin = false,
        },
      },
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
        python = { "ruff_fix", "ruff_organize_imports", "ruff_format" },
        sql = { "sqlfluff" },
      },
      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 10000,
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>mp", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 10000,
      })
    end, { desc = "Format file or range (in visual mode)" })

    -- Python formatter keymaps (only active in Python files)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "python",
      callback = function(args)
        local bufnr = args.buf

        -- Ruff formatting keymap
        vim.keymap.set({ "n", "v" }, "<leader>mr", function()
          print("Formatting with ruff...")
          conform.format({
            formatters = { "ruff_format" },
            lsp_fallback = false,
            async = false,
            timeout_ms = 1000,
          })
        end, { desc = "Format Python file with ruff", buffer = bufnr })

        -- Black formatting keymap
        vim.keymap.set({ "n", "v" }, "<leader>mb", function()
          print("Formatting with black...")
          conform.format({
            formatters = { "black" },
            lsp_fallback = false,
            async = false,
            timeout_ms = 1000,
          })
        end, { desc = "Format Python file with black", buffer = bufnr })

        -- Autopep8 formatting keymap
        vim.keymap.set({ "n", "v" }, "<leader>ma", function()
          print("Formatting with autopep8...")
          conform.format({
            formatters = { "autopep8" },
            lsp_fallback = false,
            async = false,
            timeout_ms = 1000,
          })
        end, { desc = "Format Python file with autopep8", buffer = bufnr })
      end,
    })

    -- Show formatter info
    vim.api.nvim_create_user_command("FormatInfo", function()
      local filetype = vim.bo.filetype
      local formatters = conform.formatters_by_ft[filetype] or {}
      if #formatters == 0 then
        print("No formatters configured for filetype: " .. filetype)
      else
        print("Formatters for " .. filetype .. ":")
        for _, formatter_name in ipairs(formatters) do
          local formatter = conform.get_formatter_info(formatter_name)
          if formatter and formatter.command then
            print("  - " .. formatter_name .. ": " .. formatter.command)
          else
            print("  - " .. formatter_name .. ": (not configured)")
          end
        end
      end
    end, { desc = "Show configured formatters for current filetype" })
  end,
}
