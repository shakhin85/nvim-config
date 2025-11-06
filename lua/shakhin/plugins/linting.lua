return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

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

		-- Configure linters by filetype
		lint.linters_by_ft = {
			python = { "ruff", "mypy" },
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescriptreact = { "eslint_d" },
		}

		-- Custom linter configurations for Windows compatibility
		-- Use .venv tools if available, otherwise fall back to Mason
		lint.linters.ruff.cmd = get_tool_cmd("ruff")
		lint.linters.mypy.cmd = get_tool_cmd("mypy")
		lint.linters.eslint_d.cmd = get_mason_bin("eslint_d")

		-- Create autocommand group for linting
		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		-- Trigger linting on specific events
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				-- Only lint if file exists and is not too large
				local max_filesize = 100 * 1024 -- 100 KB
				local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(0))
				if ok and stats and stats.size > max_filesize then
					return
				end

				lint.try_lint()
			end,
		})

		-- Manual lint trigger (changed from <leader>l to avoid conflict with LSP group)
		vim.keymap.set("n", "<leader>ll", function()
			lint.try_lint()
		end, { desc = "Trigger linting for current file" })

		-- Show linter info with paths
		vim.api.nvim_create_user_command("LintInfo", function()
			local filetype = vim.bo.filetype
			local linters = lint.linters_by_ft[filetype] or {}
			if #linters == 0 then
				print("No linters configured for filetype: " .. filetype)
			else
				print("Linters for " .. filetype .. ":")
				for _, linter_name in ipairs(linters) do
					local linter = lint.linters[linter_name]
					if linter and linter.cmd then
						print("  - " .. linter_name .. ": " .. linter.cmd)
					else
						print("  - " .. linter_name .. ": (not configured)")
					end
				end
			end
		end, { desc = "Show configured linters for current filetype" })
	end,
}
