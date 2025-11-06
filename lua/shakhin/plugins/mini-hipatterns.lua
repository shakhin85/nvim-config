-- mini.hipatterns - Highlight patterns in text
-- Automatically highlights hex colors, TODO/FIXME/NOTE/HACK keywords, and more
--
-- Features:
--   - Hex colors: #FF0000 shows as red background
--   - RGB colors: rgb(255, 0, 0) shows as red background
--   - Keywords: TODO, FIXME, HACK, NOTE get special highlighting
--   - Custom patterns: Add your own!
--
-- Examples of what gets highlighted:
--   #FF5733  <- Shows with orange/red background
--   #00FF00  <- Shows with green background
--   TODO: implement this  <- "TODO" highlighted
--   FIXME: broken code   <- "FIXME" highlighted in red
--   NOTE: important info <- "NOTE" highlighted in blue
--   HACK: temporary fix  <- "HACK" highlighted in yellow
--
-- Works in:
--   - Code comments
--   - Markdown files
--   - Configuration files
--   - Any text file!

return {
	"echasnovski/mini.hipatterns",
	version = "*",
	event = "VeryLazy",
	config = function()
		local hipatterns = require("mini.hipatterns")

		hipatterns.setup({
			highlighters = {
				-- Highlight hex color strings (#rrggbb or #rgb)
				-- Shows the actual color as background
				hex_color = hipatterns.gen_highlighter.hex_color({
					-- Style can be: 'full', 'inline', 'line'
					style = "inline", -- Highlights just the color code
					-- Priority of highlight
					priority = 2000,
				}),

				-- Highlight TODO keyword
				todo = {
					pattern = "%f[%w]()TODO()%f[%W]",
					group = "MiniHipatternsTodo",
					extmark_opts = { priority = 2000 },
				},

				-- Highlight FIXME keyword
				fixme = {
					pattern = "%f[%w]()FIXME()%f[%W]",
					group = "MiniHipatternsFixme",
					extmark_opts = { priority = 2000 },
				},

				-- Highlight HACK keyword
				hack = {
					pattern = "%f[%w]()HACK()%f[%W]",
					group = "MiniHipatternsHack",
					extmark_opts = { priority = 2000 },
				},

				-- Highlight NOTE keyword
				note = {
					pattern = "%f[%w]()NOTE()%f[%W]",
					group = "MiniHipatternsNote",
					extmark_opts = { priority = 2000 },
				},

				-- Optional: Add custom patterns
				-- Uncomment to highlight BUG keyword
				-- bug = {
				-- 	pattern = "%f[%w]()BUG()%f[%W]",
				-- 	group = "MiniHipatternsFixme", -- Reuse FIXME color
				-- 	extmark_opts = { priority = 2000 },
				-- },

				-- Optional: Highlight RGB colors
				-- Uncomment to enable rgb(255, 0, 0) style colors
				-- rgb_color = {
				-- 	pattern = "rgb%(%d+, %d+, %d+%)",
				-- 	group = function(_, match)
				-- 		local r, g, b = match:match("rgb%((%d+), (%d+), (%d+)%)")
				-- 		local hex = string.format("#%02X%02X%02X", r, g, b)
				-- 		return hipatterns.compute_hex_color_group(hex, "bg")
				-- 	end,
				-- 	extmark_opts = { priority = 2000 },
				-- },
			},
		})

		-- Setup highlight groups with nice colors
		-- These will be used by the patterns above
		vim.api.nvim_set_hl(0, "MiniHipatternsTodo", { bg = "#2d7de4", fg = "#ffffff", bold = true })
		vim.api.nvim_set_hl(0, "MiniHipatternsFixme", { bg = "#e42d42", fg = "#ffffff", bold = true })
		vim.api.nvim_set_hl(0, "MiniHipatternsHack", { bg = "#e4ae2d", fg = "#000000", bold = true })
		vim.api.nvim_set_hl(0, "MiniHipatternsNote", { bg = "#2de4a4", fg = "#000000", bold = true })

		-- Optional: Add command to toggle hipatterns
		vim.api.nvim_create_user_command("HiPatternsToggle", function()
			if vim.b.minihipatterns_disable then
				vim.b.minihipatterns_disable = false
				hipatterns.update()
				print("HiPatterns enabled")
			else
				vim.b.minihipatterns_disable = true
				hipatterns.update()
				print("HiPatterns disabled")
			end
		end, { desc = "Toggle mini.hipatterns highlighting" })

		-- WhichKey integration
		local has_which_key, wk = pcall(require, "which-key")
		if has_which_key then
			wk.add({
				{ "<leader>uh", "<cmd>HiPatternsToggle<cr>", desc = "Toggle highlight patterns" },
			})
		end
	end,
}
