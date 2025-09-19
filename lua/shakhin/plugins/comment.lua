return {
  "numToStr/Comment.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require('Comment').setup({
      -- Добавить пробел после маркера комментария
      padding = true,
      
      -- Липкий курсор (остается на том же месте после комментирования)
      sticky = true,
      
      -- Игнорировать пустые строки
      ignore = nil,
      
      -- Тогглы для режимов
      toggler = {
        line = 'gcc',  -- Переключить комментарий строки
        block = 'gbc', -- Переключить блочный комментарий
      },
      
      -- Оператор-режим маппинги
      opleader = {
        line = 'gc',   -- Комментарий по движению
        block = 'gb',  -- Блочный комментарий по движению
      },
      
      -- Дополнительные маппинги
      extra = {
        above = 'gcO', -- Добавить комментарий выше
        below = 'gco', -- Добавить комментарий ниже
        eol = 'gcA',   -- Добавить комментарий в конце строки
      },
      
      -- Включить кеймапы
      mappings = {
        basic = true,    -- gcc, gbc, gc[count]{motion}, gb[count]{motion}
        extra = true,    -- gco, gcO, gcA
      },
    })

    -- Дополнительные кеймапы для удобства
    local keymap = vim.keymap.set
    
    -- Leader маппинги для быстрого доступа
    keymap("n", "<leader>/", "gcc", { remap = true, desc = "Toggle comment line" })
    keymap("v", "<leader>/", "gc", { remap = true, desc = "Toggle comment selection" })
    keymap("n", "<leader>?", "gbc", { remap = true, desc = "Toggle block comment" })
    
    -- Альтернативные маппинги
    keymap("n", "<C-_>", "gcc", { remap = true, desc = "Toggle comment" })  -- Ctrl+/ (работает как Ctrl+_)
    keymap("v", "<C-_>", "gc", { remap = true, desc = "Toggle comment" })
    keymap("i", "<C-_>", "<ESC>gcc", { remap = true, desc = "Toggle comment" })
  end,
}
