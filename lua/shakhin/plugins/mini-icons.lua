return {
  "echasnovski/mini.icons",
  version = false,
  event = "VeryLazy",
  opts = {
    -- Style: 'glyph' or 'ascii'
    style = "glyph",

    -- Customize default icons
    default = {
      -- Override default file icon
      file = { glyph = "󰈔", hl = "MiniIconsGrey" },
    },

    -- Customize directory icons
    directory = {
      -- Example: custom icons for specific directory names
      [".git"] = { glyph = "", hl = "MiniIconsOrange" },
      ["node_modules"] = { glyph = "", hl = "MiniIconsGreen" },
      [".github"] = { glyph = "", hl = "MiniIconsPurple" },
    },

    -- Customize file extension icons
    extension = {
      -- Programming languages
      lua = { glyph = "󰢱", hl = "MiniIconsBlue" },
      py = { glyph = "󰌠", hl = "MiniIconsYellow" },
      rs = { glyph = "󱘗", hl = "MiniIconsOrange" },
      go = { glyph = "󰟓", hl = "MiniIconsCyan" },
      js = { glyph = "󰌞", hl = "MiniIconsYellow" },
      ts = { glyph = "󰛦", hl = "MiniIconsBlue" },

      -- Config files
      json = { glyph = "󰘦", hl = "MiniIconsYellow" },
      yaml = { glyph = "", hl = "MiniIconsPurple" },
      toml = { glyph = "", hl = "MiniIconsOrange" },

      -- Markup
      md = { glyph = "󰍔", hl = "MiniIconsBlue" },
      html = { glyph = "󰌝", hl = "MiniIconsOrange" },
      css = { glyph = "󰌜", hl = "MiniIconsBlue" },
    },

    -- Customize specific file names
    file = {
      [".gitignore"] = { glyph = "", hl = "MiniIconsRed" },
      ["package.json"] = { glyph = "", hl = "MiniIconsGreen" },
      ["Cargo.toml"] = { glyph = "󱘗", hl = "MiniIconsOrange" },
      ["init.lua"] = { glyph = "󰢱", hl = "MiniIconsBlue" },
      ["README.md"] = { glyph = "󰍔", hl = "MiniIconsCyan" },
    },

    -- Customize filetype icons
    filetype = {
      python = { glyph = "󰌠", hl = "MiniIconsYellow" },
      lua = { glyph = "󰢱", hl = "MiniIconsBlue" },
      rust = { glyph = "󱘗", hl = "MiniIconsOrange" },
      javascript = { glyph = "󰌞", hl = "MiniIconsYellow" },
      typescript = { glyph = "󰛦", hl = "MiniIconsBlue" },
    },

    -- Customize LSP kind icons
    lsp = {
      -- LSP completion item kinds
      array = { glyph = "󰅪", hl = "MiniIconsOrange" },
      boolean = { glyph = "󰨙", hl = "MiniIconsOrange" },
      class = { glyph = "󰠱", hl = "MiniIconsYellow" },
      constant = { glyph = "󰏿", hl = "MiniIconsOrange" },
      constructor = { glyph = "", hl = "MiniIconsYellow" },
      enum = { glyph = "", hl = "MiniIconsYellow" },
      field = { glyph = "󰜢", hl = "MiniIconsBlue" },
      file = { glyph = "󰈔", hl = "MiniIconsGrey" },
      function_symbol = { glyph = "󰊕", hl = "MiniIconsPurple" },
      interface = { glyph = "", hl = "MiniIconsBlue" },
      method = { glyph = "󰊕", hl = "MiniIconsPurple" },
      module = { glyph = "", hl = "MiniIconsGreen" },
      property = { glyph = "󰜢", hl = "MiniIconsBlue" },
      string = { glyph = "󰀬", hl = "MiniIconsGreen" },
      variable = { glyph = "󰀫", hl = "MiniIconsCyan" },
    },

    -- Customize OS icons
    os = {
      linux = { glyph = "󰌽", hl = "MiniIconsYellow" },
      macos = { glyph = "", hl = "MiniIconsGrey" },
      windows = { glyph = "󰖳", hl = "MiniIconsBlue" },
    },

    -- Use file extension for resolution
    use_file_extension = function(ext, file)
      return true
    end,
  },
  init = function()
    -- Mock nvim-web-devicons for compatibility with other plugins
    package.preload["nvim-web-devicons"] = function()
      require("mini.icons").mock_nvim_web_devicons()
      return package.loaded["nvim-web-devicons"]
    end
  end,
}
