-- mini.splitjoin - Toggle between single-line and multi-line code
-- Intelligently split or join code structures like function arguments, arrays, objects
--
-- Usage:
--   gS : Toggle split/join (works in normal and visual mode)
--
-- Examples:
--
-- Before (single line):
--   foo(arg1, arg2, arg3)
--
-- After pressing gS (multi-line):
--   foo(
--       arg1,
--       arg2,
--       arg3
--   )
--
-- Works with:
--   - Function arguments
--   - Array/list literals
--   - Object/dict literals
--   - Import statements
--   - And more!
--
-- Python example:
--   my_list = [1, 2, 3, 4]  ->  my_list = [
--                                   1,
--                                   2,
--                                   3,
--                                   4,
--                               ]
--
-- JavaScript/TypeScript example:
--   const obj = {a: 1, b: 2}  ->  const obj = {
--                                     a: 1,
--                                     b: 2,
--                                 }

return {
	"echasnovski/mini.splitjoin",
	version = "*",
	event = "VeryLazy",
	config = function()
		require("mini.splitjoin").setup({
			-- Main mapping to toggle split/join
			mappings = {
				toggle = "gS", -- Press gS to toggle
				split = "", -- Leave empty to use only toggle
				join = "", -- Leave empty to use only toggle
			},

			-- Detection options
			detect = {
				-- Array of Lua patterns to detect split/join regions
				-- Default patterns work for most languages
				brackets = nil, -- Use default bracket patterns

				-- Custom separator patterns (default: comma and semicolon)
				separator = ",",

				-- Exclude certain patterns from being split/joined
				exclude_regions = nil,
			},

			-- Split options
			split = {
				hooks_pre = {}, -- Functions to call before split
				hooks_post = {}, -- Functions to call after split
			},

			-- Join options
			join = {
				hooks_pre = {}, -- Functions to call before join
				hooks_post = {}, -- Functions to call after join
			},
		})

		-- WhichKey integration
		local has_which_key, wk = pcall(require, "which-key")
		if has_which_key then
			wk.add({
				{ "gS", desc = "Toggle split/join", mode = { "n", "v" } },
			})
		end
	end,
}
