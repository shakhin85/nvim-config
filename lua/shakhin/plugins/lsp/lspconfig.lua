return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
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
					keymap.set("n", "<leader>lf", function()
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

		-- Add folding capabilities for nvim-ufo
		capabilities.textDocument.foldingRange = {
			dynamicRegistration = false,
			lineFoldingOnly = true,
		}

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

		-- Helper function to find Python interpreter in .venv (cross-platform)
		local function get_python_path()
			local cwd = vim.fn.getcwd()
			local venv_python

			-- Detect OS and use appropriate path
			if vim.fn.has("win32") == 1 then
				-- Windows: use backslashes and proper path
				venv_python = cwd .. "\\.venv\\Scripts\\python.exe"
			else
				venv_python = cwd .. "/.venv/bin/python"
			end

			-- Check if .venv python exists
			if vim.fn.executable(venv_python) == 1 then
				return venv_python
			end

			-- Fallback: try to find python in PATH
			local python_cmd = vim.fn.has("win32") == 1 and "python" or "python3"
			if vim.fn.executable(python_cmd) == 1 then
				return python_cmd
			end

			-- Last resort: return nil
			return nil
		end

		-- Global LSP configuration with autocompletion
		vim.lsp.config("*", {
			capabilities = capabilities,
			-- Ensure consistent offset encoding
			offset_encoding = "utf-16",
		})

		-- Helper function to get Mason binary path (Windows-compatible)
		local function get_mason_bin(name)
			local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
			if vim.fn.has("win32") == 1 then
				return mason_bin .. "\\" .. name .. ".cmd"
			else
				return mason_bin .. "/" .. name
			end
		end

		-- Helper function to find tool in .venv first, then fall back to Mason
		local function get_tool_cmd(name)
			local cwd = vim.fn.getcwd()
			local venv_tool

			-- Check .venv first
			if vim.fn.has("win32") == 1 then
				venv_tool = cwd .. "\\.venv\\Scripts\\" .. name .. ".exe"
			else
				venv_tool = cwd .. "/.venv/bin/" .. name
			end

			if vim.fn.executable(venv_tool) == 1 then
				return venv_tool
			end

			-- Fall back to Mason
			return get_mason_bin(name)
		end

		-- Python configuration with .venv support
		vim.lsp.config("pyright", {
			cmd = { get_mason_bin("pyright-langserver"), "--stdio" },
			filetypes = { "python" },
			single_file_support = false,
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

		-- Ruff LSP server (linting and formatting via LSP)
		vim.lsp.config("ruff", {
			cmd = { get_tool_cmd("ruff"), "server" },
			filetypes = { "python" },
			single_file_support = false,
			settings = {
				-- Ruff LSP settings
				organizeImports = true,
				fixAll = true,
			},
			on_attach = function(client, bufnr)
				-- Disable hover in favor of Pyright
				client.server_capabilities.hoverProvider = false
			end,
		})

		-- Lua Language Server (simple approach from blink.cmp docs)
		vim.lsp.config("lua_ls", {
			cmd = { get_mason_bin("lua-language-server") },
			filetypes = { "lua" },
			settings = {
				Lua = {
					completion = {
						callSnippet = "Replace",
					},
					diagnostics = {
						globals = { "vim" },
					},
					runtime = {
						version = "LuaJIT",
					},
					workspace = {
						checkThirdParty = false,
						library = {
							"${3rd}/luv/library",
							unpack(vim.api.nvim_get_runtime_file("", true)),
						},
					},
					telemetry = {
						enable = false,
					},
					hint = {
						enable = true,
						setType = true,
					},
				},
			},
		})

		-- TypeScript/JavaScript
		vim.lsp.config("tsserver", {
			cmd = { get_mason_bin("typescript-language-server"), "--stdio" },
			filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
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
			cmd = { get_mason_bin("vscode-html-language-server"), "--stdio" },
			filetypes = { "html", "htmldjango", "templ" },
		})

		-- CSS
		vim.lsp.config("cssls", {
			cmd = { get_mason_bin("vscode-css-language-server"), "--stdio" },
			filetypes = { "css", "scss", "less" },
		})

		-- JSON
		vim.lsp.config("jsonls", {
			cmd = { get_mason_bin("vscode-json-language-server"), "--stdio" },
			filetypes = { "json", "jsonc" },
		})

		-- Rust (if needed)
		vim.lsp.config("rust_analyzer", {
			cmd = { get_mason_bin("rust-analyzer") },
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

		-- SQL (T-SQL)
		vim.lsp.config("sqls", {
			cmd = { get_mason_bin("sqls") },
			filetypes = { "sql", "mysql" },
		})

		-- Marksman (Markdown LSP - popular choice)
		vim.lsp.config("marksman", {
			cmd = { get_mason_bin("marksman"), "server" },
			filetypes = { "markdown", "markdown.mdx", "telekasten" },
			settings = {
				-- Marksman doesn't have many settings, it works well out of the box
			},
		})

		-- LTeX (Grammar and spell checker for Markdown and text)
		vim.lsp.config("ltex", {
			cmd = { get_mason_bin("ltex-ls") },
			filetypes = { "markdown", "text", "tex", "gitcommit", "telekasten" },
			settings = {
				ltex = {
					-- Set your language(s) - English by default, add "ru-RU" for Russian
					language = { "en-US", "ru-RU" },
					-- You can add multiple languages: language = "auto" or { "en-US", "ru-RU" }
					-- Additional languages you want to check
					additionalRules = {
						enablePickyRules = true,
						motherTongue = "en-US",
					},
					-- Dictionary for custom words (to avoid false positives)
					dictionary = {
						["en-US"] = {},
						-- ["ru-RU"] = {},
					},
					-- Disable rules if needed
					disabledRules = {
						["en-US"] = {},
						-- ["ru-RU"] = {},
					},
					-- Check only specific elements in Markdown
					markdown = {
						-- Don't check code blocks
						ignoreCodeBlocks = true,
					},
				},
			},
		})

		-- Enable all configured LSP servers (CRITICAL: without this, servers won't start!)
		vim.lsp.enable({
			"pyright",
			"ruff",
			"lua_ls",
			"tsserver",
			"html",
			"cssls",
			"jsonls",
			"rust_analyzer",
			"sqls",
			"marksman",
			"ltex",
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

		vim.api.nvim_create_user_command("RuffRestart", function()
			vim.cmd("LspRestart ruff")
		end, { desc = "Restart Ruff LSP" })

		-- Show Python tool paths
		vim.api.nvim_create_user_command("PythonToolInfo", function()
			print("Python Development Tools:")
			print("  Python: " .. (get_python_path() or "system python"))
			print("  Pyright: " .. get_mason_bin("pyright-langserver"))
			print("  Ruff: " .. get_tool_cmd("ruff"))

			local venv_ruff = vim.fn.getcwd()
				.. (vim.fn.has("win32") == 1 and "\\.venv\\Scripts\\ruff.exe" or "/.venv/bin/ruff")
			if vim.fn.executable(venv_ruff) == 1 then
				print("  → Using .venv ruff")
			else
				print("  → Using Mason ruff")
			end
		end, { desc = "Show Python development tool paths" })

		-- Добавлена команда для перезапуска lua_ls
		vim.api.nvim_create_user_command("LuaLsRestart", function()
			vim.cmd("LspRestart lua_ls")
		end, { desc = "Restart Lua Language Server" })

		-- Автоматический перезапуск Pyright при смене директории
		vim.api.nvim_create_autocmd("DirChanged", {
			callback = function()
				-- Проверяем, запущен ли Pyright в текущем буфере
				local clients = vim.lsp.get_clients({ name = "pyright" })
				if #clients > 0 then
					-- Перезапускаем Pyright для применения нового .venv
					vim.cmd("LspRestart pyright")
					vim.notify("Pyright restarted for new directory", vim.log.levels.INFO)
				end
			end,
			desc = "Restart Pyright when changing directory to detect new .venv",
		})
	end,
}
