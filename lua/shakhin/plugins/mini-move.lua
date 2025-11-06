-- mini.move - Move lines and selections easily
-- Move lines and blocks of text with simple keybindings
--
-- Usage:
--   Normal mode (move current line):
--     Shift+j : Move line down
--     Shift+k : Move line up
--     Shift+h : Move line left (indent left)
--     Shift+l : Move line right (indent right)
--
--   Visual mode (move selected block):
--     Shift+j : Move selection down
--     Shift+k : Move selection up
--     Shift+h : Move selection left (indent left)
--     Shift+l : Move selection right (indent right)
--
-- Features:
--   - Automatically reindents code when moving
--   - Works with line-wise and block-wise visual selections
--   - Preserves selection after move in visual mode
--   - Respects 'shiftwidth' for horizontal movement

return {
	"echasnovski/mini.move",
	event = "VeryLazy",
	opts = {
		-- Module mappings. Use `''` (empty string) to disable one.
		mappings = {
			-- Move visual selection in Visual mode
			-- Using Shift+hjkl for intuitive directional movement
			left = "<S-h>",
			right = "<S-l>",
			down = "<S-j>",
			up = "<S-k>",

			-- Move current line in Normal mode
			line_left = "<S-h>",
			line_right = "<S-l>",
			line_down = "<S-j>",
			line_up = "<S-k>",
		},

		-- Options which control moving behavior
		options = {
			-- Automatically reindent selection during linewise vertical move
			reindent_linewise = true,
		},
	},

	config = function(_, opts)
		require("mini.move").setup(opts)

		-- Optional: Add WhichKey descriptions if you have which-key.nvim
		local has_which_key, wk = pcall(require, "which-key")
		if has_which_key then
			wk.add({
				{ "<S-h>", desc = "Move left/indent left", mode = { "n", "v" } },
				{ "<S-j>", desc = "Move down", mode = { "n", "v" } },
				{ "<S-k>", desc = "Move up", mode = { "n", "v" } },
				{ "<S-l>", desc = "Move right/indent right", mode = { "n", "v" } },
			})
		end
	end,
}
