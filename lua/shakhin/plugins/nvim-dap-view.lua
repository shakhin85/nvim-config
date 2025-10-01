return {
	{
		"mfussenegger/nvim-dap",
		lazy = true,
	},
	{
		"mfussenegger/nvim-dap-python",
		dependencies = { "mfussenegger/nvim-dap" },
		ft = "python",
		config = function()
			local function find_python_path()
				local cwd = vim.fn.getcwd()

				-- 1. Ищем .venv в текущей директории
				local venv_paths = {
					cwd .. "/.venv/bin/python",
					cwd .. "/.venv/Scripts/python.exe", -- Windows
					cwd .. "/venv/bin/python",
					cwd .. "/venv/Scripts/python.exe", -- Windows
				}

				for _, path in ipairs(venv_paths) do
					if vim.fn.executable(path) == 1 then
						print("Using virtual environment Python: " .. path)
						return path
					end
				end

				-- 2. Ищем глобальное окружение
				local global_paths = {
					vim.fn.expand("~/.pyenv/shims/python"),
					vim.fn.expand("~/anaconda3/bin/python"),
					vim.fn.expand("~/miniconda3/bin/python"),
				}

				for _, path in ipairs(global_paths) do
					if vim.fn.executable(path) == 1 then
						print("Using global environment Python: " .. path)
						return path
					end
				end

				-- 3. Системный Python
				local system_paths = { "python3", "python", "python3.11", "python3.10", "python3.9" }

				for _, cmd in ipairs(system_paths) do
					local path = vim.fn.exepath(cmd)
					if path ~= "" then
						print("Using system Python: " .. path)
						return path
					end
				end

				vim.notify("Python interpreter not found!", vim.log.levels.ERROR)
				return "python3"
			end

			local python_path = find_python_path()
			require("dap-python").setup(python_path)
		end,
	},
	{
		"rcarriga/cmp-dap",
		dependencies = {
			"hrsh7th/nvim-cmp",
			"mfussenegger/nvim-dap",
		},
		config = function()
			local cmp = require("cmp")

			-- Автодополнение для всех DAP-view буферов и DAP REPL
			cmp.setup.filetype({
				"dap-view", -- Основные панели (Breakpoints, Exceptions, Sessions, Scopes, Threads, Watches)
				"dap-view-term", -- Терминал
				"dap-view-help", -- Помощь
				"dap-repl", -- REPL (от nvim-dap)
			}, {
				sources = cmp.config.sources({
					{ name = "dap" },
				}, {
					{ name = "buffer" },
				}),
				completion = {
					autocomplete = {
						cmp.TriggerEvent.TextChanged,
					},
					keyword_length = 0,
				},
				mapping = {
					-- Навигация через Ctrl+J/K
					["<C-j>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						else
							fallback()
						end
					end, { "i", "s" }),

					["<C-k>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						else
							fallback()
						end
					end, { "i", "s" }),

					-- Tab для автодополнения после точки и вставки
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.confirm({ select = true })
						else
							-- Проверяем, есть ли точка перед курсором
							local line = vim.api.nvim_get_current_line()
							local col = vim.api.nvim_win_get_cursor(0)[2]
							local before_cursor = string.sub(line, 1, col)

							-- Если есть точка или символы идентификатора, запускаем автодополнение
							if string.match(before_cursor, "[%w_]%.$") or string.match(before_cursor, "[%w_]+$") then
								cmp.complete()
							else
								fallback()
							end
						end
					end, { "i", "s" }),

					-- Enter для подтверждения
					["<CR>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.confirm({ select = true })
						else
							fallback()
						end
					end, { "i", "s" }),

					-- Дополнительные удобные маппинги
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
				},
				formatting = {
					format = function(entry, vim_item)
						local icons = {
							dap = "🐛",
							buffer = "📝",
						}
						vim_item.kind = (icons[entry.source.name] or "•") .. " " .. vim_item.kind
						vim_item.menu = ({
							dap = "[Debug Variables]",
							buffer = "[Buffer Text]",
						})[entry.source.name]
						return vim_item
					end,
				},
				window = {
					completion = cmp.config.window.bordered({
						border = "rounded",
					}),
					documentation = cmp.config.window.bordered({
						border = "rounded",
					}),
				},
				experimental = {
					ghost_text = true,
				},
			})

			-- Автокоманды для улучшения поведения в DAP буферах
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "dap-view", "dap-view-term", "dap-view-help", "dap-repl" },
				callback = function()
					-- Включаем автодополнение при вводе точки
					vim.api.nvim_create_autocmd("TextChangedI", {
						buffer = 0,
						callback = function()
							local line = vim.api.nvim_get_current_line()
							local col = vim.api.nvim_win_get_cursor(0)[2]
							local before_cursor = string.sub(line, col, col)

							-- Автоматически показывать автодополнение после точки
							if before_cursor == "." then
								vim.defer_fn(function()
									if vim.api.nvim_get_mode().mode == "i" then
										cmp.complete()
									end
								end, 100)
							end
						end,
					})
				end,
			})
		end,
	},
	{
		"igorlfs/nvim-dap-view",
		dependencies = { "mfussenegger/nvim-dap" },
		---@module 'dap-view'
		---@type dapview.Config
		opts = {
			winbar = {
				show = true,
				sections = { "scopes", "watches", "breakpoints", "threads", "console", "repl" },
				default_section = "scopes",
				base_sections = {
					breakpoints = {
						keymap = "B",
						label = "🔴 Breakpoints [B]",
						short_label = "🔴 [B]",
						action = function()
							require("dap-view.views").switch_to_view("breakpoints")
						end,
					},
					scopes = {
						keymap = "S",
						label = "🔍 Variables [S]",
						short_label = "🔍 [S]",
						action = function()
							require("dap-view.views").switch_to_view("scopes")
						end,
					},
					exceptions = {
						keymap = "E",
						label = "⚠️  Exceptions [E]",
						short_label = "⚠️  [E]",
						action = function()
							require("dap-view.views").switch_to_view("exceptions")
						end,
					},
					watches = {
						keymap = "W",
						label = "👀 Watches [W]",
						short_label = "👀 [W]",
						action = function()
							require("dap-view.views").switch_to_view("watches")
						end,
					},
					threads = {
						keymap = "T",
						label = "🧵 Threads [T]",
						short_label = "🧵 [T]",
						action = function()
							require("dap-view.views").switch_to_view("threads")
						end,
					},
					repl = {
						keymap = "R",
						label = "💻 REPL [R]",
						short_label = "💻 [R]",
						action = function()
							require("dap-view.repl").show()
						end,
					},
					console = {
						keymap = "C",
						label = "📺 Console [C]",
						short_label = "📺 [C]",
						action = function()
							require("dap-view.views").switch_to_view("console")
						end,
					},
				},
				custom_sections = {
					logs = {
						keymap = "L",
						label = "📋 Debug Logs [L]",
						short_label = "📋 [L]",
						action = function()
							vim.cmd("messages")
						end,
					},
				},
				controls = {
					enabled = true,
					position = "left",
					buttons = {
						"play",
						"step_over",
						"step_into",
						"step_out",
						"terminate",
						"run_last",
					},
					custom_buttons = {
						restart = {
							icon = "🔄",
							action = function()
								require("dap").restart()
							end,
							tooltip = "Restart debugging session",
						},
					},
				},
			},
			windows = {
				height = 0.3,
				position = "below",
				terminal = {
					width = 0.6,
					position = "right",
					hide = {},
					start_hidden = false,
				},
			},
			icons = {
				disabled = "⭕",
				disconnect = "🔌",
				enabled = "✅",
				filter = "🔍",
				negate = "❌",
				pause = "⏸️ ",
				play = "▶️ ",
				run_last = "🔄",
				step_back = "⬅️ ",
				step_into = "⬇️ ",
				step_out = "⬆️ ",
				step_over = "➡️ ",
				terminate = "⏹️ ",
			},
			help = {
				border = "rounded",
			},
			switchbuf = "useopen,usetab",
			auto_toggle = true,
			follow_tab = true,
		},
		keys = {
			-- Основные команды отладки
			{
				"<F5>",
				function()
					require("dap").continue()
				end,
				desc = "▶️  Debug: Continue",
			},
			{
				"<F6>",
				function()
					require("dap").pause()
				end,
				desc = "⏸️  Debug: Pause",
			},
			{
				"<F10>",
				function()
					require("dap").step_over()
				end,
				desc = "➡️  Debug: Step Over",
			},
			{
				"<F11>",
				function()
					require("dap").step_into()
				end,
				desc = "⬇️  Debug: Step Into",
			},
			{
				"<F12>",
				function()
					require("dap").step_out()
				end,
				desc = "⬆️  Debug: Step Out",
			},

			-- Breakpoints
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "🔴 Toggle Breakpoint",
			},
			{
				"<leader>dB",
				function()
					require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
				end,
				desc = "🔴 Conditional Breakpoint",
			},
			{
				"<leader>dc",
				function()
					require("dap").clear_breakpoints()
				end,
				desc = "🗑️  Clear All Breakpoints",
			},

			-- DAP View управление
			{
				"<leader>dv",
				function()
					require("dap-view").toggle()
				end,
				desc = "👁️  Toggle DAP View",
			},
			{
				"<leader>ds",
				function()
					require("dap-view.views").switch_to_view("scopes")
				end,
				desc = "🔍 Show Variables",
			},
			{
				"<leader>dw",
				function()
					require("dap-view.views").switch_to_view("watches")
				end,
				desc = "👀 Show Watches",
			},
			{
				"<leader>dr",
				function()
					require("dap-view.repl").show()
				end,
				desc = "💻 Open REPL",
			},

			-- Сессии и контроль
			{
				"<leader>dt",
				function()
					require("dap").terminate()
				end,
				desc = "⏹️  Terminate",
			},
			{
				"<leader>dl",
				function()
					require("dap").run_last()
				end,
				desc = "🔄 Run Last",
			},
			{
				"<leader>dR",
				function()
					require("dap").restart()
				end,
				desc = "🔄 Restart Session",
			},

			-- Дополнительные удобства
			{
				"<leader>de",
				function()
					require("dap").set_exception_breakpoints()
				end,
				desc = "⚠️  Exception Breakpoints",
			},
			{
				"<leader>dh",
				function()
					require("dap.ui.widgets").hover()
				end,
				desc = "❓ Hover Info",
			},
			{
				"<leader>dp",
				function()
					require("dap.ui.widgets").preview()
				end,
				desc = "👁️  Preview",
			},

			-- Отладочная функция для проверки filetype
			{
				"<leader>dft",
				function()
					print("Current filetype: " .. vim.bo.filetype)
					print("Buffer type: " .. vim.bo.buftype)
				end,
				desc = "🔍 Debug filetype",
			},
		},
	},
}
