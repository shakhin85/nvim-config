return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			flavour = "frappe", -- latte, frappe, macchiato, mocha
			background = { -- :h background
				light = "latte",
				dark = "mocha",
			},
			transparent_background = false, -- disables setting the background color.
			show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
			term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
			dim_inactive = {
				enabled = false, -- dims the background color of inactive window
				shade = "dark",
				percentage = 0.15, -- percentage of the shade to apply to the inactive window
			},
			no_italic = false, -- Force no italic
			no_bold = false, -- Force no bold
			no_underline = false, -- Force no underline
			styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
				comments = { "italic" }, -- Change the style of comments
				conditionals = { "italic" },
				loops = {},
				functions = {},
				keywords = {},
				strings = {},
				variables = {},
				numbers = {},
				booleans = {},
				properties = {},
				types = {},
				operators = {},
			},
			color_overrides = {},
			custom_highlights = {},
			integrations = {
				cmp = true,
				gitsigns = true,
				nvimtree = true,
				treesitter = true,
				notify = false,
				mini = {
					enabled = true,
					indentscope_color = "",
				},
				-- Интеграции для ваших плагинов
				telescope = {
					enabled = true,
					-- style = "nvchad"
				},
				lsp_trouble = true,
				which_key = true,
				indent_blankline = {
					enabled = true,
					scope_color = "", -- catppuccin color (eg. `lavender`) Default: text
					colored_indent_levels = false,
				},
				mason = true,
				dap = true,
				dap_ui = true,
				harpoon = true,
				-- Для toggleterm
				native_lsp = {
					enabled = true,
					virtual_text = {
						errors = { "italic" },
						hints = { "italic" },
						warnings = { "italic" },
						information = { "italic" },
					},
					underlines = {
						errors = { "underline" },
						hints = { "underline" },
						warnings = { "underline" },
						information = { "underline" },
					},
					inlay_hints = {
						background = true,
					},
				},
			},
		})

		-- setup must be called before loading
		vim.cmd.colorscheme("catppuccin")

		-- Дополнительные настройки для интеграции
		-- Настройка прозрачности для некоторых элементов
		vim.api.nvim_create_autocmd("ColorScheme", {
			pattern = "catppuccin*",
			callback = function()
				local colors = require("catppuccin.palettes").get_palette()
				-- Можно настроить дополнительные цвета здесь
				vim.api.nvim_set_hl(0, "Normal", { bg = colors.base })
				vim.api.nvim_set_hl(0, "NormalFloat", { bg = colors.mantle })
			end,
		})

		-- Команды для переключения между вариантами
		vim.api.nvim_create_user_command("CatppuccinMocha", function()
			vim.g.catppuccin_flavour = "mocha"
			vim.cmd("colorscheme catppuccin")
		end, { desc = "Set Catppuccin Mocha theme" })

		vim.api.nvim_create_user_command("CatppuccinLatte", function()
			vim.g.catppuccin_flavour = "latte"
			vim.cmd("colorscheme catppuccin")
		end, { desc = "Set Catppuccin Latte theme (light)" })

		vim.api.nvim_create_user_command("CatppuccinFrappe", function()
			vim.g.catppuccin_flavour = "frappe"
			vim.cmd("colorscheme catppuccin")
		end, { desc = "Set Catppuccin Frappe theme" })

		vim.api.nvim_create_user_command("CatppuccinMacchiato", function()
			vim.g.catppuccin_flavour = "macchiato"
			vim.cmd("colorscheme catppuccin")
		end, { desc = "Set Catppuccin Macchiato theme" })

		-- Кеймап для быстрого переключения тем
		vim.keymap.set("n", "<leader>pt", function()
			local flavours = { "mocha", "frappe", "macchiato", "latte" }
			local current = vim.g.catppuccin_flavour or "mocha"
			local current_index = 1

			for i, flavour in ipairs(flavours) do
				if flavour == current then
					current_index = i
					break
				end
			end

			local next_index = current_index % #flavours + 1
			local next_flavour = flavours[next_index]

			vim.g.catppuccin_flavour = next_flavour
			vim.cmd("colorscheme catppuccin")
			vim.notify("Switched to Catppuccin " .. next_flavour:gsub("^%l", string.upper), vim.log.levels.INFO)
		end, { desc = "Cycle through Catppuccin themes" })
	end,
}
