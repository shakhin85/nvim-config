return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		-- import lsp capabilities
		local has_blink, blink = pcall(require, "blink.cmp")
		local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")

		local keymap = vim.keymap -- for conciseness

		-- Отключаем уведомления lua_ls о workspace
		vim.lsp.handlers["window/showMessage"] = function(_, result, ctx)
			-- Игнорируем сообщения от lua_ls о workspace
			local client = vim.lsp.get_client_by_id(ctx.client_id)
			if client and client.name == "lua_ls" and result.message:match("workspace is set to") then
				return
			end
			-- Показываем остальные уведомления
			vim.notify(result.message, vim.log.levels.INFO)
		end

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Buffer local mappings.
				local opts = { buffer = ev.buf, silent = true }

				-- set keybinds
				opts.desc = "Show LSP references"
				keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)
				opts.desc = "Go to declaration"
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
				opts.desc = "Show LSP definitions"
				keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
				opts.desc = "Show LSP implementations"
				keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
				opts.desc = "Show LSP type definitions"
				keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)
				opts.desc = "See available code actions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
				opts.desc = "Smart rename"
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
				opts.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)
				opts.desc = "Show line diagnostics"
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
				opts.desc = "Go to previous diagnostic"
				keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
				opts.desc = "Go to next diagnostic"
				keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
				opts.desc = "Show documentation for what is under cursor"
				keymap.set("n", "K", vim.lsp.buf.hover, opts)
				opts.desc = "Restart LSP"
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)

				-- Python-specific keymaps
				if vim.bo.filetype == "python" then
					opts.desc = "Format Python file"
					keymap.set("n", "<leader>f", function()
						vim.lsp.buf.format({ async = true })
					end, opts)
					opts.desc = "Organize imports"
					keymap.set("n", "<leader>oi", function()
						vim.lsp.buf.code_action({
							context = { only = { "source.organizeImports" } },
							apply = true,
						})
					end, opts)
				end
			end,
		})

		-- used to enable autocompletion (assign to every lsp server config)
		local capabilities
		if has_blink then
			capabilities = blink.get_lsp_capabilities()
		elseif has_cmp then
			capabilities = cmp_nvim_lsp.default_capabilities()
		else
			capabilities = vim.lsp.protocol.make_client_capabilities()
		end

		-- Force UTF-16 offset encoding for all LSP servers to avoid conflicts
		capabilities.offsetEncoding = { "utf-16" }

		-- Diagnostic signs configuration
		vim.diagnostic.config({
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN] = " ",
					[vim.diagnostic.severity.HINT] = "󰠠 ",
					[vim.diagnostic.severity.INFO] = " ",
				},
			},
		})

		-- Helper function to find Python interpreter in .venv
		local function get_python_path()
			local cwd = vim.fn.getcwd()
			local venv_python = cwd .. "/.venv/bin/python"

			-- Check if .venv/bin/python exists
			if vim.fn.executable(venv_python) == 1 then
				return venv_python
			end

			-- Fallback to system python
			return nil
		end

		-- Global LSP configuration with autocompletion
		vim.lsp.config("*", {
			capabilities = capabilities,
			-- Ensure consistent offset encoding
			offset_encoding = "utf-16",
		})

		-- Python configuration with .venv support
		vim.lsp.config("pyright", {
			settings = {
				python = {
					analysis = {
						typeCheckingMode = "basic",
						autoSearchPaths = true,
						useLibraryCodeForTypes = true,
						autoImportCompletions = true,
						diagnosticMode = "workspace",
					},
					-- Set Python path to .venv if available
					pythonPath = get_python_path(),
				},
			},
			on_init = function(client)
				-- Dynamically set pythonPath when LSP initializes
				local python_path = get_python_path()
				if python_path then
					client.config.settings.python.pythonPath = python_path
					client:notify("workspace/didChangeConfiguration", { settings = client.config.settings })
				end
			end,
		})

		-- Lua Language Server (исправленная конфигурация)
		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					-- make the language server recognize "vim" global
					diagnostics = {
						globals = { "vim" },
					},
					completion = {
						callSnippet = "Replace",
					},
					workspace = {
						-- Используем только runtime файлы Neovim
						library = {
							vim.env.VIMRUNTIME,
							"${3rd}/luv/library",
						},
						-- Отключаем проверку сторонних библиотек
						checkThirdParty = false,
						-- Игнорируем проблемные директории
						ignoreDir = {
							".git",
							"node_modules",
							".vscode",
							".idea",
							"target",
							"build",
							"dist",
						},
						-- Ограничиваем сканирование только нужными директориями
						maxPreload = 2000,
						preloadFileSize = 1000,
					},
					telemetry = {
						enable = false,
					},
					-- Отключаем ненужные предупреждения
					hint = {
						enable = false,
					},
				},
			},
		})

		-- TypeScript/JavaScript
		vim.lsp.config("tsserver", {
			settings = {
				typescript = {
					inlayHints = {
						includeInlayParameterNameHints = "all",
					},
				},
				javascript = {
					inlayHints = {
						includeInlayParameterNameHints = "all",
					},
				},
			},
		})

		-- HTML
		vim.lsp.config("html", {
			filetypes = { "html", "htmldjango", "templ" },
		})

		-- CSS
		vim.lsp.config("cssls", {
			filetypes = { "css", "scss", "less" },
		})

		-- JSON
		vim.lsp.config("jsonls", {
			filetypes = { "json", "jsonc" },
		})

		-- Rust (if needed)
		vim.lsp.config("rust_analyzer", {
			settings = {
				["rust-analyzer"] = {
					cargo = {
						allFeatures = true,
					},
					checkOnSave = {
						command = "clippy",
					},
				},
			},
		})

		-- Note: Copilot LSP is managed by copilot.lua plugin, not lspconfig

		-- Commands for Python development
		vim.api.nvim_create_user_command("PythonPath", function()
			local python_path = get_python_path()
			if python_path then
				print("Using Python from .venv:", python_path)
			else
				print("Using system Python (no .venv found)")
			end
		end, { desc = "Show current Python path" })

		vim.api.nvim_create_user_command("PyrightRestart", function()
			vim.cmd("LspRestart pyright")
		end, { desc = "Restart Pyright LSP" })

		-- Добавлена команда для перезапуска lua_ls
		vim.api.nvim_create_user_command("LuaLsRestart", function()
			vim.cmd("LspRestart lua_ls")
		end, { desc = "Restart Lua Language Server" })
	end,
}
