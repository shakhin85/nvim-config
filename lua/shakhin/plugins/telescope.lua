return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    "folke/todo-comments.nvim",
    "nvim-telescope/telescope-smart-history.nvim",
    "kkharji/sqlite.lua",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local transform_mod = require("telescope.actions.mt").transform_mod
    local trouble = require("trouble")
    local trouble_telescope = require("trouble.sources.telescope")
    local entry_display = require("telescope.pickers.entry_display")

    -- Функция для форматирования даты
    local function format_date(timestamp)
      return os.date("%Y-%m-%d %H:%M", timestamp)
    end

    -- Кастомный entry_maker для показа даты модификации
    local function make_entry_with_mtime(opts)
      opts = opts or {}
      local make_entry = require("telescope.make_entry")
      local base_entry = make_entry.gen_from_file(opts)

      local displayer = entry_display.create({
        separator = " ",
        items = {
          { width = 19 }, -- Дата
          { remaining = true }, -- Имя файла
        },
      })

      return function(line)
        local entry = base_entry(line)
        if not entry then
          return nil
        end

        -- Получаем время модификации файла
        local stat = vim.loop.fs_stat(entry.path)
        local mtime = stat and stat.mtime.sec or 0
        local date_str = format_date(mtime)

        entry.display = function(ent)
          return displayer({
            { date_str, "TelescopeResultsNumber" },
            entry.ordinal,
          })
        end

        return entry
      end
    end
    
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
          "%.lock",
          "package%-lock%.json",
          "yarn%.lock",
        },
        -- КРИТИЧНО: Уменьшил лимит для ускорения на больших директориях
        results_limit = 300,
        -- КРИТИЧНО: Respects .gitignore (убрал --no-ignore-vcs) + добавил --max-filesize
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",
          "--max-filesize=1M", -- Игнорирует файлы > 1MB
        },
        -- Превью быстрее
        preview = {
          filesize_limit = 0.5, -- MB
          timeout = 200, -- ms
          treesitter = false, -- Отключает treesitter в превью для скорости
        },
        -- КРИТИЧНО: Debounce для live_grep (задержка перед началом поиска)
        debounce = 200, -- ms (увеличено для больших директорий)
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
        -- История поиска
        history = {
          path = vim.fn.stdpath("data") .. "/telescope_history.sqlite3",
          limit = 100,
        },
      },
      pickers = {
        find_files = {
          -- Режим для системного поиска (включая бинарники)
          find_command = {
            "fd",
            "--type", "f",
            "--hidden",
            "--follow",
            "--exclude", ".git",
            "--max-depth", "15",
            -- Без ограничения по размеру для поиска бинарников
          },
          follow = true,
          hidden = false,
          previewer = false, -- Отключаем preview для бинарников
          entry_maker = make_entry_with_mtime(), -- Показываем дату модификации
        },
        live_grep = {
          -- КРИТИЧНО: Ограничения для ускорения на больших директориях
          additional_args = function()
            return {
              "--hidden",
              "--follow",
              "--max-depth=10", -- Ограничение глубины
            }
          end,
          max_results = 300, -- Уменьшил с 1000
          -- Отключаем превью по умолчанию для скорости
          previewer = false,
        },
        oldfiles = {
          -- Ограничиваем количество недавних файлов
          cwd_only = true,
        },
        grep_string = {
          additional_args = function()
            return {
              "--hidden",
              "--follow",
              "--max-depth=10",
            }
          end,
          max_results = 300,
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
    telescope.load_extension("smart_history")
    
    -- Дополнительные кеймапы с опциями для больших директорий
    local keymap = vim.keymap
    
    -- ОСНОВНЫЕ КЕЙМАПЫ (для системного поиска, включая бинарники)
    keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files (любой размер, depth 15)" })
    keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
    keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep (depth 10)" })
    keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor" })
    keymap.set("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "Find keymaps" })

    -- REGEX поиск файлов по имени
    keymap.set("n", "<leader>fR", function()
      require('telescope.builtin').find_files({
        find_command = {
          "fd",
          "--type", "f",
          "--regex",  -- включает regex режим
          "--hidden",
          "--follow",
          "--exclude", ".git",
          "--max-depth", "15",
        },
        prompt_title = "Find Files (REGEX)",
        entry_maker = make_entry_with_mtime(),
        previewer = false,
      })
    end, { desc = "Find files by REGEX pattern" })

    -- ПОЛНЫЕ КЕЙМАПЫ (для поиска бинарников, больших файлов, без ограничений)
    keymap.set("n", "<leader>fF", function()
      require('telescope.builtin').find_files({
        find_command = {
          "fd",
          "--type", "f",
          "--hidden",
          "--follow",
          "--exclude", ".git",
          -- БЕЗ ограничений по размеру и глубине!
        },
        previewer = false, -- Отключаем превью для скорости
        entry_maker = make_entry_with_mtime(), -- Показываем дату модификации
      })
    end, { desc = "Find ALL files (FULL: any size, any depth)" })

    keymap.set("n", "<leader>fG", function()
      require('telescope.builtin').live_grep({
        additional_args = function()
          return {
            "--hidden",
            "--follow",
            -- БЕЗ --max-depth
            "--max-filesize=100M", -- Но файлы > 100MB все равно пропускаем
          }
        end,
        max_results = 1000,
      })
    end, { desc = "Live grep (FULL: any depth, <100MB)" })

    -- СПЕЦИАЛЬНЫЕ РЕЖИМЫ
    -- Поиск только в текущей директории (без рекурсии)
    keymap.set("n", "<leader>f.", function()
      require('telescope.builtin').find_files({
        cwd = vim.fn.expand('%:p:h'),
        search_dirs = { vim.fn.expand('%:p:h') },
        entry_maker = make_entry_with_mtime(), -- Показываем дату модификации
      })
    end, { desc = "Find files in current directory" })

    -- Поиск бинарников и больших файлов (без текстовых ограничений)
    keymap.set("n", "<leader>fb", function()
      require('telescope.builtin').find_files({
        find_command = {
          "fd",
          "--type", "f",
          "--hidden",
          "--follow",
          "--exclude", ".git",
          "--size", "+100k", -- Только файлы > 100KB (вероятно бинарники)
        },
        previewer = false,
        entry_maker = make_entry_with_mtime(), -- Показываем дату модификации
      })
    end, { desc = "Find binaries (>100KB)" })
  end,
}
