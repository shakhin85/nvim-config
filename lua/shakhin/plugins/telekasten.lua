return {
	"renerocksai/telekasten.nvim",
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local home = vim.fn.expand("~/zettelkasten")

		require("telekasten").setup({
			home = home,

			-- Основные папки
			dailies = home .. "/daily",
			weeklies = home .. "/weekly",
			templates = home .. "/templates",

			-- Формат имени файлов
			extension = ".md",

			-- Формат даты для daily notes
			dailies_create_nonexisting = true,
			weeklies_create_nonexisting = true,

			-- Шаблон для новых заметок
			template_new_note = home .. "/templates/new_note.md",
			template_new_daily = home .. "/templates/daily.md",
			template_new_weekly = home .. "/templates/weekly.md",

			-- Автоматическое создание заголовка
			new_note_filename = "title",
			uuid_type = "%Y%m%d%H%M",
			uuid_sep = "-",

			-- Настройки вставки ссылок
			follow_creates_nonexisting = true,

			-- Автокоррекция при вставке ссылок
			subdirs_in_links = true,

			-- Настройки календаря
			calendar_opts = {
				weeknm = 4,
				calendar_monday = 1,
				calendar_mark = "left-fit",
			},

			-- Интеграция с Telescope
			plug_into_calendar = true,
			calendar_monday = 1,

			-- Настройки изображений
			image_subdir = "img",

			-- Синтаксис ссылок
			media_previewer = "telescope-media-files",
			follow_url_fallback = nil,
		})

		-- Keymaps
		local keymap = vim.keymap

		-- Основные команды
		keymap.set("n", "<leader>zf", "<cmd>Telekasten find_notes<cr>", { desc = "Find notes" })
		keymap.set("n", "<leader>zg", "<cmd>Telekasten search_notes<cr>", { desc = "Search in notes" })
		keymap.set("n", "<leader>zd", "<cmd>Telekasten goto_today<cr>", { desc = "Go to today's note" })
		keymap.set("n", "<leader>zz", "<cmd>Telekasten follow_link<cr>", { desc = "Follow link" })
		keymap.set("n", "<leader>zn", "<cmd>Telekasten new_note<cr>", { desc = "New note" })
		keymap.set("n", "<leader>zc", "<cmd>Telekasten show_calendar<cr>", { desc = "Show calendar" })
		keymap.set("n", "<leader>zb", "<cmd>Telekasten show_backlinks<cr>", { desc = "Show backlinks" })
		keymap.set("n", "<leader>zI", "<cmd>Telekasten insert_img_link<cr>", { desc = "Insert image link" })

		-- Работа с тегами и ссылками
		keymap.set("n", "<leader>zt", "<cmd>Telekasten show_tags<cr>", { desc = "Show tags" })
		keymap.set("n", "<leader>z#", "<cmd>Telekasten show_tags<cr>", { desc = "Show tags" })
		keymap.set("n", "<leader>zT", "<cmd>Telekasten goto_thisweek<cr>", { desc = "Go to this week" })
		keymap.set("n", "<leader>zw", "<cmd>Telekasten goto_thisweek<cr>", { desc = "Go to this week" })
		keymap.set("n", "<leader>zW", "<cmd>Telekasten find_weekly_notes<cr>", { desc = "Find weekly notes" })

		-- Вставка ссылок
		keymap.set("n", "<leader>zl", "<cmd>Telekasten insert_link<cr>", { desc = "Insert link" })
		keymap.set("i", "[[", "<cmd>Telekasten insert_link<cr>", { desc = "Insert link" })

		-- Панель управления
		keymap.set("n", "<leader>zp", "<cmd>Telekasten panel<cr>", { desc = "Command panel" })

		-- Переименование
		keymap.set("n", "<leader>zr", "<cmd>Telekasten rename_note<cr>", { desc = "Rename note" })

		-- Просмотр медиа
		keymap.set("n", "<leader>zm", "<cmd>Telekasten preview_img<cr>", { desc = "Preview image" })

		-- Вставка изображения из base64 (для headless с lemonade)
		keymap.set("n", "<leader>zi", function()
			local img_dir = vim.fn.expand("~/zettelkasten/img")
			local timestamp = os.date("%Y%m%d-%H%M%S")
			local filename = "screenshot-" .. timestamp .. ".png"
			local filepath = img_dir .. "/" .. filename

			-- Создаем директорию если не существует
			vim.fn.mkdir(img_dir, "p")

			-- lemonade работает только с текстом, ожидаем base64
			if vim.fn.executable("lemonade") == 1 then
				-- Получаем base64 из буфера через lemonade и декодируем
				local cmd = string.format("lemonade paste | base64 -d > %s", vim.fn.shellescape(filepath))
				local result = os.execute(cmd)

				if result == 0 then
					local size = vim.fn.getfsize(filepath)
					if size > 0 then
						local link = string.format("![](img/%s)", filename)
						vim.api.nvim_put({link}, "c", true, true)
						vim.notify("Image saved: " .. filename .. " (" .. size .. " bytes)", vim.log.levels.INFO)
					else
						os.remove(filepath)
						vim.notify("Clipboard doesn't contain base64 image. Copy image as base64 on Windows first!", vim.log.levels.WARN)
					end
				else
					vim.notify("Failed to decode base64 from clipboard", vim.log.levels.ERROR)
				end
			else
				vim.notify("lemonade not found", vim.log.levels.ERROR)
			end
		end, { desc = "Paste image from base64 (lemonade)" })

		-- Вставка изображения по пути (альтернатива)
		keymap.set("n", "<leader>zI", function()
			-- Получаем путь из буфера
			local handle = io.popen("lemonade paste 2>/dev/null")
			if not handle then
				vim.notify("Failed to get path from clipboard", vim.log.levels.ERROR)
				return
			end

			local windows_path = handle:read("*a"):gsub("%s+$", "")
			handle:close()

			if windows_path == "" then
				vim.notify("Clipboard is empty", vim.log.levels.WARN)
				return
			end

			vim.notify("Path from clipboard: " .. windows_path, vim.log.levels.INFO)

			-- Даем возможность вставить ссылку вручную
			local filename = vim.fn.input("Image filename: ", "image.png")
			if filename ~= "" then
				local link = string.format("![](img/%s)", filename)
				vim.api.nvim_put({link}, "c", true, true)
				vim.notify("Link inserted. Copy image to ~/zettelkasten/img/" .. filename, vim.log.levels.INFO)
			end
		end, { desc = "Insert image link manually" })

		-- Навигация
		keymap.set("n", "<leader>z[", "<cmd>Telekasten toggle_todo<cr>", { desc = "Toggle todo" })
	end,
}
