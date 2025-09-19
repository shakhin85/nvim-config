return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- Жирный баннер NVIM
    dashboard.section.header.val = {
      "███╗   ██╗██╗   ██╗██╗███╗   ███╗",
      "████╗  ██║██║   ██║██║████╗ ████║",
      "██╔██╗ ██║██║   ██║██║██╔████╔██║",
      "██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║",
      "██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║",
      "╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝",
      "                                 ",
      "         Welcome Shakhin         ",
    }

    -- Меню кнопок
    dashboard.section.buttons.val = {
	    dashboard.button("e",      "   > Новый файл", "<cmd>ene<CR>"),
	    dashboard.button("SPC ff", "󰱼   > Поиск файла", "<cmd>Telescope find_files<CR>"),
	    dashboard.button("SPC fs", "   > Поиск текста", "<cmd>Telescope live_grep<CR>"),
	    dashboard.button("SPC ee", "   > Файловый менеджер", "<cmd>NvimTreeToggle<CR>"),
	    dashboard.button("SPC wr", "󰁯   > Восстановить сессию", "<cmd>SessionRestore<CR>"),
	    dashboard.button("q",      "   > Выйти", "<cmd>qa<CR>"),
    }

    -- Футер с инфой о плагинах и версии
    local lazy_stats = require("lazy").stats()
    dashboard.section.footer.val = " Neovim v" ..
      vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch ..
      "  ⚡ " .. lazy_stats.loaded .. "/" .. lazy_stats.count .. " plugins loaded"

    dashboard.section.footer.opts.hl = "Comment"

    -- Запуск
    alpha.setup(dashboard.opts)

    -- Отключаем сворачивание
    vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
  end,
}

