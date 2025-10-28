return {
	{
		"mfussenegger/nvim-dap",
		lazy = true,
	},
	{
		"mfussenegger/nvim-dap-python",
		dependencies = { "mfussenegger/nvim-dap" },
		ft = "python",
		build = false,
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

			-- Enhanced Python DAP configurations
			local dap = require("dap")
			dap.configurations.python = {
				{
					type = "python",
					request = "launch",
					name = "🚀 Launch current file",
					program = "${file}",
					console = "integratedTerminal",
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
					justMyCode = true,
				},
				{
					type = "python",
					request = "launch",
					name = "⚙️  Launch with arguments",
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
					request = "launch",
					name = "🧪 Launch with pytest",
					module = "pytest",
					args = { "${file}", "-v", "-s" },
					console = "integratedTerminal",
					cwd = "${workspaceFolder}",
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
			}
		end,
	},
	-- NOTE: cmp-dap removed because we use blink.cmp instead of nvim-cmp
	-- Buffer-local keymaps for dap-view are configured in the autocmd below
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
						label = "🔴  Breakpoints [B]",
						short_label = "🔴 [B]",
						action = function()
							require("dap-view.views").switch_to_view("breakpoints")
						end,
					},
					scopes = {
						keymap = "S",
						label = "🔍  Variables [S]",
						short_label = "🔍 [S]",
						action = function()
							require("dap-view.views").switch_to_view("scopes")
						end,
					},
					exceptions = {
						keymap = "E",
						label = "⚠️  Exceptions [E]",
						short_label = "⚠️ [E]",
						action = function()
							require("dap-view.views").switch_to_view("exceptions")
						end,
					},
					watches = {
						keymap = "W",
						label = "👁️  Watches [W]",
						short_label = "👁️ [W]",
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
						label = "📟 Console [C]",
						short_label = "📟 [C]",
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
				pause = "⏸️  ",
				play = "▶️  ",
				run_last = "🔄",
				step_back = "⬅️  ",
				step_into = "⬇️  ",
				step_out = "⬆️  ",
				step_over = "➡️  ",
				terminate = "⏹️  ",
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
				desc = "👁️  Show Watches",
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
				desc = "ℹ️  Hover Info",
			},
			{
				"<leader>dp",
				function()
					require("dap.ui.widgets").preview()
				end,
				desc = "🔎 Preview",
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
		config = function(_, opts)
			require("dap-view").setup(opts)

			-- Define DAP signs for breakpoints and current line
			vim.fn.sign_define("DapBreakpoint", {
				text = "🔴",
				texthl = "DiagnosticError",
				linehl = "",
				numhl = "DiagnosticError",
			})
			vim.fn.sign_define("DapBreakpointCondition", {
				text = "🟡",
				texthl = "DiagnosticWarn",
				linehl = "",
				numhl = "DiagnosticWarn",
			})
			vim.fn.sign_define("DapBreakpointRejected", {
				text = "⭕",
				texthl = "DiagnosticInfo",
				linehl = "",
				numhl = "DiagnosticInfo",
			})
			vim.fn.sign_define("DapLogPoint", {
				text = "💬",
				texthl = "DiagnosticInfo",
				linehl = "",
				numhl = "DiagnosticInfo",
			})
			vim.fn.sign_define("DapStopped", {
				text = "👉",
				texthl = "DiagnosticHint",
				linehl = "CursorLine",
				numhl = "DiagnosticHint",
			})

			-- Buffer-local keymaps for dap-view windows to override global Tab/Shift-Tab
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "dap-view", "dap-view-term", "dap-view-help" },
				callback = function(args)
					local buf = args.buf

					-- Normal mode: Tab to navigate within dap-view (sections/items)
					vim.keymap.set("n", "<Tab>", function()
						-- In dap-view, Tab should move to next item/section
						vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("j", true, false, true), "n", false)
					end, { buffer = buf, desc = "Next item in DAP view" })

					vim.keymap.set("n", "<S-Tab>", function()
						-- Shift-Tab should move to previous item/section
						vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("k", true, false, true), "n", false)
					end, { buffer = buf, desc = "Previous item in DAP view" })

					-- Enter to expand/select items
					vim.keymap.set("n", "<CR>", function()
						vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", false)
					end, { buffer = buf, desc = "Select/expand item in DAP view" })
				end,
			})

			-- Special configuration for dap-repl with blink.cmp support
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "dap-repl",
				callback = function(args)
					local buf = args.buf
					local opts_local = { buffer = buf, silent = true }

					-- In Normal mode: Tab enters Insert mode at end of line
					vim.keymap.set("n", "<Tab>", function()
						vim.cmd("normal! A")
					end, vim.tbl_extend("force", opts_local, { desc = "Enter insert mode for REPL input" }))

					-- In Insert mode: Tab for completion with blink.cmp
					vim.keymap.set("i", "<Tab>", function()
						-- Check if blink.cmp menu is visible
						local blink = require("blink.cmp")
						if blink then
							-- Just use regular Tab behavior - blink.cmp handles completion
							vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
						else
							-- Fallback to regular Tab
							vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
						end
					end, vim.tbl_extend("force", opts_local, { desc = "Trigger completion or insert Tab" }))

					-- Shift-Tab: disable BufferLine navigation in Normal mode
					vim.keymap.set("n", "<S-Tab>", function()
						-- Do nothing - avoid buffer switching in REPL
					end, vim.tbl_extend("force", opts_local, { desc = "Disabled in REPL" }))

					-- -- History navigation
					-- vim.keymap.set("i", "<C-p>", "<Up>", vim.tbl_extend("force", opts_local, { desc = "Previous command" }))
					-- vim.keymap.set("i", "<C-n>", "<Down>", vim.tbl_extend("force", opts_local, { desc = "Next command" }))

					-- Clear REPL
					local function clear_repl()
						local dap = require("dap")
						if dap.session() then
							vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
							vim.api.nvim_win_set_cursor(0, { 1, 0 })
							print("🧹 REPL cleared")
							if vim.fn.mode() == "i" then
								vim.cmd("startinsert")
							end
						else
							print("⚠️  No active debug session")
						end
					end

					vim.keymap.set({ "n", "i" }, "<C-c>", clear_repl, vim.tbl_extend("force", opts_local, { desc = "Clear REPL" }))
					vim.keymap.set({ "n", "i" }, "<leader>rc", clear_repl, vim.tbl_extend("force", opts_local, { desc = "Clear REPL" }))
				end,
			})
		end,
	},
}
