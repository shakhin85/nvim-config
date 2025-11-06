-- mini.bufremove - Smart buffer deletion that preserves window layout
-- Solves the problem where :bd breaks your split layout
--
-- Usage:
--   <leader>bd : Delete buffer (keeps window layout intact)
--   <leader>bw : Wipeout buffer (complete removal, keeps layout)
--
-- Why this is better than :bd:
--   - Normal :bd will close splits if the buffer is shown in multiple windows
--   - mini.bufremove switches to another buffer first, keeping your layout
--
-- Example workflow:
--   1. You have 3 splits open with different buffers
--   2. Press <leader>bd to close current buffer
--   3. Split layout stays intact, just shows a different buffer

return {
	"echasnovski/mini.bufremove",
	version = "*",
	event = "VeryLazy",
	config = function()
		require("mini.bufremove").setup()

		-- Keymaps
		vim.keymap.set("n", "<leader>bd", function()
			require("mini.bufremove").delete(0, false)
		end, { desc = "Delete buffer (keep layout)" })

		vim.keymap.set("n", "<leader>bw", function()
			require("mini.bufremove").wipeout(0, false)
		end, { desc = "Wipeout buffer (keep layout)" })

		-- Optional: Force delete without save prompt
		vim.keymap.set("n", "<leader>bD", function()
			require("mini.bufremove").delete(0, true)
		end, { desc = "Force delete buffer" })

		-- WhichKey integration
		local has_which_key, wk = pcall(require, "which-key")
		if has_which_key then
			wk.add({
				{ "<leader>b", group = "buffers" },
				{ "<leader>bd", desc = "Delete buffer (keep layout)" },
				{ "<leader>bD", desc = "Force delete buffer" },
				{ "<leader>bw", desc = "Wipeout buffer (keep layout)" },
			})
		end
	end,
}
