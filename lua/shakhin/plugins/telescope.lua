return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    "folke/todo-comments.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local transform_mod = require("telescope.actions.mt").transform_mod
    local trouble = require("trouble")
    local trouble_telescope = require("trouble.sources.telescope")
    
    -- or create your custom action
    local custom_actions = transform_mod({
      open_trouble_qflist = function(prompt_bufnr)
        trouble.toggle("quickfix")
      end,
    })
    
    telescope.setup({
      defaults = {
        path_display = { "smart" },
        -- Основные оптимизации производительности
        file_ignore_patterns = {
          "node_modules/",
          ".git/",
          ".cache/",
          "%.o",
          "%.a",
          "%.out",
          "%.class",
          "%.pdf",
          "%.mkv",
          "%.mp4",
          "%.zip",
          "%.tar.gz",
          "%.tar.xz",
          "%.exe",
          "%.dll",
          "%.so",
          "%.dylib",
          "__pycache__/",
          "%.pyc",
          ".DS_Store",
          "Thumbs.db",
        },
        -- Ограничение количества результатов
        results_limit = 1000,
        -- Более быстрый поиск
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",
          "--no-ignore-vcs", -- Ускоряет поиск, но может показать больше файлов
        },
        -- Отключение превью для файлов больше определенного размера
        preview = {
          filesize_limit = 0.1, -- MB
          timeout = 250, -- ms
        },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-q>"] = actions.send_selected_to_qflist + custom_actions.open_trouble_qflist,
            ["<C-t>"] = trouble_telescope.open,
            ["<C-y>"] = function(prompt_bufnr)
              local selection = require("telescope.actions.state").get_selected_entry()
              if selection then
                local full_path = selection.path or selection.filename
                if full_path then
                  -- Получаем абсолютный путь
                  full_path = vim.fn.fnamemodify(full_path, ":p")
                  -- Копируем в системный буфер обмена
                  vim.fn.setreg("+", full_path)
                  -- Показываем уведомление
                  vim.notify("Copied to clipboard: " .. full_path, vim.log.levels.INFO)
                end
              end
            end,
            -- ["<C-y>"] = function(prompt_bufnr)
            --   local entry = action_state.get_selected_entry()
            --   vim.fn.setreg("+", entry.path)   -- копирует в системный буфер (Ctrl+V потом)
            --   print("Copied: " .. entry.path)  -- выводит сообщение
            -- end,
          },
        },
        -- Оптимизации для больших директорий
        sorting_strategy = "ascending",
        layout_config = {
          prompt_position = "top",
          preview_cutoff = 40,
        },
        -- Кеширование
        cache_picker = {
          num_pickers = 10,
        },
      },
      pickers = {
        find_files = {
          -- Используем fd вместо find для лучшей производительности
          find_command = { "fd", "--type", "f", "--hidden", "--follow", "--exclude", ".git" },
          -- Ограничиваем глубину поиска
          follow = true,
          hidden = false,
        },
        live_grep = {
          -- Дополнительные аргументы для rg
          additional_args = function()
            return { "--hidden", "--follow" }
          end,
          -- Ограничение по размеру файлов для grep
          max_results = 1000,
        },
        oldfiles = {
          -- Ограничиваем количество недавних файлов
          cwd_only = true,
        },
        grep_string = {
          additional_args = function()
            return { "--hidden", "--follow" }
          end,
        },
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
      },
    })
    
    telescope.load_extension("fzf")
    
    -- Дополнительные кеймапы с опциями для больших директорий
    local keymap = vim.keymap
    
    -- Стандартные кеймапы
    keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
    keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
    keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
    keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
    keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
    keymap.set("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "Find keymaps" })
    
    -- Дополнительные оптимизированные кеймапы
    keymap.set("n", "<leader>fF", function()
      require('telescope.builtin').find_files({
        no_ignore = false,
        hidden = false,
        file_ignore_patterns = { "node_modules/", ".git/", "*.log", "*.tmp" },
      })
    end, { desc = "Find files (fast mode)" })
    
    keymap.set("n", "<leader>fG", function()
      require('telescope.builtin').live_grep({
        additional_args = { "--max-depth", "3" }, -- Ограничиваем глубину
      })
    end, { desc = "Live grep (limited depth)" })
    
    -- Поиск только в текущей директории (без рекурсии)
    keymap.set("n", "<leader>f.", function()
      require('telescope.builtin').find_files({
        cwd = vim.fn.expand('%:p:h'),
        search_dirs = { vim.fn.expand('%:p:h') },
      })
    end, { desc = "Find files in current directory" })
  end,
}
