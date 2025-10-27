return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "hrsh7th/nvim-cmp", -- Требуется для автодополнения Obsidian
  },
  config = function()
    require("obsidian").setup({
      workspaces = {
        {
          name = "zettelkasten",
          path = "~/zettelkasten",
        },
      },

      -- Optional: путь к daily notes
      daily_notes = {
        folder = "daily",
        date_format = "%Y-%m-%d",
        alias_format = "%B %-d, %Y",
        template = nil,
      },

      -- Автодополнение для ссылок через nvim-cmp
      completion = {
        nvim_cmp = true,
        min_chars = 2,
      },

      -- Формат новых заметок
      note_id_func = function(title)
        local suffix = ""
        if title ~= nil then
          suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return tostring(os.time()) .. "-" .. suffix
      end,

      -- Настройки для создания новых заметок
      note_frontmatter_func = function(note)
        local out = { id = note.id, aliases = note.aliases, tags = note.tags }

        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end

        return out
      end,

      -- Папка для вложений
      attachments = {
        img_folder = "img",
      },

      -- Настройки UI
      ui = {
        enable = true,
        checkboxes = {
          [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
          ["x"] = { char = "", hl_group = "ObsidianDone" },
        },
        bullets = { char = "•", hl_group = "ObsidianBullet" },
        external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
        reference_text = { hl_group = "ObsidianRefText" },
        highlight_text = { hl_group = "ObsidianHighlightText" },
        tags = { hl_group = "ObsidianTag" },
      },

      -- Шаблоны
      templates = {
        subdir = "templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
      },

      -- Интеграция с Telescope
      picker = {
        name = "telescope.nvim",
        mappings = {
          new = "<C-x>",
          insert_link = "<C-l>",
        },
      },

      -- Открывать ссылки в браузере
      follow_url_func = function(url)
        vim.fn.jobstart({ "cmd.exe", "/c", "start", url })
      end,
    })

    -- Keymaps
    local keymap = vim.keymap

    -- Основные команды
    keymap.set("n", "<leader>on", "<cmd>ObsidianNew<cr>", { desc = "New note" })
    keymap.set("n", "<leader>oo", "<cmd>ObsidianQuickSwitch<cr>", { desc = "Quick switch" })
    keymap.set("n", "<leader>of", "<cmd>ObsidianSearch<cr>", { desc = "Search notes" })
    keymap.set("n", "<leader>od", "<cmd>ObsidianToday<cr>", { desc = "Today's note" })
    keymap.set("n", "<leader>oy", "<cmd>ObsidianYesterday<cr>", { desc = "Yesterday's note" })
    keymap.set("n", "<leader>ot", "<cmd>ObsidianTomorrow<cr>", { desc = "Tomorrow's note" })

    -- Работа со ссылками
    keymap.set("n", "<leader>ol", "<cmd>ObsidianLink<cr>", { desc = "Link to note" })
    keymap.set("n", "<leader>oL", "<cmd>ObsidianLinkNew<cr>", { desc = "Link to new note" })
    keymap.set("n", "<leader>ob", "<cmd>ObsidianBacklinks<cr>", { desc = "Show backlinks" })
    keymap.set("n", "<leader>og", "<cmd>ObsidianFollowLink<cr>", { desc = "Follow link" })

    -- Работа с тегами и поиском
    keymap.set("n", "<leader>os", "<cmd>ObsidianTags<cr>", { desc = "Search tags" })
    keymap.set("n", "<leader>ow", "<cmd>ObsidianWorkspace<cr>", { desc = "Switch workspace" })

    -- Шаблоны
    keymap.set("n", "<leader>oT", "<cmd>ObsidianTemplate<cr>", { desc = "Insert template" })

    -- Открыть в Obsidian
    keymap.set("n", "<leader>oO", "<cmd>ObsidianOpen<cr>", { desc = "Open in Obsidian app" })

    -- Создание чекбокса
    keymap.set("n", "<leader>oc", "<cmd>ObsidianToggleCheckbox<cr>", { desc = "Toggle checkbox" })

    -- Переименование
    keymap.set("n", "<leader>or", "<cmd>ObsidianRename<cr>", { desc = "Rename note" })
  end,
}
