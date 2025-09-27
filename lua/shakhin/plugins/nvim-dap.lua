-- ~/.config/nvim/lua/debug-config.lua
-- Максимально приближенная к PyCharm конфигурация дебаггера

return {
	-- DAP (Debug Adapter Protocol) настройки
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"igorlfs/nvim-dap-view",
			"theHamsta/nvim-dap-virtual-text",
			"mfussenegger/nvim-dap-python",
			"nvim-neotest/nvim-nio",
			"folke/neodev.nvim", -- Для лучшего автодополнения
		},
		config = function()
			local dap = require("dap")
			local dap_python = require("dap-python")

			-- Настройка Python дебаггера с автоопределением пути
			local function get_python_path()
				-- Приоритет: локальное venv > глобальное окружение > system
				if vim.fn.glob(vim.fn.getcwd() .. "/venv/bin/python") ~= "" then
					return vim.fn.getcwd() .. "/venv/bin/python"
				elseif vim.fn.glob(vim.fn.getcwd() .. "/.venv/bin/python") ~= "" then
					return vim.fn.getcwd() .. "/.venv/bin/python"
				elseif os.getenv("VIRTUAL_ENV") then
					return os.getenv("VIRTUAL_ENV") .. "/bin/python"
				else
					return "python3"
				end
			end

			dap_python.setup(get_python_path())

			-- Автоматическое определение Python адаптера
			dap.adapters.python = {
				type = "executable",
				command = get_python_path(),
				args = { "-m", "debugpy.adapter" },
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
					-- PyCharm-like exception handling
					stopOnEntry = false,
					justMyCode = true,
					-- Break on exceptions (like PyCharm)
					exceptionOptions = {
						{
							path = {
								{ label = "Python Exceptions", pattern = ".*" }
							},
							breakMode = "unhandled"
						}
					}
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

			-- Настройка nvim-dap-view (минималистичная замена nvim-dap-ui)
			require("dap-view").setup({
				winbar = {
					show = true,
					sections = { "watches", "exceptions", "breakpoints", "repl" },
					default_section = "watches"
				},
				windows = {
					height = 12, -- Компактная высота окна
					terminal = {
						position = "left",
						hide = {}, -- Адаптеры для скрытия терминала
						start_hidden = false
					}
				}
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

			-- nvim-dap-view автоматически управляет открытием/закрытием

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

			-- F-клавиши точно как в PyCharm
			map("n", "<F5>", function()
				-- Smart continue: start debugging if not started, otherwise continue
				if dap.session() then
					dap.continue()
				else
					-- Show configuration selection like PyCharm
					vim.ui.select(
						vim.tbl_map(function(config)
							return config.name
						end, dap.configurations.python or {}),
						{ prompt = "🚀 Select Debug Configuration: " },
						function(choice)
							if choice then
								for _, config in ipairs(dap.configurations.python or {}) do
									if config.name == choice then
										dap.run(config)
										break
									end
								end
							end
						end
					)
				end
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

			map("n", "<S-F8>", function()
				dap.step_out()
			end, { desc = "Debug: Step Out" })

			map("n", "<S-F5>", function()
				-- Proper cleanup and termination
				if dap.session() then
					dap.terminate()
					-- Close REPL if open
					dap.repl.close()
					-- Close dap-view if open
					require("dap-view").close()
					-- Clear virtual text
					vim.cmd("DapVirtualTextForceRefresh")
				end
			end, { desc = "Debug: Stop and Close All" })

			map("n", "<C-F5>", function()
				dap.restart()
			end, { desc = "Debug: Restart" })

			-- Force terminate with complete cleanup
			map("n", "<C-S-F5>", function()
				-- Force terminate everything related to debugging
				dap.terminate()
				dap.close()
				dap.repl.close()
				require("dap-view").close()
				-- Clear all breakpoints if needed
				-- dap.clear_breakpoints()
				-- Clear virtual text
				require("nvim-dap-virtual-text").refresh()
				-- Close any remaining debug windows
				for _, win in ipairs(vim.api.nvim_list_wins()) do
					local buf = vim.api.nvim_win_get_buf(win)
					local buftype = vim.api.nvim_buf_get_option(buf, 'buftype')
					if buftype == 'terminal' and vim.api.nvim_buf_get_name(buf):match('dap') then
						vim.api.nvim_win_close(win, true)
					end
				end
				print("🛑 Debug session completely terminated")
			end, { desc = "Debug: Force Stop All" })

			-- Breakpoints (PyCharm style)
			map("n", "<F9>", function()
				dap.toggle_breakpoint()
			end, { desc = "Debug: Toggle Breakpoint" })

			map("n", "<C-F8>", function()
				dap.set_breakpoint(vim.fn.input("🟡 Condition: "))
			end, { desc = "Debug: Conditional Breakpoint" })

			map("n", "<C-S-F8>", function()
				dap.set_breakpoint(nil, nil, vim.fn.input("📝 Log message: "))
			end, { desc = "Debug: Log Point" })

			-- nvim-dap-view управление (замена dapui)
			map("n", "<leader>du", function()
				require("dap-view").toggle()
			end, { desc = "Debug: Toggle View" })

			-- Quick terminate with leader key
			map("n", "<leader>dt", function()
				if dap.session() then
					dap.terminate()
					dap.repl.close()
					require("dap-view").close()
					require("nvim-dap-virtual-text").refresh()
					print("🛑 Debug session terminated")
				else
					print("ℹ️  No active debug session")
				end
			end, { desc = "Debug: Terminate Session" })
			map("n", "<leader>de", function()
				local word = vim.fn.expand("<cword>")
				if word ~= "" then
					require("dap-view").eval(word)
				else
					require("dap-view").eval()
				end
			end, { desc = "Debug: Evaluate" })
			map("v", "<leader>de", function()
				require("dap-view").eval()
			end, { desc = "Debug: Evaluate Selection" })

			-- Быстрый доступ к секциям nvim-dap-view
			map("n", "<leader>dw", function()
				require("dap-view").switch_to("watches")
			end, { desc = "Debug: Switch to Watches" })
			map("n", "<leader>db", function()
				require("dap-view").switch_to("breakpoints")
			end, { desc = "Debug: Switch to Breakpoints" })
			map("n", "<leader>dc", function()
				require("dap-view").switch_to("repl")
			end, { desc = "Debug: Switch to REPL" })

			-- REPL
			map("n", "<leader>dr", function()
				dap.repl.open()
			end, { desc = "Debug: Open REPL" })

			-- Python-specific debugging features
			map("n", "<leader>dpr", function()
				dap_python.test_method()
			end, { desc = "Debug: Python Test Method" })

			map("n", "<leader>dpc", function()
				dap_python.test_class()
			end, { desc = "Debug: Python Test Class" })

			map("n", "<leader>dps", function()
				dap_python.debug_selection()
			end, { desc = "Debug: Python Selection" })

			-- Run to cursor (like PyCharm)
			map("n", "<C-F10>", function()
				dap.run_to_cursor()
			end, { desc = "Debug: Run to Cursor" })

			-- Force step into (like PyCharm)
			map("n", "<A-F7>", function()
				dap.step_into({ askForTargets = true })
			end, { desc = "Debug: Force Step Into" })

			-- Evaluate expression (like PyCharm Alt+F8)
			map("n", "<A-F8>", function()
				local expr = vim.fn.input("Expression: ")
				if expr ~= "" then
					require("dap-view").eval(expr)
				end
			end, { desc = "Debug: Evaluate Expression" })

			-- Quick evaluate current word
			map("n", "<leader>dq", function()
				local word = vim.fn.expand("<cword>")
				if word ~= "" then
					require("dap-view").eval(word)
				end
			end, { desc = "Debug: Quick Evaluate" })

			-- Конфигурации запуска
			map("n", "<leader>dl", function()
				dap.run_last()
			end, { desc = "Debug: Run Last" })

			-- Show frames (switch to watches for stack info)
			map("n", "<C-F11>", function()
				require("dap-view").switch_to("watches")
			end, { desc = "Debug: Show Variables/Stack" })

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
			wk.add({
				{ "<F12>", desc = "Toggle Breakpoint" },
				{ "<F5>", desc = "Start/Continue" },
				{ "<F6>", desc = "Pause" },
				{ "<F7>", desc = "Step Into" },
				{ "<F8>", desc = "Step Over" },
				{ "<F9>", desc = "Step Out" },
				{ "<leader>d", group = "🐛 Debug" },
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
