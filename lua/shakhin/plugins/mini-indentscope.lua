-- mini.indentscope - Visualize and navigate indent scope
-- Shows animated vertical line indicating your current code block
--
-- Usage:
--   - Automatically shows scope line when cursor is inside a block
--   - [i : Jump to previous indent scope
--   - ]i : Jump to next indent scope
--
-- Visual indicator:
--   │  <- This vertical line shows your current indentation scope
--   │  Moves smoothly when you change position
--   │  Great for Python, Lua, YAML, and any indent-based code
--
-- Example: When cursor is on line 5
--   1  def function():
--   2  │   if condition:
--   3  │   │   # Your cursor here
--   4  │   │   do_something()  <- scope line shows you're in the if block
--   5  │   │   do_more()
--   6  │   else:
--   7  │       other()

return {
	"echasnovski/mini.indentscope",
	version = "*",
	event = "VeryLazy",
	config = function()
		require("mini.indentscope").setup({
			-- Visual options
			symbol = "│", -- Character to use for the scope line

			-- Drawing options
			draw = {
				-- Delay before showing scope (in ms)
				delay = 50,

				-- Animation config - smooth quadratic animation
				animation = require("mini.indentscope").gen_animation.quadratic({
					easing = "out",
					duration = 20,
					unit = "total",
				}),
			},

			-- Scope computation options
			options = {
				-- Try to use border to highlight scope if possible
				try_as_border = true,

				-- Indent at cursor is not considered as scope
				-- Set to true if you want cursor line to be part of scope
				indent_at_cursor = true,
			},

			-- Mappings for scope navigation
			mappings = {
				-- Move to previous/next scope
				object_scope = "ii", -- Text object for current scope
				object_scope_with_border = "ai", -- Text object including border

				-- Navigation
				goto_top = "[i", -- Go to top of scope
				goto_bottom = "]i", -- Go to bottom of scope
			},
		})

		-- Disable in certain filetypes where indent scope doesn't make sense
		vim.api.nvim_create_autocmd("FileType", {
			pattern = {
				"help",
				"alpha",
				"dashboard",
				"neo-tree",
				"Trouble",
				"lazy",
				"mason",
				"notify",
				"toggleterm",
				"lazyterm",
				"nvim-tree",
			},
			callback = function()
				vim.b.miniindentscope_disable = true
			end,
		})

		-- WhichKey integration
		local has_which_key, wk = pcall(require, "which-key")
		if has_which_key then
			wk.add({
				{ "[i", desc = "Jump to top of indent scope" },
				{ "]i", desc = "Jump to bottom of indent scope" },
				{ "ii", desc = "Inside indent scope", mode = { "x", "o" } },
				{ "ai", desc = "Around indent scope", mode = { "x", "o" } },
			})
		end
	end,
}
