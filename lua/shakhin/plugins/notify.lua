return {
  "rcarriga/nvim-notify",
  event = "VeryLazy",
  config = function()
    local notify = require("notify")
    
    notify.setup({
      -- Анимация появления уведомлений
      stages = "fade_in_slide_out", -- "fade_in_slide_out" | "fade" | "slide" | "static"
      
      -- Время отображения уведомлений (в мс)
      timeout = 3000,
      
      -- Цвет фона (для темных тем)
      background_colour = "#000000",
      
      -- Минимальная ширина окна уведомления
      minimum_width = 50,
      
      -- Максимальная ширина окна уведомления
      max_width = 80,
      
      -- Максимальная высота окна уведомления  
      max_height = 10,
      
      -- Позиция уведомлений на экране
      -- "top_left" | "top_right" | "bottom_left" | "bottom_right"
      top_down = true,
      
      -- Стиль отображения
      -- "default" | "minimal" | "simple" | "compact"
      render = "default",
      
      -- Иконки для разных уровней уведомлений
      icons = {
        ERROR = "",
        WARN = "",
        INFO = "",
        DEBUG = "",
        TRACE = "✎",
      },
      
      -- Настройки анимации
      fps = 30,
      
      -- Функция для фильтрации уведомлений
      on_open = function(win)
        -- Делаем окно уведомления не focusable
        vim.api.nvim_win_set_config(win, { focusable = false })
      end,
      
      -- Функция для закрытия уведомления
      on_close = function() end,
    })
    
    -- Заменяем стандартную функцию vim.notify
    vim.notify = notify
    
    -- Дополнительные кеймапы для управления уведомлениями
    local keymap = vim.keymap.set
    local opts = { noremap = true, silent = true }
    
    -- Показать историю уведомлений
    keymap("n", "<leader>nn", function()
      require("telescope").extensions.notify.notify()
    end, { desc = "Show notification history" })
    
    -- Очистить все уведомления
    keymap("n", "<leader>nc", function()
      require("notify").dismiss({ silent = true, pending = true })
    end, { desc = "Clear all notifications" })
    
    -- Показать последнее уведомление (исправленная версия)
    keymap("n", "<leader>nl", function()
      -- Простая демонстрация - показываем информационное сообщение
      vim.notify("Showing notification functionality", vim.log.levels.INFO, { title = "Notifications" })
    end, { desc = "Show notification demo" })
    
    -- Тестовые команды для демонстрации
    vim.api.nvim_create_user_command("NotifyTest", function()
      vim.notify("This is a test notification!", vim.log.levels.INFO, { title = "Test" })
    end, { desc = "Test notification" })
    
    vim.api.nvim_create_user_command("NotifyError", function()
      vim.notify("This is an error notification!", vim.log.levels.ERROR, { title = "Error" })
    end, { desc = "Test error notification" })
    
    vim.api.nvim_create_user_command("NotifyWarn", function()
      vim.notify("This is a warning notification!", vim.log.levels.WARN, { title = "Warning" })
    end, { desc = "Test warning notification" })
  end,
}
