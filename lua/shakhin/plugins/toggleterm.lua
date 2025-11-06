return {
  "akinsho/toggleterm.nvim",
  version = "*",
  event = "VeryLazy", -- Загружаем после других плагинов
  config = function()
    -- Устанавливаем leader (на случай если не определен)
    vim.g.mapleader = " "

    -- Cross-platform detection
    local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1

    require("toggleterm").setup({
      -- Размер терминала
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      
      -- Горячая клавиша для открытия (Ctrl+\)
      open_mapping = [[<c-\>]],
      
      -- Скрыть номера строк в терминале
      hide_numbers = true,
      
      -- Настройки тени для floating терминала
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      
      -- Начальная директория для терминала
      start_in_insert = true,
      insert_mappings = true,
      terminal_mappings = true,
      
      -- Сохранять размер при переключении
      persist_size = true,
      persist_mode = true,
      
      -- Направление открытия терминала
      direction = "float",
      
      -- Закрывать терминал при выходе из процесса
      close_on_exit = true,
      
      -- Оболочка по умолчанию (PowerShell 7 Core)
      shell = vim.o.shell, -- Использует shell из Neovim настроек
      
      -- Автопрокрутка
      auto_scroll = true,
      
      -- Настройки для floating терминала
      float_opts = {
        border = "curved",
        width = function()
          return math.floor(vim.o.columns * 0.8)
        end,
        height = function()
          return math.floor(vim.o.lines * 0.8)
        end,
        row = function()
          return math.floor((vim.o.lines - math.floor(vim.o.lines * 0.8)) / 2)
        end,
        col = function()
          return math.floor((vim.o.columns - math.floor(vim.o.columns * 0.8)) / 2)
        end,
        winblend = 3,
      },
    })

    -- Добавляем небольшую задержку чтобы which-key успел загрузиться
    vim.defer_fn(function()
      -- Helper functions for cross-platform venv activation
      local function get_venv_path()
        return vim.fn.getcwd() .. (is_windows and "\\.venv" or "/.venv")
      end

      local function get_venv_activate_cmd()
        if is_windows then
          return ".venv\\\\Scripts\\\\Activate.ps1; "
        else
          return "source .venv/bin/activate && "
        end
      end

      local function run_with_venv(cmd)
        local venv = vim.env.VIRTUAL_ENV
        if venv then
          return cmd
        else
          local venv_path = get_venv_path()
          if vim.fn.isdirectory(venv_path) == 1 then
            return get_venv_activate_cmd() .. cmd
          else
            return cmd
          end
        end
      end

      -- Кеймапы для toggleterm
      local keymap = vim.keymap.set
      local opts = { noremap = true, silent = true }
      
      -- Основные кеймапы
      keymap("n", "<leader>tt", ":ToggleTerm<CR>", { desc = "Toggle terminal" })
      keymap("n", "<leader>t.", ":ToggleTerm direction=float<CR>", { desc = "Toggle floating terminal" }) -- Changed from <leader>tf to avoid conflict with tab open
      keymap("n", "<leader>th", ":ToggleTerm direction=horizontal<CR>", { desc = "Toggle horizontal terminal" })
      keymap("n", "<leader>tv", ":ToggleTerm direction=vertical size=80<CR>", { desc = "Toggle vertical terminal" })
      
      -- Несколько терминалов
      keymap("n", "<leader>t1", ":1ToggleTerm<CR>", { desc = "Toggle terminal 1" })
      keymap("n", "<leader>t2", ":2ToggleTerm<CR>", { desc = "Toggle terminal 2" })
      keymap("n", "<leader>t3", ":3ToggleTerm<CR>", { desc = "Toggle terminal 3" })
      
      -- Python команды
      keymap("n", "<leader>tp", ":TermExec cmd='python %' dir=getcwd()<CR>", { desc = "Run Python file" })
      
      keymap("n", "<leader>ti", function()
        -- Запуск файла в IPython с проверкой venv (cross-platform)
        local cmd = run_with_venv("ipython -i " .. vim.fn.expand('%'))
        vim.cmd("TermExec cmd='" .. cmd .. "' dir=getcwd()")
      end, { desc = "Run file in IPython" })
      
      keymap("n", "<leader>tI", function()
        -- Запуск чистого IPython с проверкой venv (cross-platform)
        local venv_path = get_venv_path()
        if vim.env.VIRTUAL_ENV == nil and vim.fn.isdirectory(venv_path) == 0 then
          vim.notify("No .venv found. Using system IPython.", vim.log.levels.INFO)
        end
        local cmd = run_with_venv("ipython")
        vim.cmd("TermExec cmd='" .. cmd .. "' dir=getcwd()")
      end, { desc = "Open clean IPython" })
      
      keymap("n", "<leader>tR", function()
        -- Запуск обычного Python REPL (без IPython) - cross-platform
        local cmd = run_with_venv("python")
        vim.cmd("TermExec cmd='" .. cmd .. "' dir=getcwd()")
      end, { desc = "Open Python REPL" })
      
      -- Кеймап для очистки прямо в terminal mode
      keymap("t", "<C-c>", function()
        vim.api.nvim_feedkeys("clear\r", "n",false)
      end, { desc = "Clear terminal in terminal mode" })
      
      -- Выход из терминального режима
      keymap("t", "<esc>", [[<C-\><C-n>]], opts)
    end, 100)
  end,
}
