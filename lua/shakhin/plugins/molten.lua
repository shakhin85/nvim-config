return {
	-- Jupyter-like интерактивная разработка в Neovim
	{
		"benlubas/molten-nvim",
		version = "^1.0.0", -- используем последнюю стабильную версию
		ft = { "python", "jupyter" }, -- Lazy load only for Python and Jupyter files
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
			keymap.set(
				"v",
				"<leader>me",
				":<C-u>MoltenEvaluateVisual<CR>gv",
				{ desc = "Evaluate visual selection", silent = true }
			)
			keymap.set(
				"n",
				"<leader>mR",
				":MoltenReevaluateCell<CR>",
				{ desc = "Re-evaluate Molten cell", silent = true }
			) -- Changed from <leader>mr to avoid conflict with ruff format

			-- Навигация по ячейкам (changed from ]c/[c to avoid conflict with gitsigns)
			keymap.set("n", "]m", ":MoltenNext<CR>", { desc = "Next Molten cell", silent = true })
			keymap.set("n", "[m", ":MoltenPrev<CR>", { desc = "Previous Molten cell", silent = true })

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
		enabled = function()
			local is_headless = #vim.api.nvim_list_uis() == 0
			local is_windows = vim.fn.has("win32") == 1
			local is_wsl = vim.fn.has("wsl") == 1 or os.getenv("WSL_DISTRO_NAME") ~= nil
			local has_display = os.getenv("DISPLAY") ~= nil or os.getenv("WAYLAND_DISPLAY") ~= nil
			return not is_headless and not is_windows and not is_wsl and has_display
		end,
		config = function(_, opts)
			local ok, image = pcall(require, "image")
			if ok then
				image.setup(opts)
			else
				vim.notify("Failed to load image.nvim", vim.log.levels.WARN)
			end
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
		ft = { "python", "jupyter", "markdown" },
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
		ft = { "python", "jupyter" },
		priority = 1000, -- Load before NotebookNavigator to suppress warnings
		config = function()
			local Hydra = require("hydra")

			-- Suppress deprecation warning from NotebookNavigator's internal Hydra usage
			-- This needs to be set before any plugin uses Hydra
			local original_notify = vim.notify
			vim.notify = function(msg, level, opts)
				if
					type(msg) == "string"
					and (msg:match("hint%.border.*deprecated") or msg:match("has been deprecated"))
				then
					return -- Skip deprecation warnings
				end
				original_notify(msg, level, opts)
			end

			-- Configure global defaults for all Hydra instances
			-- Note: hint.border is deprecated, use hint.float_opts.border instead
			Hydra.setup({
				hint = {
					position = "bottom",
					float_opts = {
						border = "rounded",
						style = "minimal",
						focusable = false,
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
		ft = { "python", "jupyter" },
		keys = {
			{
				"]h",
				function()
					require("notebook-navigator").move_cell("d")
				end,
				desc = "Next cell",
			},
			{
				"[h",
				function()
					require("notebook-navigator").move_cell("u")
				end,
				desc = "Previous cell",
			},
			{ "<leader>mX", "<cmd>lua require('notebook-navigator').run_cells()<cr>", desc = "Run all cells" },
		},
		dependencies = {
			"echasnovski/mini.comment",
			"echasnovski/mini.ai",
			"GCBallesteros/jupytext.nvim",
			"nvimtools/hydra.nvim",
		},
		config = function()
			local nn = require("notebook-navigator")
			nn.setup({
				activate_hydra_keys = "<leader>mH", -- активировать hydra меню
				show_hydra_hint = true,
				-- Border configuration is handled globally in Hydra setup above
				-- Using float_opts instead of deprecated border option
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
