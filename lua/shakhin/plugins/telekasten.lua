return {
  "renerocksai/telekasten.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-telescope/telescope-media-files.nvim",
  },
  config = function()
    local home = vim.fn.expand("~/zettelkasten")

    require("telekasten").setup({
      home = home,

      -- if true, telekasten will be enabled when opening a note within the configured home
      take_over_my_home = true,

      -- auto-set telekasten filetype: if false, the telekasten filetype will not be used
      auto_set_filetype = true,

      -- dir names for special notes (absolute path or subdir name)
      dailies = home .. "/" .. "daily",
      weeklies = home .. "/" .. "weekly",
      templates = home .. "/" .. "templates",

      -- image subdir for pasting
      image_subdir = "img",

      -- markdown file extension
      extension = ".md",

      -- Generate note filenames. One of:
      -- "title" (default) - Use title if given, uuid otherwise
      -- "uuid" - Use uuid
      -- "uuid-title" - Use uuid-title
      new_note_filename = "title",

      -- file uuid type ("rand" or input for os.date()")
      uuid_type = "%Y%m%d%H%M",

      -- UUID separator
      uuid_sep = "-",

      -- following a link to a non-existing note will create it
      follow_creates_nonexisting = true,
      dailies_create_nonexisting = true,
      weeklies_create_nonexisting = true,

      -- skip telescope prompt for goto_today and goto_thisweek
      journal_auto_open = false,

      -- template for new notes (new_note, follow_link)
      template_new_note = home .. "/" .. "templates/new_note.md",

      -- template for newly created daily notes
      template_new_daily = home .. "/" .. "templates/daily.md",

      -- template for newly created weekly notes
      template_new_weekly = home .. "/" .. "templates/weekly.md",

      -- image link style
      -- wiki:     ![[image name]]
      -- markdown: ![](image_subdir/xxxxx.png)
      image_link_style = "markdown",

      -- default sort option: 'filename', 'modified'
      sort = "filename",

      -- integrate with calendar-vim
      plug_into_calendar = true,
      calendar_opts = {
        weeknm = 4,
        calendar_monday = 1,
        calendar_mark = "left-fit",
      },

      -- telescope actions behavior
      close_after_yanking = false,
      insert_after_inserting = true,

      -- tag notation: '#tag', ':tag:', 'yaml-bare'
      tag_notation = "#tag",

      -- command palette theme: dropdown (window) or ivy (bottom panel)
      command_palette_theme = "ivy",

      -- tag list theme:
      show_tags_theme = "ivy",

      -- when linking to a note in subdir/, create a [[subdir/title]] link
      -- instead of a [[title only]] link
      subdirs_in_links = true,

      -- template_handling
      -- What to do when creating a new note via `new_note()` or `follow_link()`
      -- to a non-existing note
      -- - prefer_new_note: use `new_note` template
      -- - smart: if day or week is detected in title, use daily / weekly templates (default)
      -- - always_ask: always ask before creating a note
      template_handling = "smart",

      -- path handling:
      --   this applies to:
      --   - new_note()
      --   - new_templated_note()
      --   - follow_link() to non-existing note
      --
      --   it does NOT apply to:
      --   - goto_today()
      --   - goto_thisweek()
      --
      --   Valid options:
      --   - smart: put daily-looking notes in daily, weekly-looking ones in weekly,
      --            all other ones in home, except for notes/with/subdirs/in/title.
      --            (default)
      --   - prefer_home: put all notes in home except for goto_today(), goto_thisweek()
      --                  except for notes with subdirs/in/title.
      --   - same_as_current: put all new notes in the dir of the current note if
      --                      present or else in home
      --                      except for notes/with/subdirs/in/title.
      new_note_location = "smart",

      -- should all links be updated when a file is renamed
      rename_update_links = true,

      -- how to preview media files
      -- "telescope-media-files" if you have telescope-media-files.nvim installed
      -- "catimg-previewer" if you have catimg installed
      -- "viu-previewer" if you have viu installed
      media_previewer = "telescope-media-files",

      -- A customizable fallback handler for urls.
      follow_url_fallback = nil,

      -- Specify a clipboard program to use (for image pasting on Windows)
      clipboard_program = "powershell",
    })

    -- Load telescope-media-files extension
    require("telescope").load_extension("media_files")

    -- Keymaps
    local keymap = vim.keymap.set

    -- Panel and search
    keymap("n", "<leader>zf", "<cmd>Telekasten find_notes<cr>", { desc = "Find notes" })
    keymap("n", "<leader>zg", "<cmd>Telekasten search_notes<cr>", { desc = "Search notes (grep)" })
    keymap("n", "<leader>zd", "<cmd>Telekasten goto_today<cr>", { desc = "Go to today's note" })
    keymap("n", "<leader>zz", "<cmd>Telekasten follow_link<cr>", { desc = "Follow link" })
    keymap("n", "<leader>zT", "<cmd>Telekasten goto_thisweek<cr>", { desc = "Go to this week's note" })
    keymap("n", "<leader>zw", "<cmd>Telekasten find_weekly_notes<cr>", { desc = "Find weekly notes" })
    keymap("n", "<leader>zn", "<cmd>Telekasten new_note<cr>", { desc = "New note" })
    keymap("n", "<leader>zN", "<cmd>Telekasten new_templated_note<cr>", { desc = "New templated note" })
    keymap("n", "<leader>zy", "<cmd>Telekasten yank_notelink<cr>", { desc = "Yank note link" })
    keymap("n", "<leader>zc", "<cmd>Telekasten show_calendar<cr>", { desc = "Show calendar" })
    keymap("n", "<leader>zC", "<cmd>CalendarT<cr>", { desc = "Show calendar (full)" })
    keymap("n", "<leader>zi", "<cmd>Telekasten paste_img_and_link<cr>", { desc = "Paste image and link" })
    keymap("n", "<leader>zt", "<cmd>Telekasten toggle_todo<cr>", { desc = "Toggle TODO" })
    keymap("n", "<leader>zb", "<cmd>Telekasten show_backlinks<cr>", { desc = "Show backlinks" })
    keymap("n", "<leader>zF", "<cmd>Telekasten find_friends<cr>", { desc = "Find friends (notes with same tags)" })
    keymap("n", "<leader>zI", "<cmd>Telekasten insert_img_link<cr>", { desc = "Insert image link" })
    keymap("n", "<leader>zp", "<cmd>Telekasten preview_img<cr>", { desc = "Preview image" })
    keymap("n", "<leader>zm", "<cmd>Telekasten browse_media<cr>", { desc = "Browse media" })
    keymap("n", "<leader>za", "<cmd>Telekasten show_tags<cr>", { desc = "Show all tags" })
    keymap("n", "<leader>z#", "<cmd>Telekasten search_by_tag<cr>", { desc = "Search by tag" })
    keymap("n", "<leader>zr", "<cmd>Telekasten rename_note<cr>", { desc = "Rename note" })

    -- Insert mode: quickly create a link
    keymap("i", "[[", "<cmd>Telekasten insert_link<cr>", { desc = "Insert link" })

    -- Panel
    keymap("n", "<leader>zP", "<cmd>Telekasten panel<cr>", { desc = "Command panel" })

    -- Calendar integration
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "calendar",
      callback = function()
        keymap("n", "<CR>", "<cmd>Telekasten goto_today<cr>", { buffer = true, desc = "Go to daily note" })
      end,
    })
  end,
}
