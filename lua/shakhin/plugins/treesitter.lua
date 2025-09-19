return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  config = function()
    require("nvim-treesitter.configs").setup({
      -- Список языков для установки
      ensure_installed = {
        "lua",
        "vim",
        "vimdoc",
        "python",
        "javascript",
        "typescript",
        "html",
        "css",
        "scss",
        "json",
        "yaml",
        "toml",
        "markdown",
        "markdown_inline",
        "bash",
        "dockerfile",
        "gitignore",
        "regex",
        "sql",
        "c",
        "cpp",
        "rust",
        "go",
      },

      -- Автоматическая установка недостающих парсеров
      auto_install = true,

      -- Синхронная установка (только для команды `ensure_installed`)
      sync_install = false,

      -- Подсветка синтаксиса
      highlight = {
        enable = true,

        -- Отключить treesitter для больших файлов
        disable = function(lang, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,

        -- Дополнительная подсветка vim regex
        additional_vim_regex_highlighting = false,
      },

      -- Автоматическое определение отступов
      indent = {
        enable = true,
        -- Отключить для Python (может конфликтовать)
        disable = { "python" },
      },

      -- Автоматические теги для HTML/XML
      autotag = {
        enable = true,
      },

      -- Инкрементальное выделение
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = "<C-s>",
          node_decremental = "<M-space>",
        },
      },

      -- Текстовые объекты
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["ai"] = "@conditional.outer",
            ["ii"] = "@conditional.inner",
            ["al"] = "@loop.outer",
            ["il"] = "@loop.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]f"] = "@function.outer",
            ["]c"] = "@class.outer",
          },
          goto_next_end = {
            ["]F"] = "@function.outer",
            ["]C"] = "@class.outer",
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",
            ["[c"] = "@class.outer",
          },
          goto_previous_end = {
            ["[F"] = "@function.outer",
            ["[C"] = "@class.outer",
          },
        },
      },

      -- Определение контекста (показывает в какой функции/классе находишься)
      context_commentstring = {
        enable = true,
        enable_autocmd = false,
      },
    })
  end,
}
