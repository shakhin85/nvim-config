-- mini.operators - Extra text operators for advanced editing
-- Provides powerful operators that extend Vim's native commands
--
-- Usage:
--
-- 1. EXCHANGE (gx) - Swap two text objects
--    gxiw : Mark word for exchange
--    gxiw : (on another word) Swaps the two words
--    gx   : (alone) Cancel exchange
--
--    Example:
--      foo bar  -> cursor on "foo", press gxiw
--      foo bar  -> cursor on "bar", press gxiw
--      bar foo  -> Words are swapped!
--
-- 2. MULTIPLY (gm) - Repeat text multiple times
--    5gm. : Repeat current line 5 times
--    3gmip : Repeat paragraph 3 times
--    gmip : Repeat paragraph once (useful with counts)
--
--    Example:
--      print("hi")  -> press 3gm.
--      print("hi")
--      print("hi")
--      print("hi")
--
-- 3. REPLACE (gr) - Replace with register WITHOUT yanking
--    grw : Replace word with register content (doesn't yank replaced text)
--    grip : Replace paragraph with register
--
--    Why better than normal paste: When you paste over text with 'p',
--    the deleted text goes into register. 'gr' keeps your register intact.
--
-- 4. SORT (gs) - Sort text objects
--    gsip : Sort lines in paragraph
--    gsi( : Sort items inside parentheses
--
--    Example:
--      def func(zebra, apple, banana):  -> cursor inside (), press gsi(
--      def func(apple, banana, zebra):  -> Sorted!

return {
	"echasnovski/mini.operators",
	version = "*",
	event = "VeryLazy",
	config = function()
		require("mini.operators").setup({
			-- Exchange
			exchange = {
				prefix = "gx", -- First gx marks, second gx swaps
				-- Reindent after exchange
				reindent_linewise = true,
			},

			-- Multiply (repeat)
			multiply = {
				prefix = "gm",
				-- Function to create separator between multiplied text
				-- Default: newline for linewise, empty for characterwise
				func = nil,
			},

			-- Replace with register
			replace = {
				prefix = "gr",
				-- Reindent after replace
				reindent_linewise = true,
			},

			-- Sort
			sort = {
				prefix = "gs",
				-- Function to extract sortable items
				-- Default works for comma-separated items and lines
				func = nil,
			},

			-- Evaluate (compute math expressions)
			evaluate = {
				prefix = "g=",
				-- Function to evaluate text
				-- Default uses Lua's load() to evaluate expressions
				func = nil,
			},
		})

		-- WhichKey integration
		local has_which_key, wk = pcall(require, "which-key")
		if has_which_key then
			wk.add({
				{ "g", group = "goto/operators" },
				{ "gx", desc = "Exchange text", mode = { "n", "v" } },
				{ "gm", desc = "Multiply (repeat) text", mode = { "n", "v" } },
				{ "gr", desc = "Replace with register", mode = { "n", "v" } },
				{ "gs", desc = "Sort text", mode = { "n", "v" } },
				{ "g=", desc = "Evaluate expression", mode = { "n", "v" } },
			})
		end

		-- Optional: Add some helpful user commands
		vim.api.nvim_create_user_command("ExchangeClear", function()
			-- Clear exchange region if you change your mind
			require("mini.operators").exchange("cancel")
		end, { desc = "Cancel pending exchange" })
	end,
}
