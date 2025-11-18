return {
	-- vim-dadbod: Database interaction
	{
		"tpope/vim-dadbod",
		cmd = { "DB" },
	},
	-- vim-dadbod-ui: Nice UI for database management
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			{ "tpope/vim-dadbod", lazy = true },
			{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
		},
		cmd = {
			"DBUI",
			"DBUIToggle",
			"DBUIAddConnection",
			"DBUIFindBuffer",
		},
		init = function()
			-- UI Configuration (must be set before plugin loads)
			vim.g.db_ui_use_nerd_fonts = 1
			vim.g.db_ui_show_database_icon = 1
			vim.g.db_ui_force_echo_notifications = 1
			vim.g.db_ui_win_position = "right"
			vim.g.db_ui_winwidth = 40

			-- Auto-execute queries on save
			vim.g.db_ui_execute_on_save = 0 -- Set to 1 to auto-execute

			-- Table helpers for multiple SQL dialects
			vim.g.db_ui_table_helpers = {
				postgresql = {
					Count = "SELECT COUNT(*) FROM {table}",
					Describe = "\\d+ {table}",
					["Show Indexes"] = "SELECT * FROM pg_indexes WHERE tablename = '{table}'",
				},
				mysql = {
					Count = "SELECT COUNT(*) FROM {table}",
					Describe = "DESCRIBE {table}",
					["Show Indexes"] = "SHOW INDEXES FROM {table}",
				},
				oracle = {
					Count = "SELECT COUNT(*) FROM {table}",
					Describe = "DESC {table}",
					["Show Indexes"] = "SELECT * FROM USER_INDEXES WHERE TABLE_NAME = UPPER('{table}')",
				},
				sqlserver = {
					Count = "SELECT COUNT(*) FROM {table}",
					Describe = "EXEC sp_help '{table}'",
					["Show Indexes"] = "EXEC sp_helpindex '{table}'",
				},
			}

			-- Default connection (optional - remove or modify as needed)
			-- Format examples:
			-- PostgreSQL: postgresql://user:password@localhost:5432/dbname
			-- MySQL: mysql://user:password@localhost:3306/dbname
			-- SQL Server: sqlserver://user:password@localhost:1433/dbname
			-- Oracle: oracle://user:password@localhost:1521/dbname
			-- SQLite: sqlite:path/to/database.db
			vim.g.dbs = {
				-- Example connections - modify or remove as needed
				-- { name = "dev_postgres", url = "postgresql://user:password@localhost:5432/mydb" },
				-- { name = "dev_mysql", url = "mysql://user:password@localhost:3306/mydb" },
				-- { name = "dev_sqlserver", url = "sqlserver://user:password@localhost:1433/mydb" },
			}
		end,
		config = function()
			-- Keymaps for DBUI
			vim.keymap.set("n", "<leader>db", "<cmd>DBUIToggle<CR>", { desc = "Toggle Database UI" })
			vim.keymap.set("n", "<leader>df", "<cmd>DBUIFindBuffer<CR>", { desc = "Find Database Buffer" })
			vim.keymap.set("n", "<leader>dr", "<cmd>DBUIRenameBuffer<CR>", { desc = "Rename Database Buffer" })
			vim.keymap.set("n", "<leader>dq", "<cmd>DBUILastQueryInfo<CR>", { desc = "Last Query Info" })

			-- Autocmd for SQL files to set up dadbod completion with blink.cmp
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "sql", "mysql", "plsql" },
				callback = function()
					-- Enable blink.cmp for SQL files with dadbod completion
					vim.b.blink_cmp_enabled = true

					-- Configure blink.cmp sources for this buffer
					-- Note: blink.cmp uses a different architecture than nvim-cmp
					-- vim-dadbod-completion works through omnifunc, which blink.cmp can use
				end,
			})
		end,
	},
	-- vim-dadbod-completion: Auto-completion for database tables/columns
	{
		"kristijanhusak/vim-dadbod-completion",
		ft = { "sql", "mysql", "plsql" },
		dependencies = { "saghen/blink.cmp" },
		config = function()
			-- Completion settings
			vim.g.vim_dadbod_completion_mark = "[DB]"
			vim.g.vim_dadbod_completion_replace_edit = 1
		end,
	},
}
