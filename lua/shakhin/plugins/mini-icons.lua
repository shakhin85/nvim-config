return {
  "echasnovski/mini.icons",
  version = false,
  event = "VeryLazy",
  config = function()
    local icons = require("mini.icons")
    icons.setup({
      -- Стиль иконок: 'glyph' или 'ascii'
      style = "glyph",

      -- Кастомные иконки для файлов
      file = {
        [".eslintrc.js"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
        [".node-version"] = { glyph = "", hl = "MiniIconsGreen" },
        [".prettierrc"] = { glyph = "", hl = "MiniIconsPurple" },
        [".yarnrc.yml"] = { glyph = "", hl = "MiniIconsBlue" },
        ["eslint.config.js"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
        ["package.json"] = { glyph = "", hl = "MiniIconsGreen" },
        ["tsconfig.json"] = { glyph = "", hl = "MiniIconsAzure" },
        ["tsconfig.build.json"] = { glyph = "", hl = "MiniIconsAzure" },
        ["yarn.lock"] = { glyph = "", hl = "MiniIconsBlue" },
        [".env"] = { glyph = "", hl = "MiniIconsYellow" },
        [".gitignore"] = { glyph = "", hl = "MiniIconsOrange" },
        ["Dockerfile"] = { glyph = "", hl = "MiniIconsBlue" },
        ["docker-compose.yml"] = { glyph = "", hl = "MiniIconsBlue" },
        ["init.lua"] = { glyph = "", hl = "MiniIconsBlue" },
        ["lazy-lock.json"] = { glyph = "", hl = "MiniIconsPurple" },
      },

      -- Кастомные иконки для расширений файлов
      extension = {
        lua = { glyph = "", hl = "MiniIconsBlue" },
        py = { glyph = "", hl = "MiniIconsYellow" },
        js = { glyph = "", hl = "MiniIconsYellow" },
        ts = { glyph = "", hl = "MiniIconsAzure" },
        jsx = { glyph = "", hl = "MiniIconsCyan" },
        tsx = { glyph = "", hl = "MiniIconsCyan" },
        json = { glyph = "", hl = "MiniIconsGreen" },
        md = { glyph = "", hl = "MiniIconsBlue" },
        yaml = { glyph = "", hl = "MiniIconsOrange" },
        yml = { glyph = "", hl = "MiniIconsOrange" },
        toml = { glyph = "", hl = "MiniIconsOrange" },
        sh = { glyph = "", hl = "MiniIconsGreen" },
        vim = { glyph = "", hl = "MiniIconsGreen" },
        go = { glyph = "", hl = "MiniIconsCyan" },
        rs = { glyph = "", hl = "MiniIconsOrange" },
        html = { glyph = "", hl = "MiniIconsRed" },
        css = { glyph = "", hl = "MiniIconsBlue" },
        scss = { glyph = "", hl = "MiniIconsPurple" },
        sql = { glyph = "", hl = "MiniIconsYellow" },
        prisma = { glyph = "", hl = "MiniIconsBlue" },
        graphql = { glyph = "", hl = "MiniIconsPurple" },
        gql = { glyph = "", hl = "MiniIconsPurple" },
        svelte = { glyph = "", hl = "MiniIconsRed" },
        vue = { glyph = "", hl = "MiniIconsGreen" },
      },

      -- Кастомные иконки для директорий
      directory = {
        [".github"] = { glyph = "", hl = "MiniIconsAzure" },
        [".git"] = { glyph = "", hl = "MiniIconsOrange" },
        ["node_modules"] = { glyph = "", hl = "MiniIconsGreen" },
        ["src"] = { glyph = "", hl = "MiniIconsBlue" },
        ["dist"] = { glyph = "", hl = "MiniIconsYellow" },
        ["build"] = { glyph = "", hl = "MiniIconsYellow" },
        ["public"] = { glyph = "", hl = "MiniIconsCyan" },
        ["assets"] = { glyph = "", hl = "MiniIconsPurple" },
        ["components"] = { glyph = "", hl = "MiniIconsCyan" },
        ["plugins"] = { glyph = "", hl = "MiniIconsPurple" },
        ["core"] = { glyph = "", hl = "MiniIconsRed" },
        ["utils"] = { glyph = "", hl = "MiniIconsGreen" },
        ["tests"] = { glyph = "󰙨", hl = "MiniIconsYellow" },
        ["test"] = { glyph = "󰙨", hl = "MiniIconsYellow" },
        ["__tests__"] = { glyph = "󰙨", hl = "MiniIconsYellow" },
        ["config"] = { glyph = "", hl = "MiniIconsOrange" },
        ["docs"] = { glyph = "", hl = "MiniIconsBlue" },
      },

      -- Кастомные иконки для типов файлов (filetype)
      filetype = {
        lua = { glyph = "", hl = "MiniIconsBlue" },
        python = { glyph = "", hl = "MiniIconsYellow" },
        javascript = { glyph = "", hl = "MiniIconsYellow" },
        typescript = { glyph = "", hl = "MiniIconsAzure" },
        rust = { glyph = "", hl = "MiniIconsOrange" },
        go = { glyph = "", hl = "MiniIconsCyan" },
        markdown = { glyph = "", hl = "MiniIconsBlue" },
        vim = { glyph = "", hl = "MiniIconsGreen" },
        help = { glyph = "󰋖", hl = "MiniIconsPurple" },
      },

      -- Кастомные иконки для LSP
      lsp = {
        array = { glyph = "󰅪", hl = "MiniIconsOrange" },
        boolean = { glyph = "", hl = "MiniIconsOrange" },
        class = { glyph = "", hl = "MiniIconsYellow" },
        color = { glyph = "", hl = "MiniIconsRed" },
        constant = { glyph = "", hl = "MiniIconsOrange" },
        constructor = { glyph = "", hl = "MiniIconsYellow" },
        enum = { glyph = "", hl = "MiniIconsYellow" },
        enumMember = { glyph = "", hl = "MiniIconsCyan" },
        event = { glyph = "", hl = "MiniIconsRed" },
        field = { glyph = "", hl = "MiniIconsCyan" },
        file = { glyph = "", hl = "MiniIconsBlue" },
        folder = { glyph = "", hl = "MiniIconsBlue" },
        ["function"] = { glyph = "󰊕", hl = "MiniIconsPurple" },
        interface = { glyph = "", hl = "MiniIconsYellow" },
        key = { glyph = "", hl = "MiniIconsCyan" },
        keyword = { glyph = "", hl = "MiniIconsPurple" },
        method = { glyph = "", hl = "MiniIconsPurple" },
        module = { glyph = "", hl = "MiniIconsBlue" },
        namespace = { glyph = "", hl = "MiniIconsBlue" },
        null = { glyph = "󰟢", hl = "MiniIconsGrey" },
        number = { glyph = "", hl = "MiniIconsOrange" },
        object = { glyph = "", hl = "MiniIconsOrange" },
        operator = { glyph = "", hl = "MiniIconsCyan" },
        package = { glyph = "", hl = "MiniIconsBlue" },
        property = { glyph = "", hl = "MiniIconsCyan" },
        reference = { glyph = "", hl = "MiniIconsRed" },
        snippet = { glyph = "", hl = "MiniIconsGreen" },
        string = { glyph = "", hl = "MiniIconsGreen" },
        struct = { glyph = "", hl = "MiniIconsYellow" },
        text = { glyph = "", hl = "MiniIconsGreen" },
        typeParameter = { glyph = "", hl = "MiniIconsYellow" },
        unit = { glyph = "", hl = "MiniIconsOrange" },
        value = { glyph = "", hl = "MiniIconsCyan" },
        variable = { glyph = "", hl = "MiniIconsBlue" },
      },

      -- Кастомные иконки для операционной системы
      os = {
        linux = { glyph = "", hl = "MiniIconsYellow" },
        macos = { glyph = "", hl = "MiniIconsBlue" },
        windows = { glyph = "", hl = "MiniIconsAzure" },
      },
    })

    -- Мок для nvim-web-devicons для совместимости с другими плагинами
    icons.mock_nvim_web_devicons()
  end,
}
