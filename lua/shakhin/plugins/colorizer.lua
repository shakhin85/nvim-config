return {
  "norcalli/nvim-colorizer.lua",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("colorizer").setup({
      -- Файлы для которых включить подсветку цветов
      filetypes = {
        "css",
        "scss",
        "sass",
        "html",
        "javascript",
        "typescript",
        "jsx",
        "tsx",
        "vue",
        "svelte",
        "lua",
        "python",
        "json",
        "yaml",
        "toml",
        "conf",
        "config",
        -- Можно добавить "*" для всех файлов, но это может замедлить работу
      },
      
      -- Настройки по умолчанию для всех типов файлов
      user_default_options = {
        -- RGB: #RGB hex codes
        RGB = true,
        -- RRGGBB: #RRGGBB hex codes  
        RRGGBB = true,
        -- RRGGBBAA: #RRGGBBAA hex codes
        RRGGBBAA = false,
        -- rgb_fn: CSS rgb() and rgba() functions
        rgb_fn = true,
        -- hsl_fn: CSS hsl() and hsla() functions
        hsl_fn = true,
        -- CSS names: "red", "blue", "green" и т.д.
        css = true,
        -- CSS функции: oklch(), lab() и т.д.
        css_fn = true,
        -- Режим отображения цвета
        -- "foreground": изменить цвет текста
        -- "background": изменить фон текста
        -- "virtualtext": показать цвет как виртуальный текст
        mode = "background",
        
        -- Имена для tailwind CSS (если используете)
        tailwind = false,
        -- sass цвета
        sass = { enable = false },
        
        -- Доступные режимы: "foreground", "background", "virtualtext"
        virtualtext = "■",
        
        -- Обновлять цвета при редактировании
        always_update = false
      },
      
      -- Специальные настройки для конкретных типов файлов
      buftypes = {},
    })
    
    -- Команды для управления colorizer
    vim.api.nvim_create_user_command("ColorizerToggle", function()
      vim.cmd("ColorizerToggle")
    end, { desc = "Toggle colorizer" })
    
    vim.api.nvim_create_user_command("ColorizerAttach", function()
      vim.cmd("ColorizerAttachToBuffer")
    end, { desc = "Attach colorizer to current buffer" })
    
    vim.api.nvim_create_user_command("ColorizerDetach", function()
      vim.cmd("ColorizerDetachFromBuffer")
    end, { desc = "Detach colorizer from current buffer" })
  end,
}
