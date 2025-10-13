return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		-- Add Mason bin directory to PATH for formatters
		local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
		if vim.fn.isdirectory(mason_bin) == 1 then
			vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
		end

		conform.setup({
			formatters_by_ft = {
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				svelte = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				mdx = { "prettier" },
				markdown = { "prettier" },
				graphql = { "prettier" },
				liquid = { "prettier" },
				lua = { "stylua" },
				python = { "isort", "black" },
				sql = { "sqlfluff" },
			},
			format_on_save = {
				lsp_fallback = true,
				async = false,
				timeout_ms = 3000,
			},
		})

		vim.keymap.set({ "n", "v" }, "<leader>Fp", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format file or range (in visual mode)" })

		-- Autopep8 formatting keymap
		vim.keymap.set({ "n", "v" }, "<leader>Fa", function()
			print("Formatting with autopep8...")
			conform.format({
				formatters = { "autopep8" },
				lsp_fallback = false,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format Python file with autopep8" })

		-- Ruff formatting keymap
		vim.keymap.set({ "n", "v" }, "<leader>Fr", function()
			print("Formatting with ruff...")
			conform.format({
				formatters = { "ruff_format" },
				lsp_fallback = false,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format Python file with ruff" })

		-- Simple MDX formatter function
		local function format_mdx(text)
			-- Normalize spaces
			local formatted = text:gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")

			-- Break into tokens and rebuild with proper formatting
			formatted = formatted:gsub("SELECT%s+", "SELECT\n")
			formatted = formatted:gsub("%s+ON%s+COLUMNS", "\nON COLUMNS")
			formatted = formatted:gsub("%s+ON%s+ROWS", "\nON ROWS")
			formatted = formatted:gsub("DIMENSION%s+PROPERTIES", "DIMENSION PROPERTIES")
			formatted = formatted:gsub("%s+FROM%s+", "\nFROM ")

			-- Handle braces and parens - don't break content inside
			formatted = formatted:gsub("({", "(\n{")
			formatted = formatted:gsub("})", "}\n)")

			-- Process line by line with indentation
			local lines = vim.split(formatted, "\n")
			local result = {}
			local indent = 0

			for _, line in ipairs(lines) do
				line = line:gsub("^%s+", ""):gsub("%s+$", "")

				if line ~= "" then
					-- Count braces/parens for indent changes
					local open_count = 0
					local close_count = 0

					-- Check if line starts with closing
					if line:match("^[})]") then
						close_count = 1
					end

					-- Adjust indent before adding line
					indent = math.max(0, indent - close_count)

					-- Add the line
					table.insert(result, string.rep("    ", indent) .. line)

					-- Count opens and closes in the line
					for c in line:gmatch("[{(]") do
						open_count = open_count + 1
					end
					for c in line:gmatch("[})]") do
						if not line:match("^[})]") then -- don't count already processed closing
							close_count = close_count + 1
						end
					end

					-- Adjust indent after line
					indent = indent + open_count - close_count
				end
			end

			return result
		end

		-- SQL/MDX formatting in visual mode
		vim.keymap.set("v", "<leader>Fs", function()
			local start_line = vim.fn.line("'<")
			local end_line = vim.fn.line("'>")
			local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

			-- Detect and remove common leading whitespace
			local min_indent = math.huge
			for _, line in ipairs(lines) do
				if line:match("%S") then
					local indent = line:match("^%s*"):len()
					min_indent = math.min(min_indent, indent)
				end
			end

			-- Remove common indent
			local stripped_lines = {}
			for _, line in ipairs(lines) do
				table.insert(stripped_lines, line:sub(min_indent + 1))
			end
			local text = table.concat(stripped_lines, " ")

			local formatted
			-- Check if it's MDX
			if text:match("NON EMPTY") or text:match("DIMENSION PROPERTIES") or text:match("FROM %[") then
				formatted = format_mdx(text)
				print("Formatted MDX")
			else
				-- Use sqlfluff for SQL
				local tmpfile = vim.fn.tempname() .. ".sql"
				vim.fn.writefile(stripped_lines, tmpfile)
				vim.fn.system("sqlfluff format --dialect ansi --force " .. tmpfile .. " 2>&1")
				formatted = vim.fn.readfile(tmpfile)
				vim.fn.delete(tmpfile)
				print("Formatted SQL")
			end

			-- Restore indent
			local indent_str = string.rep(" ", min_indent)
			for i, line in ipairs(formatted) do
				if line:match("%S") then
					formatted[i] = indent_str .. line
				end
			end

			vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, formatted)
		end, { desc = "Format selected SQL/MDX" })
	end,
}
