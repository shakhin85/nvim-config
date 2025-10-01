return {
	"saghen/blink.cmp",

	-- Lazy loading is not recommended as it can cause issues
	lazy = false,

	-- Use release tag to avoid breaking changes
	version = "v0.*",

	dependencies = {
		"rafamadriz/friendly-snippets",
		-- LuaSnip integration
		"L3MON4D3/LuaSnip",
	},

	-- Extend opts when using lazy.nvim
	opts_extend = {
		"sources.default",
		"cmdline.sources",
	},

	opts = {
		-- Control when blink.cmp is enabled
		enabled = function()
			-- Disable in prompt buffers (like telescope)
			return vim.bo.buftype ~= "prompt"
		end,

		-- ==================== KEYMAP CONFIGURATION ====================
		keymap = {
			-- Available presets: 'default' | 'super-tab' | 'enter'
			preset = "default",

			-- Custom keymap overrides to match your previous config
			["<C-k>"] = { "select_prev", "fallback" },
			["<C-j>"] = { "select_next", "fallback" },
			["<C-b>"] = { "scroll_documentation_up", "fallback" },
			["<C-f>"] = { "scroll_documentation_down", "fallback" },
			["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
			["<C-e>"] = { "hide", "fallback" },
			["<CR>"] = { "accept", "fallback" },

			-- Tab для навигации по сниппетам и автодополнению
			["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
			["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
		},

		-- ==================== COMPLETION CONFIGURATION ====================
		completion = {
			-- Keyword matching mode
			keyword = {
				range = "prefix", -- fuzzy match before cursor
			},

			-- Trigger configuration
			trigger = {
				show_on_keyword = true,
				show_on_trigger_character = true,
				show_in_snippet = true,
				show_on_insert_on_trigger_character = true,
			},

			-- Selection behavior
			list = {
				selection = {
					preselect = true, -- Automatically select first item
					auto_insert = false, -- Don't auto-insert (matches your config)
				},
				cycle = {
					from_top = true,
					from_bottom = true,
				},
			},

			-- Accept configuration
			accept = {
				auto_brackets = {
					enabled = true,
				},
			},

			-- Menu configuration
			menu = {
				auto_show = true,

				draw = {
					columns = {
						{ "kind_icon" },
						{ "label", "label_description", gap = 1 },
						{ "kind" },
					},
				},

				border = "rounded",
			},

			-- Documentation window
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 200,
				treesitter_highlighting = true,

				window = {
					min_width = 30,
					max_width = 90,
					max_height = 40,
					border = "rounded",
					scrollbar = true,
				},
			},

			-- Ghost text (inline preview)
			ghost_text = {
				enabled = true,
			},
		},

		-- ==================== SOURCES CONFIGURATION ====================
		sources = {
			-- Default sources (matching your nvim-cmp priorities)
			default = { "lsp", "path", "snippets", "buffer" },

			-- Provider configurations
			providers = {
				lsp = {
					name = "LSP",
					module = "blink.cmp.sources.lsp",
					score_offset = 1000, -- Highest priority (matches your nvim-cmp)
				},

				snippets = {
					name = "Snippets",
					module = "blink.cmp.sources.snippets",
					score_offset = 750, -- Second priority (matches your luasnip)
					opts = {
						friendly_snippets = true,
						search_paths = { vim.fn.stdpath("config") .. "/snippets" },
						global_snippets = { "all" },
						extended_filetypes = {},
						ignored_filetypes = {},
					},
				},

				path = {
					name = "Path",
					module = "blink.cmp.sources.path",
					score_offset = 250,
					opts = {
						trailing_slash = false,
						label_trailing_slash = true,
						get_cwd = function(context)
							return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
						end,
						show_hidden_files_by_default = false,
					},
				},

				buffer = {
					name = "Buffer",
					module = "blink.cmp.sources.buffer",
					score_offset = 500,
					min_keyword_length = 3,
				},
			},
		},

		-- ==================== SNIPPETS CONFIGURATION ====================
		snippets = {
			expand = function(snippet)
				require("luasnip").lsp_expand(snippet)
			end,

			active = function(filter)
				if filter and filter.direction then
					return require("luasnip").jumpable(filter.direction)
				end
				return require("luasnip").in_snippet()
			end,

			jump = function(direction)
				require("luasnip").jump(direction)
			end,
		},

		-- ==================== SIGNATURE HELP CONFIGURATION ====================
		signature = {
			enabled = true,
			trigger = {
				blocked_trigger_characters = {},
				blocked_retrigger_characters = {},
				show_on_insert_on_trigger_character = true,
			},
			window = {
				min_width = 1,
				max_width = 100,
				max_height = 10,
				border = "rounded",
				scrollbar = false,
			},
		},

		-- ==================== FUZZY MATCHING CONFIGURATION ====================
		fuzzy = {
			use_frecency = true,
			use_proximity = true,
			sorts = { "score", "sort_text", "label", "kind" },
		},

		-- ==================== APPEARANCE CONFIGURATION ====================
		appearance = {
			nerd_font_variant = "mono",

			-- Kind icons (matching your nvim-cmp config)
			kind_icons = {
				Text = "󰉿",
				Method = "󰆧",
				Function = "󰊕",
				Constructor = "",
				Field = "󰜢",
				Variable = "󰀫",
				Class = "󰠱",
				Interface = "",
				Module = "",
				Property = "󰜢",
				Unit = "󰑭",
				Value = "󰎠",
				Enum = "",
				Keyword = "󰌋",
				Snippet = "",
				Color = "󰏘",
				File = "󰈙",
				Reference = "󰈇",
				Folder = "󰉋",
				EnumMember = "",
				Constant = "󰏿",
				Struct = "󰙅",
				Event = "",
				Operator = "󰆕",
				TypeParameter = "",
			},
		},
	},

	-- ==================== LSP INTEGRATION ====================
	config = function(_, opts)
		local blink = require("blink.cmp")
		blink.setup(opts)

		-- Load vscode-style snippets from friendly-snippets
		require("luasnip.loaders.from_vscode").lazy_load()
	end,
}
