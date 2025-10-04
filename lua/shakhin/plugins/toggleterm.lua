return {
  "akinsho/toggleterm.nvim",
  version = "*",
  event = "VeryLazy", -- Загружаем после других плагинов
  config = function()
    -- Устанавливаем leader (на случай если не определен)
    vim.g.mapleader = " "
    
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
      
      -- Оболочка по умолчанию
      shell = vim.o.shell,
      
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
      -- Кеймапы для toggleterm
      local keymap = vim.keymap.set
      local opts = { noremap = true, silent = true }
      
      -- Основные кеймапы
      keymap("n", "<leader>tt", ":ToggleTerm<CR>", { desc = "Toggle terminal" })
      keymap("n", "<leader>tf", ":ToggleTerm direction=float<CR>", { desc = "Toggle floating terminal" })
      keymap("n", "<leader>th", ":ToggleTerm direction=horizontal<CR>", { desc = "Toggle horizontal terminal" })
      keymap("n", "<leader>tv", ":ToggleTerm direction=vertical size=80<CR>", { desc = "Toggle vertical terminal" })
      
      -- Несколько терминалов
      keymap("n", "<leader>t1", ":1ToggleTerm<CR>", { desc = "Toggle terminal 1" })
      keymap("n", "<leader>t2", ":2ToggleTerm<CR>", { desc = "Toggle terminal 2" })
      keymap("n", "<leader>t3", ":3ToggleTerm<CR>", { desc = "Toggle terminal 3" })
      
      -- Python команды
      keymap("n", "<leader>tp", ":TermExec cmd='python %' dir=getcwd()<CR>", { desc = "Run Python file" })
      
      keymap("n", "<leader>ti", function()
        -- Запуск файла в IPython с проверкой venv
        local venv = vim.env.VIRTUAL_ENV
        if venv then
          vim.cmd("TermExec cmd='ipython -i " .. vim.fn.expand('%') .. "' dir=getcwd()")
        else
          local venv_path = vim.fn.getcwd() .. "/.venv"
          if vim.fn.isdirectory(venv_path) == 1 then
            vim.cmd("TermExec cmd='source .venv/bin/activate && ipython -i " .. vim.fn.expand('%') .. "' dir=getcwd()")
          else
            vim.cmd("TermExec cmd='ipython -i " .. vim.fn.expand('%') .. "' dir=getcwd()")
          end
        end
      end, { desc = "Run file in IPython" })
      
      keymap("n", "<leader>tI", function()
        -- Запуск чистого IPython с проверкой venv
        local venv = vim.env.VIRTUAL_ENV
        if venv then
          vim.cmd("TermExec cmd='ipython' dir=getcwd()")
        else
          local venv_path = vim.fn.getcwd() .. "/.venv"
          if vim.fn.isdirectory(venv_path) == 1 then
            vim.cmd("TermExec cmd='source .venv/bin/activate && ipython' dir=getcwd()")
          else
            vim.notify("No .venv found. Using system IPython.", vim.log.levels.INFO)
            vim.cmd("TermExec cmd='ipython' dir=getcwd()")
          end
        end
      end, { desc = "Open clean IPython" })
      
      keymap("n", "<leader>tR", function()
        -- Запуск обычного Python REPL (без IPython) - changed from tP to tR to avoid conflict
        local venv = vim.env.VIRTUAL_ENV
        if venv then
          vim.cmd("TermExec cmd='python' dir=getcwd()")
        else
          local venv_path = vim.fn.getcwd() .. "/.venv"
          if vim.fn.isdirectory(venv_path) == 1 then
            vim.cmd("TermExec cmd='source .venv/bin/activate && python' dir=getcwd()")
          else
            vim.cmd("TermExec cmd='python' dir=getcwd()")
          end
        end
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
