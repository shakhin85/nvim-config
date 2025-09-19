return {
  "kdheepak/lazygit.nvim",
  event = "VeryLazy", -- Загружаем плагин при старте
  cmd = {
    "LazyGit",
    "LazyGitConfig", 
    "LazyGitCurrentFile",
    "LazyGitFilter",
    "LazyGitFilterCurrentFile",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    -- Устанавливаем leader key
    vim.g.mapleader = " "
    
    -- Настройки для lazygit
    vim.g.lazygit_floating_window_winblend = 0
    vim.g.lazygit_floating_window_scaling_factor = 0.9
    vim.g.lazygit_floating_window_corner_chars = { '╭', '╮', '╰', '╯' }
    vim.g.lazygit_floating_window_use_plenary = 0
    vim.g.lazygit_use_neovim_remote = 1
    
    -- Задержка для корректной регистрации кеймапов
    vim.defer_fn(function()
      local keymap = vim.keymap.set
      
      -- Основные команды LazyGit
      keymap("n", "<leader>lg", ":LazyGit<CR>", { desc = "Open LazyGit" })
      keymap("n", "<leader>lc", ":LazyGitCurrentFile<CR>", { desc = "LazyGit current file" })
      keymap("n", "<leader>lf", ":LazyGitFilter<CR>", { desc = "LazyGit filter" })
      keymap("n", "<leader>ll", ":LazyGitFilterCurrentFile<CR>", { desc = "LazyGit filter current file" })
      keymap("n", "<leader>gs", ":LazyGit<CR>", { desc = "Git status (LazyGit)" })
      
      -- LazyGit через toggleterm
      keymap("n", "<leader>gg", function()
        local Terminal = require("toggleterm.terminal").Terminal
        local lazygit = Terminal:new({
          cmd = "lazygit",
          dir = "git_dir",
          direction = "float",
          float_opts = {
            border = "curved",
            width = function()
              return math.floor(vim.o.columns * 0.95)
            end,
            height = function()
              return math.floor(vim.o.lines * 0.95)
            end,
          },
          on_open = function(term)
            vim.cmd("startinsert!")
            vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
          end,
        })
        lazygit:toggle()
      end, { desc = "LazyGit (toggleterm)" })
    end, 100)
    
    -- Команды для удобства
    vim.api.nvim_create_user_command("Lg", "LazyGit", { desc = "Open LazyGit" })
    vim.api.nvim_create_user_command("Lgs", "LazyGit", { desc = "Git status" })
    vim.api.nvim_create_user_command("Lgc", "LazyGitCurrentFile", { desc = "LazyGit current file" })
  end,
}
