return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		-- import mason
		local mason = require("mason")
		-- import mason-lspconfig
		local mason_lspconfig = require("mason-lspconfig")
		local mason_tool_installer = require("mason-tool-installer")

		-- enable mason and configure icons
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_lspconfig.setup({
			-- list of servers for mason to install
			ensure_installed = {
				"pyright", -- Python LSP
				"ts_ls", -- TypeScript/JavaScript LSP (updated name)
				"html", -- HTML LSP
				"cssls", -- CSS LSP
				"tailwindcss", -- Tailwind CSS LSP
				"svelte", -- Svelte LSP
				"lua_ls", -- Lua LSP
				"graphql", -- GraphQL LSP
				"emmet_ls", -- Emmet LSP
				"prismals", -- Prisma LSP
				"eslint", -- ESLint LSP
				"jsonls", -- JSON LSP
				"rust_analyzer", -- Rust LSP (если нужен)
			},
			-- ВАЖНО: НЕ настраиваем обработчики здесь
			-- Пусть lspconfig.lua через vim.lsp.config() управляет настройкой
			automatic_installation = true,
		})

		mason_tool_installer.setup({
			ensure_installed = {
				-- Formatters
				"prettier", -- prettier formatter for JS/TS/HTML/CSS
				"stylua", -- lua formatter
				"black", -- python formatter
				"isort", -- python import formatter

				-- Linters
				"pylint", -- python linter
				"eslint_d", -- javascript/typescript linter
				"ruff", -- fast python linter/formatter

				-- Python tools
				"debugpy", -- python debugger
				"mypy", -- python type checker
			},
		})

		-- Команды для управления Mason
		vim.api.nvim_create_user_command("MasonInstallPython", function()
			vim.cmd("MasonInstall pyright black isort pylint ruff debugpy mypy")
		end, { desc = "Install Python development tools" })

		vim.api.nvim_create_user_command("MasonUpdateAll", function()
			vim.cmd("MasonUpdate")
		end, { desc = "Update all Mason packages" })
	end,
}
