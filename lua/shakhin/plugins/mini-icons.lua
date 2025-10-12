return {
  "echasnovski/mini.icons",
  version = false,
  config = function()
    local mini_icons = require("mini.icons")

    mini_icons.setup({
      -- Стиль иконок: 'glyph' (символы) или 'ascii' (текст)
      style = "glyph",

      -- Настройки для разных категорий
      default = {
        -- Иконка по умолчанию для файлов
        file = { glyph = "󰈔", hl = "MiniIconsGrey" },
        -- Иконка по умолчанию для расширений
        extension = { glyph = "󰈔", hl = "MiniIconsGrey" },
        -- Иконка по умолчанию для директорий
        directory = { glyph = "󰉋", hl = "MiniIconsAzure" },
        -- Иконка по умолчанию для LSP
        lsp = { glyph = "󰞋", hl = "MiniIconsRed" },
        -- Иконка по умолчанию для OS
        os = { glyph = "󰟀", hl = "MiniIconsPurple" },
      },

      -- Дополнительные кастомные иконки для расширений файлов
      extension = {
        -- Python
        py = { glyph = "󰌠", hl = "MiniIconsYellow" },
        pyc = { glyph = "󰌠", hl = "MiniIconsYellow" },

        -- JavaScript/TypeScript
        js = { glyph = "󰌞", hl = "MiniIconsYellow" },
        ts = { glyph = "󰛦", hl = "MiniIconsBlue" },
        jsx = { glyph = "", hl = "MiniIconsCyan" },
        tsx = { glyph = "", hl = "MiniIconsCyan" },

        -- Lua
        lua = { glyph = "󰢱", hl = "MiniIconsBlue" },

        -- Web
        html = { glyph = "󰌝", hl = "MiniIconsOrange" },
        css = { glyph = "󰌜", hl = "MiniIconsBlue" },
        scss = { glyph = "󰌜", hl = "MiniIconsPurple" },
        sass = { glyph = "󰌜", hl = "MiniIconsPurple" },

        -- Markdown & Docs
        md = { glyph = "󰍔", hl = "MiniIconsBlue" },
        txt = { glyph = "󰈙", hl = "MiniIconsGrey" },

        -- Config files
        json = { glyph = "󰘦", hl = "MiniIconsYellow" },
        yaml = { glyph = "", hl = "MiniIconsPurple" },
        yml = { glyph = "", hl = "MiniIconsPurple" },
        toml = { glyph = "", hl = "MiniIconsOrange" },
        conf = { glyph = "", hl = "MiniIconsGrey" },

        -- Git
        gitignore = { glyph = "󰊢", hl = "MiniIconsRed" },
        gitconfig = { glyph = "󰊢", hl = "MiniIconsOrange" },

        -- Shell
        sh = { glyph = "", hl = "MiniIconsGreen" },
        bash = { glyph = "", hl = "MiniIconsGreen" },
        zsh = { glyph = "", hl = "MiniIconsGreen" },

        -- Docker
        dockerfile = { glyph = "󰡨", hl = "MiniIconsBlue" },

        -- Rust
        rs = { glyph = "󱘗", hl = "MiniIconsOrange" },

        -- Go
        go = { glyph = "󰟓", hl = "MiniIconsCyan" },

        -- C/C++
        c = { glyph = "", hl = "MiniIconsBlue" },
        cpp = { glyph = "", hl = "MiniIconsBlue" },
        h = { glyph = "", hl = "MiniIconsPurple" },
        hpp = { glyph = "", hl = "MiniIconsPurple" },

        -- Other
        vim = { glyph = "", hl = "MiniIconsGreen" },
        svg = { glyph = "󰜡", hl = "MiniIconsYellow" },
        png = { glyph = "󰈟", hl = "MiniIconsPurple" },
        jpg = { glyph = "󰈟", hl = "MiniIconsYellow" },
        jpeg = { glyph = "󰈟", hl = "MiniIconsYellow" },
        gif = { glyph = "󰵸", hl = "MiniIconsGreen" },
      },

      -- Иконки для конкретных имён файлов
      file = {
        [".gitignore"] = { glyph = "󰊢", hl = "MiniIconsRed" },
        [".gitconfig"] = { glyph = "󰊢", hl = "MiniIconsOrange" },
        ["package.json"] = { glyph = "", hl = "MiniIconsGreen" },
        ["package-lock.json"] = { glyph = "", hl = "MiniIconsRed" },
        ["tsconfig.json"] = { glyph = "", hl = "MiniIconsBlue" },
        ["Cargo.toml"] = { glyph = "󱘗", hl = "MiniIconsOrange" },
        ["Cargo.lock"] = { glyph = "󱘗", hl = "MiniIconsRed" },
        ["go.mod"] = { glyph = "󰟓", hl = "MiniIconsCyan" },
        ["go.sum"] = { glyph = "󰟓", hl = "MiniIconsGrey" },
        ["requirements.txt"] = { glyph = "󰌠", hl = "MiniIconsBlue" },
        ["Pipfile"] = { glyph = "󰌠", hl = "MiniIconsYellow" },
        ["pyproject.toml"] = { glyph = "󰌠", hl = "MiniIconsBlue" },
        ["Dockerfile"] = { glyph = "󰡨", hl = "MiniIconsBlue" },
        ["docker-compose.yml"] = { glyph = "󰡨", hl = "MiniIconsCyan" },
        ["Makefile"] = { glyph = "", hl = "MiniIconsGrey" },
        ["README.md"] = { glyph = "󰍔", hl = "MiniIconsYellow" },
        ["LICENSE"] = { glyph = "󰿃", hl = "MiniIconsYellow" },
        ["init.lua"] = { glyph = "󰢱", hl = "MiniIconsBlue" },
      },

      -- Иконки для filetype
      filetype = {
        python = { glyph = "󰌠", hl = "MiniIconsYellow" },
        lua = { glyph = "󰢱", hl = "MiniIconsBlue" },
        javascript = { glyph = "󰌞", hl = "MiniIconsYellow" },
        typescript = { glyph = "󰛦", hl = "MiniIconsBlue" },
        rust = { glyph = "󱘗", hl = "MiniIconsOrange" },
        go = { glyph = "󰟓", hl = "MiniIconsCyan" },
        vim = { glyph = "", hl = "MiniIconsGreen" },
        markdown = { glyph = "󰍔", hl = "MiniIconsBlue" },
      },
    })

    -- Настройка mock функций для совместимости с nvim-web-devicons
    mini_icons.mock_nvim_web_devicons()
  end,
}
