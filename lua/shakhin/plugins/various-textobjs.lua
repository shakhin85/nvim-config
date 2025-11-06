-- nvim-various-textobjs - Extended collection of text objects
-- Adds dozens of useful text objects beyond vim's defaults
--
-- Quick Reference (most useful ones):
--   Indentation:
--     ii/ai : Inner/around indentation (respects blank lines)
--     iI/aI : Inner/around indentation (includes blank lines)
--
--   Subword (camelCase/snake_case):
--     iS/aS : Inner/around subword
--
--   Key-Value pairs:
--     ik/ak : Inner/around key in key-value pair
--     iv/av : Inner/around value in key-value pair
--
--   Numbers:
--     in/an : Inner/around number (works with floats, hex, binary)
--
--   URL:
--     iu/au : Inner/around URL
--
--   Diagnostic:
--     id/ad : Inner/around diagnostic (LSP diagnostic message)
--
--   Column:
--     ic/ac : Inner/around column (vertical block of text)
--
--   Rest of...
--     ir/ar : Rest of indentation (from cursor to end of indent block)
--     iR/aR : Rest of paragraph
--
--   Near end of line:
--     in/an : Near end of line (last word/WORD)
--
--   Entire buffer:
--     ie/ae : Inner/around entire buffer
--
--   And many more! See :help various-textobjs
--
-- Usage examples:
--   dii : Delete current indentation level
--   viS : Select current subword (in camelCase)
--   cik : Change key in key:value pair
--   yiv : Yank value in key:value pair
--   din : Delete number under cursor

return {
	"chrisgrieser/nvim-various-textobjs",
	event = "VeryLazy",
	opts = {
		-- Keymap configuration (new API)
		keymaps = {
			useDefaults = true, -- Use default keymaps (recommended for most users)
			disabledDefaults = {}, -- e.g., { "ai", "ii" } to disable default indentation textobjs
		},

		-- Forward looking configuration (new API)
		forwardLooking = {
			small = 5, -- lines to look forward for small text objects
			big = 15, -- lines to look forward for big text objects
		},

		-- Notification configuration (new API)
		notify = {
			whenObjectNotFound = true, -- Enable notification of edge cases (no textobj found, etc.)
		},

		-- Use treesitter for text objects that support it
		useTreesitter = true,
	},

	config = function(_, opts)
		require("various-textobjs").setup(opts)

		-- Optional: Add custom keymaps for specific text objects you use often
		-- These supplement the default keymaps

		local map = vim.keymap.set

		-- Example: Add a custom keymap for "entire buffer" text object
		-- (already mapped to 'gG' by default, but you could change it)
		-- map({ "o", "x" }, "aG", function()
		-- 	require("various-textobjs").entireBuffer()
		-- end, { desc = "Entire buffer textobj" })

		-- Example: Quick access to diagnostic text object
		-- Useful for: "did" (delete diagnostic), "vid" (select diagnostic)
		-- Already mapped by default to 'id'/'ad'

		-- You can also create operator-pending mode shortcuts
		-- Example: 'dv' to delete value in key-value pair
		-- map("n", "dv", function()
		-- 	require("various-textobjs").value("inner")
		-- 	vim.cmd.normal({ "d", bang = true })
		-- end, { desc = "Delete value in key:value" })

		-- Add WhichKey descriptions if available
		local has_which_key, wk = pcall(require, "which-key")
		if has_which_key then
			wk.add({
				{ "ii", desc = "Inner indentation" },
				{ "ai", desc = "Around indentation" },
				{ "iI", desc = "Inner indentation (+ blank)" },
				{ "aI", desc = "Around indentation (+ blank)" },
				{ "iS", desc = "Inner subword" },
				{ "aS", desc = "Around subword" },
				{ "ik", desc = "Inner key" },
				{ "ak", desc = "Around key" },
				{ "iv", desc = "Inner value" },
				{ "av", desc = "Around value" },
				{ "in", desc = "Inner number" },
				{ "an", desc = "Around number" },
				{ "iu", desc = "Inner URL" },
				{ "au", desc = "Around URL" },
				{ "ie", desc = "Inner entire buffer" },
				{ "ae", desc = "Around entire buffer" },
			}, { mode = { "o", "x" } })
		end
	end,
}
