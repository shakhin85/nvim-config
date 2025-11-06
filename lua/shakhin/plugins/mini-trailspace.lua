-- mini.trailspace - Highlight and remove trailing whitespace
-- Automatically highlights trailing spaces and provides easy removal
--
-- Usage:
--   - Trailing whitespace is automatically highlighted in red
--   - <leader>mt : Trim all trailing whitespace in buffer
--   - <leader>mT : Trim trailing blank lines at end of buffer
--
-- Visual feedback:
--   "hello world   "  <- The 3 spaces at end are highlighted in red
--   "    code here "  <- The space at end is highlighted
--
-- Why this matters:
--   - Prevents noisy git diffs
--   - Keeps code clean
--   - Some languages (Python) care about trailing spaces
--   - Professional codebases enforce no trailing whitespace
--
-- Auto-trim on save:
--   Uncomment the autocmd at the bottom to automatically
--   trim whitespace when saving files

return {
	"echasnovski/mini.trailspace",
	version = "*",
	event = "VeryLazy",
	config = function()
		require("mini.trailspace").setup({
			-- Highlight only in modifiable buffers
			only_in_normal_buffers = true,
		})

		-- Keymaps
		vim.keymap.set("n", "<leader>mt", function()
			require("mini.trailspace").trim()
			print("Trimmed trailing whitespace")
		end, { desc = "Trim trailing whitespace" })

		vim.keymap.set("n", "<leader>mT", function()
			require("mini.trailspace").trim_last_lines()
			print("Trimmed trailing blank lines")
		end, { desc = "Trim trailing blank lines" })

		-- Optional: Auto-trim on save (uncomment to enable)
		-- Be careful with this - it might modify files you don't want changed
		-- vim.api.nvim_create_autocmd("BufWritePre", {
		-- 	group = vim.api.nvim_create_augroup("TrimTrailspace", { clear = true }),
		-- 	callback = function()
		-- 		-- Only trim if buffer is modifiable
		-- 		if vim.bo.modifiable then
		-- 			require("mini.trailspace").trim()
		-- 		end
		-- 	end,
		-- })

		-- Disable in certain filetypes where trailing space might be meaningful
		vim.api.nvim_create_autocmd("FileType", {
			pattern = {
				"markdown", -- Markdown uses 2 spaces for line break
				"diff",
				"git",
				"help",
			},
			callback = function()
				vim.b.minitrailspace_disable = true
			end,
		})

		-- WhichKey integration
		local has_which_key, wk = pcall(require, "which-key")
		if has_which_key then
			wk.add({
				{ "<leader>m", group = "mini.nvim" },
				{ "<leader>mt", desc = "Trim trailing whitespace" },
				{ "<leader>mT", desc = "Trim trailing blank lines" },
			})
		end

		-- Optional: Add a command to toggle highlighting
		vim.api.nvim_create_user_command("TrailspaceToggle", function()
			if vim.b.minitrailspace_disable then
				vim.b.minitrailspace_disable = false
				print("Trailspace highlighting enabled")
			else
				vim.b.minitrailspace_disable = true
				print("Trailspace highlighting disabled")
			end
			-- Force redraw
			vim.cmd("edit")
		end, { desc = "Toggle trailspace highlighting" })
	end,
}
