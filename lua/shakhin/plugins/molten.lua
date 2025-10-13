return {
  -- Jupyter-like интерактивная разработка в Neovim
  {
    "benlubas/molten-nvim",
    version = "^1.0.0", -- используем последнюю стабильную версию
    dependencies = {
      -- image.nvim only works on Unix-like systems (Linux/macOS)
      vim.fn.has("win32") == 0 and "3rd/image.nvim" or nil,
    },
    build = ":UpdateRemotePlugins",
    init = function()
      -- Основные настройки
      vim.g.molten_output_win_max_height = 20 -- макс высота окна вывода
      vim.g.molten_auto_open_output = true -- автоматически показывать вывод
      vim.g.molten_wrap_output = true -- перенос строк в выводе
      vim.g.molten_virt_text_output = true -- показывать вывод как virtual text
      vim.g.molten_virt_lines_off_by_1 = true -- фикс для virtual lines

      -- Подсветка ячеек
      vim.g.molten_output_show_more = true -- показывать кнопку "показать больше"
      vim.g.molten_output_win_border = { "", "━", "", "" } -- граница окна вывода
      vim.g.molten_output_win_cover_gutter = true -- покрывать gutter

      -- Отображение изображений (only on Unix-like systems)
      if vim.fn.has("win32") == 0 then
        vim.g.molten_image_provider = "image.nvim"
      else
        vim.g.molten_image_provider = "none" -- disable images on Windows
      end
      vim.g.molten_use_border_highlights = true

      -- Сохранение вывода при скролле
      vim.g.molten_output_crop_border = true

      -- Автосохранение информации о ядре
      vim.g.molten_save_path = vim.fn.stdpath("data") .. "/molten"
    end,
    config = function()
      local keymap = vim.keymap

      -- Инициализация ядра
      keymap.set("n", "<leader>mi", ":MoltenInit<CR>", { desc = "Initialize Molten kernel", silent = true })

      -- Выполнение кода
      keymap.set("n", "<leader>me", ":MoltenEvaluateLine<CR>", { desc = "Evaluate line", silent = true })
      keymap.set("v", "<leader>me", ":<C-u>MoltenEvaluateVisual<CR>gv", { desc = "Evaluate visual selection", silent = true })
      keymap.set("n", "<leader>mr", ":MoltenReevaluateCell<CR>", { desc = "Re-evaluate cell", silent = true })

      -- Навигация по ячейкам
      keymap.set("n", "]c", ":MoltenNext<CR>", { desc = "Next Molten cell", silent = true })
      keymap.set("n", "[c", ":MoltenPrev<CR>", { desc = "Previous Molten cell", silent = true })

      -- Управление выводом
      keymap.set("n", "<leader>mo", ":MoltenShowOutput<CR>", { desc = "Show output", silent = true })
      keymap.set("n", "<leader>mh", ":MoltenHideOutput<CR>", { desc = "Hide output", silent = true })
      keymap.set("n", "<leader>md", ":MoltenDelete<CR>", { desc = "Delete Molten cell", silent = true })

      -- Прерывание выполнения
      keymap.set("n", "<leader>mx", ":MoltenInterrupt<CR>", { desc = "Interrupt kernel", silent = true })

      -- Информация о ядре
      keymap.set("n", "<leader>mk", ":MoltenInfo<CR>", { desc = "Molten kernel info", silent = true })

      -- Импорт/экспорт
      keymap.set("n", "<leader>ms", ":MoltenSave<CR>", { desc = "Save Molten session", silent = true })
      keymap.set("n", "<leader>ml", ":MoltenLoad<CR>", { desc = "Load Molten session", silent = true })

      -- Автокоманды для Python файлов
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "python", "jupyter" },
        callback = function()
          -- Дополнительные кеймапы только для Python
          vim.keymap.set("n", "<leader>mI", function()
            vim.cmd("MoltenInit python3")
          end, { desc = "Init Python3 kernel", buffer = true, silent = true })
        end,
      })

      -- Highlight groups для ячеек
      vim.api.nvim_set_hl(0, "MoltenCell", { link = "CursorLine" })
      vim.api.nvim_set_hl(0, "MoltenVirtualText", { link = "Comment" })
    end,
  },

  -- Image.nvim для отображения картинок (только Unix/Linux/macOS)
  {
    "3rd/image.nvim",
    cond = function()
      -- Не загружаем в headless режиме или на Windows
      -- image.nvim использует Unix-специфичные системные вызовы (ioctl)
      return not vim.g.headless and vim.fn.has("win32") == 0
    end,
    opts = {
      backend = "ueberzug",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
        },
      },
      max_width = 100,
      max_height = 12,
      max_height_window_percentage = math.huge,
      max_width_window_percentage = math.huge,
      window_overlap_clear_enabled = true,
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    },
  },

  -- Jupytext для работы с .ipynb файлами
  {
    "GCBallesteros/jupytext.nvim",
    config = function()
      require("jupytext").setup({
        style = "markdown", -- или "light", "percent", "hydrogen"
        output_extension = "md", -- конвертировать .ipynb в .md
        force_ft = "markdown", -- filetype для открытых файлов
      })
    end,
  },

  -- Hydra для интерактивного меню
  {
    "nvimtools/hydra.nvim",
    config = function()
      -- Configure Hydra to use the new API (hint.float_opts instead of hint.border)
      -- This prevents deprecation warnings
      local Hydra = require("hydra")
      -- Set default config to avoid deprecation warnings from dependencies
      Hydra.setup({
        hint = {
          float_opts = {
            border = "rounded",
          },
        },
      })
    end,
  },

  -- Mini.comment для NotebookNavigator
  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    opts = {},
  },

  -- Опционально: NotebookNavigator для лучшей навигации
  {
    "GCBallesteros/NotebookNavigator.nvim",
    keys = {
      { "]h", function() require("notebook-navigator").move_cell "d" end, desc = "Next cell" },
      { "[h", function() require("notebook-navigator").move_cell "u" end, desc = "Previous cell" },
      { "<leader>mX", "<cmd>lua require('notebook-navigator').run_cells()<cr>", desc = "Run all cells" },
    },
    dependencies = {
      "echasnovski/mini.comment",
      "echasnovski/mini.ai",
      "GCBallesteros/jupytext.nvim",
      "nvimtools/hydra.nvim",
    },
    event = "VeryLazy",
    config = function()
      local nn = require("notebook-navigator")
      nn.setup({
        activate_hydra_keys = "<leader>mH", -- активировать hydra меню
        show_hydra_hint = true,
        -- Use new Hydra API to avoid deprecation warnings
        hydra_opts = {
          hint = {
            float_opts = {
              border = "rounded",
            },
          },
        },
      })
    end,
  },
}
