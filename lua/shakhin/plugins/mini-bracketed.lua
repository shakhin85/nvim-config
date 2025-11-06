-- mini.bracketed - Go forward/backward with square brackets
-- Provides consistent ] and [ navigation for various Vim objects
--
-- Usage (all work with count, e.g., 3]b to go 3 buffers forward):
--   ]b / [b : Next/previous buffer
--   ]c / [c : Next/previous comment block
--   ]x / [x : Next/previous conflict marker (git conflicts)
--   ]d / [d : Next/previous diagnostic (LSP errors/warnings)
--   ]f / [f : Next/previous file in directory
--   ]i / [i : Next/previous indent change
--   ]j / [j : Next/previous jump from jumplist
--   ]l / [l : Next/previous location from location list
--   ]o / [o : Next/previous old file (from v:oldfiles)
--   ]q / [q : Next/previous quickfix entry
--   ]t / [t : Next/previous tag match
--   ]u / [u : Next/previous undo state
--   ]w / [w : Next/previous window
--   ]y / [y : Next/previous yank from yank history
--
-- Examples:
--   ]d : Jump to next LSP diagnostic error
--   3[b : Go back 3 buffers
--   ]x : Jump to next git conflict marker (during merge)
--   ]q : Next quickfix entry (after :grep or :make)
--
-- This provides a consistent interface similar to vim-unimpaired

return {
	"echasnovski/mini.bracketed",
	version = "*",
	event = "VeryLazy",
	config = function()
		require("mini.bracketed").setup({
			-- Each target has the following structure:
			-- { suffix, forward, backward, opts }
			-- Leave default keybindings for all targets

			buffer = { suffix = "b", options = {} },
			comment = { suffix = "c", options = {} },
			conflict = { suffix = "x", options = {} },
			diagnostic = { suffix = "d", options = {} },
			file = { suffix = "f", options = {} },
			indent = { suffix = "i", options = {} },
			jump = { suffix = "j", options = {} },
			location = { suffix = "l", options = {} },
			oldfile = { suffix = "o", options = {} },
			quickfix = { suffix = "q", options = {} },
			treesitter = { suffix = "t", options = {} },
			undo = { suffix = "u", options = {} },
			window = { suffix = "w", options = {} },
			yank = { suffix = "y", options = {} },
		})

		-- WhichKey integration
		local has_which_key, wk = pcall(require, "which-key")
		if has_which_key then
			wk.add({
				-- Forward navigation
				{ "]b", desc = "Next buffer" },
				{ "]c", desc = "Next comment" },
				{ "]x", desc = "Next conflict" },
				{ "]d", desc = "Next diagnostic" },
				{ "]f", desc = "Next file" },
				{ "]i", desc = "Next indent change" },
				{ "]j", desc = "Next jump" },
				{ "]l", desc = "Next location" },
				{ "]o", desc = "Next old file" },
				{ "]q", desc = "Next quickfix" },
				{ "]t", desc = "Next treesitter" },
				{ "]u", desc = "Next undo" },
				{ "]w", desc = "Next window" },
				{ "]y", desc = "Next yank" },

				-- Backward navigation
				{ "[b", desc = "Previous buffer" },
				{ "[c", desc = "Previous comment" },
				{ "[x", desc = "Previous conflict" },
				{ "[d", desc = "Previous diagnostic" },
				{ "[f", desc = "Previous file" },
				{ "[i", desc = "Previous indent change" },
				{ "[j", desc = "Previous jump" },
				{ "[l", desc = "Previous location" },
				{ "[o", desc = "Previous old file" },
				{ "[q", desc = "Previous quickfix" },
				{ "[t", desc = "Previous treesitter" },
				{ "[u", desc = "Previous undo" },
				{ "[w", desc = "Previous window" },
				{ "[y", desc = "Previous yank" },
			})
		end
	end,
}
