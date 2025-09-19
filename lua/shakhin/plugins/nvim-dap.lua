-- ~/.config/nvim/lua/debug-config.lua
-- Максимально приближенная к PyCharm конфигурация дебаггера

return {
	-- DAP (Debug Adapter Protocol) настройки
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"mfussenegger/nvim-dap-python",
			"nvim-neotest/nvim-nio",
			"folke/neodev.nvim", -- Для лучшего автодополнения
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			local dap_python = require("dap-python")

			-- Настройка Python дебаггера с поддержкой uv
			dap_python.setup("uv run python")

			-- Автоматическое определение Python из uv
			dap.adapters.python = {
				type = "executable",
				command = "uv",
				args = { "run", "python", "-m", "debugpy.adapter" },
				options = {
					source_filetype = "python",
				},
			}

			-- Конфигурации для различных сценариев (как в PyCharm)
			dap.configurations.python = {
				{
					type = "python",
					request = "launch",
					name = "🚀 Launch current file",
					program = "${file}",
					console = "integratedTerminal",
					cwd = "${workspaceFolder}",
					env = function()
						local variables = {}
						for k, v in pairs(vim.fn.environ()) do
							variables[k] = v
						end
						return variables
					end,
				},
				{
					type = "python",
					request = "launch",
					name = "🧪 Launch with pytest",
					module = "pytest",
					args = { "${file}", "-v", "-s" },
					console = "integratedTerminal",
					cwd = "${workspaceFolder}",
				},
				{
					type = "python",
					request = "launch",
					name = "⚡ Launch with arguments",
					program = "${file}",
					console = "integratedTerminal",
					cwd = "${workspaceFolder}",
					args = function()
						local args_string = vim.fn.input("Arguments: ")
						return vim.split(args_string, " ")
					end,
				},
				{
					type = "python",
					request = "attach",
					name = "🔗 Attach to process",
					connect = function()
						local host = vim.fn.input("Host [127.0.0.1]: ")
						host = host ~= "" and host or "127.0.0.1"
						local port = tonumber(vim.fn.input("Port [5678]: ")) or 5678
						return { host = host, port = port }
					end,
				},
				{
					type = "python",
					request = "launch",
					name = "🌐 Django",
					program = vim.fn.getcwd() .. "/manage.py",
					args = { "runserver", "--noreload" },
					console = "integratedTerminal",
					cwd = "${workspaceFolder}",
				},
				{
					type = "python",
					request = "launch",
					name = "⚡ FastAPI",
					module = "uvicorn",
					args = { "main:app", "--reload" },
					console = "integratedTerminal",
					cwd = "${workspaceFolder}",
				},
			}

			-- Настройка UI (максимально похоже на PyCharm)
			dapui.setup({
				controls = {
					element = "repl",
					enabled = true,
					icons = {
						disconnect = "⏹ ",
						pause = "⏸ ",
						play = "▶ ",
						run_last = "🔄",
						step_back = "◀ ",
						step_into = "⬇ ",
						step_out = "⬆ ",
						step_over = "➡ ",
						terminate = "⏹ ",
					},
				},
				element_mappings = {},
				expand_lines = true,
				floating = {
					border = "rounded",
					mappings = {
						close = { "q", "<Esc>" },
					},
				},
				force_buffers = true,
				icons = {
					collapsed = "▶",
					current_frame = "▶",
					expanded = "▼",
				},
				layouts = {
					{
						-- Левая панель (как в PyCharm)
						elements = {
							{ id = "scopes", size = 0.4 }, -- Variables
							{ id = "breakpoints", size = 0.2 }, -- Breakpoints
							{ id = "stacks", size = 0.4 }, -- Call Stack
						},
						position = "left",
						size = 50,
					},
					{
						-- Нижняя панель
						elements = {
							{ id = "repl", size = 0.6 }, -- Console/REPL
							{ id = "console", size = 0.4 }, -- Debug Console
						},
						position = "bottom",
						size = 15,
					},
				},
				mappings = {
					edit = "e",
					expand = { "<CR>", "<2-LeftMouse>" },
					open = "o",
					remove = "d",
					repl = "r",
					toggle = "t",
				},
				render = {
					indent = 1,
					max_value_lines = 100,
				},
			})

			-- Виртуальный текст для значений переменных (как в PyCharm)
			require("nvim-dap-virtual-text").setup({
				enabled = true,
				enabled_commands = true,
				highlight_changed_variables = true,
				highlight_new_as_changed = false,
				show_stop_reason = true,
				commented = false,
				only_first_definition = true,
				all_references = false,
				clear_on_continue = false,
				display_callback = function(variable, buf, stackframe, node, options)
					if options.virt_text_pos == "inline" then
						return " = " .. variable.value
					else
						return variable.name .. " = " .. variable.value
					end
				end,
				virt_text_pos = vim.fn.has("nvim-0.10") == 1 and "inline" or "eol",
				all_frames = false,
				virt_lines = false,
				virt_text_win_col = nil,
			})

			-- Автоматическое открытие/закрытие UI
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			-- Кастомные знаки для breakpoints (как в PyCharm)
			vim.fn.sign_define("DapBreakpoint", {
				text = "🔴",
				texthl = "DapBreakpoint",
				linehl = "",
				numhl = "",
			})
			vim.fn.sign_define("DapBreakpointCondition", {
				text = "🟡",
				texthl = "DapBreakpointCondition",
				linehl = "",
				numhl = "",
			})
			vim.fn.sign_define("DapBreakpointRejected", {
				text = "❌",
				texthl = "DapBreakpointRejected",
				linehl = "",
				numhl = "",
			})
			vim.fn.sign_define("DapLogPoint", {
				text = "📝",
				texthl = "DapLogPoint",
				linehl = "",
				numhl = "",
			})
			vim.fn.sign_define("DapStopped", {
				text = "➡️",
				texthl = "DapStopped",
				linehl = "DapStoppedLine",
				numhl = "",
			})

			-- Хоткеи максимально похожие на PyCharm
			local function map(mode, lhs, rhs, opts)
				opts = opts or {}
				opts.silent = opts.silent ~= false
				vim.keymap.set(mode, lhs, rhs, opts)
			end

			-- F-клавиши как в PyCharm
			map("n", "<F5>", function()
				dap.continue()
			end, { desc = "Debug: Start/Continue" })
			map("n", "<F6>", function()
				dap.pause()
			end, { desc = "Debug: Pause" })
			map("n", "<F7>", function()
				dap.step_into()
			end, { desc = "Debug: Step Into" })
			map("n", "<F8>", function()
				dap.step_over()
			end, { desc = "Debug: Step Over" })
			map("n", "<F9>", function()
				dap.step_out()
			end, { desc = "Debug: Step Out" })
			map("n", "<S-F5>", function()
				dap.terminate()
			end, { desc = "Debug: Stop" })
			map("n", "<C-F5>", function()
				dap.restart()
			end, { desc = "Debug: Restart" })

			-- Breakpoints
			map("n", "<F12>", function()
				dap.toggle_breakpoint()
			end, { desc = "Debug: Toggle Breakpoint" })
			map("n", "<S-F12>", function()
				dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end, { desc = "Debug: Set Conditional Breakpoint" })
			map("n", "<C-S-F12>", function()
				dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
			end, { desc = "Debug: Set Log Point" })

			-- UI управление
			map("n", "<leader>du", function()
				dapui.toggle()
			end, { desc = "Debug: Toggle UI" })
			map("n", "<leader>de", function()
				dapui.eval()
			end, { desc = "Debug: Evaluate" })
			map("v", "<leader>de", function()
				dapui.eval()
			end, { desc = "Debug: Evaluate Selection" })

			-- Быстрый доступ к элементам UI
			map("n", "<leader>dv", function()
				dapui.toggle({ layout = 1 })
			end, { desc = "Debug: Toggle Variables" })
			map("n", "<leader>dc", function()
				dapui.toggle({ layout = 2 })
			end, { desc = "Debug: Toggle Console" })

			-- REPL
			map("n", "<leader>dr", function()
				dap.repl.open()
			end, { desc = "Debug: Open REPL" })

			-- Конфигурации запуска
			map("n", "<leader>dl", function()
				dap.run_last()
			end, { desc = "Debug: Run Last" })
			map("n", "<leader>ds", function()
				dap.continue({
					before = function()
						vim.ui.select(
							vim.tbl_map(function(config)
								return config.name
							end, dap.configurations.python),
							{ prompt = "Select configuration: " },
							function(choice)
								if choice then
									for _, config in ipairs(dap.configurations.python) do
										if config.name == choice then
											dap.run(config)
											break
										end
									end
								end
							end
						)
					end,
				})
			end, { desc = "Debug: Select Configuration" })

			-- Команды для установки debugpy через uv
			vim.api.nvim_create_user_command("DebugPyInstall", function()
				vim.fn.system("uv add debugpy --dev")
				print("debugpy installed via uv")
			end, { desc = "Install debugpy via uv" })

			-- Проверка установки debugpy
			vim.api.nvim_create_user_command("DebugPyCheck", function()
				local result = vim.fn.system('uv run python -c "import debugpy; print(debugpy.__version__)"')
				if vim.v.shell_error == 0 then
					print("debugpy is installed: " .. result:gsub("\n", ""))
				else
					print("debugpy is not installed. Run :DebugPyInstall")
				end
			end, { desc = "Check debugpy installation" })
		end,
	},

	-- Дополнительные плагины для улучшения опыта отладки
	{
		"folke/which-key.nvim",
		config = function()
			local wk = require("which-key")
			wk.register({
				["<leader>d"] = { name = "🐛 Debug" },
				["<F5>"] = "Start/Continue",
				["<F6>"] = "Pause",
				["<F7>"] = "Step Into",
				["<F8>"] = "Step Over",
				["<F9>"] = "Step Out",
				["<F12>"] = "Toggle Breakpoint",
			})
		end,
	},

	-- Для лучшего отображения ошибок и предупреждений
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = true,
	},
}
