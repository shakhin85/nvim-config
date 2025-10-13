return {
  -- Основной плагин для работы с БД
  {
    "tpope/vim-dadbod",
    dependencies = {
      "kristijanhusak/vim-dadbod-ui", -- UI интерфейс
      "kristijanhusak/vim-dadbod-completion", -- Автодополнение SQL
    },
  },

  -- UI для dadbod
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      -- Настройки dadbod-ui
      vim.g.db_ui_use_nerd_fonts = 1 -- Использовать иконки
      vim.g.db_ui_show_database_icon = 1
      vim.g.db_ui_force_echo_notifications = 1
      vim.g.db_ui_win_position = "left" -- Панель слева
      vim.g.db_ui_winwidth = 40 -- Ширина панели

      -- Автосохранение запросов
      vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/db_ui_queries"

      -- Иконки для типов БД
      vim.g.db_ui_icons = {
        expanded = {
          db = "▾ ",
          buffers = "▾ ",
          saved_queries = "▾ ",
          schemas = "▾ ",
          schema = "▾ פּ",
          tables = "▾ 藺",
          table = "▾ ",
        },
        collapsed = {
          db = "▸ ",
          buffers = "▸ ",
          saved_queries = "▸ ",
          schemas = "▸ ",
          schema = "▸ פּ",
          tables = "▸ 藺",
          table = "▸ ",
        },
        saved_query = "",
        new_query = "璘",
        tables = "離",
        buffers = "﬘",
        add_connection = "",
        connection_ok = "✓",
        connection_error = "✕",
      }

      -- Выполнение запросов
      vim.g.db_ui_execute_on_save = 0 -- Не выполнять при сохранении
    end,
    config = function()
      -- Автодополнение для SQL в dadbod buffers
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "sql", "mysql", "plsql" },
        callback = function()
          local cmp = require("cmp")

          -- Добавляем dadbod completion как источник
          cmp.setup.buffer({
            sources = {
              { name = "vim-dadbod-completion" },
              { name = "buffer" },
              { name = "luasnip" },
            },
          })
        end,
      })

      -- Кеймапы
      local keymap = vim.keymap

      -- Открыть/закрыть UI
      keymap.set("n", "<leader>db", "<cmd>DBUIToggle<cr>", { desc = "Toggle DBUI" })

      -- Найти буфер БД
      keymap.set("n", "<leader>df", "<cmd>DBUIFindBuffer<cr>", { desc = "Find DB buffer" })

      -- Добавить соединение
      keymap.set("n", "<leader>da", "<cmd>DBUIAddConnection<cr>", { desc = "Add DB connection" })

      -- Выполнить запрос (в visual mode)
      keymap.set("v", "<leader>de", ":DB<cr>", { desc = "Execute SQL query" })
    end,
  },
}
