return {
	"folke/sidekick.nvim",
	lazy = false, -- Load immediately to ensure keymaps work
	dependencies = {
		{
			"zbirenbaum/copilot.lua", -- Required for Copilot integration
			lazy = false, -- Load immediately with sidekick
			config = function()
				-- This ensures copilot.lua config runs before sidekick
				require("copilot").setup({
					panel = {
						enabled = false, -- Disable panel (sidekick handles UI)
					},
					suggestion = {
						enabled = false, -- Disable inline suggestions (sidekick handles this)
					},
					filetypes = {
						["*"] = true, -- Enable for all filetypes
						gitcommit = false,
						gitrebase = false,
					},
					copilot_node_command = "node", -- Node.js version must be > 18.x
				})
			end,
		},
	},
	config = function()
		local sidekick = require("sidekick")
		sidekick.setup({
			-- AI provider configuration
			ai = {
				-- Default provider: "claude", "gemini", "grok", or "copilot"
				provider = "claude",
				-- Model configuration per provider
				models = {
					claude = "claude-sonnet-4-5-20250929",
					gemini = "gemini-2.0-flash-exp",
					grok = "grok-2-latest",
				},
				-- Timeout for AI requests (in ms)
				timeout = 30000,
			},

			-- CLI configuration with Zellij multiplexer
			cli = {
				-- Terminal multiplexer configuration
				mux = {
					backend = "zellij", -- Using Zellij as terminal multiplexer
					enabled = true,
					-- Each AI tool opens in a separate Zellij pane, but prompts share history
					isolated = false,
					-- Pane naming for easy identification
					name_format = "sidekick-{name}",
				},
				-- Window layout options: "float", "split", "vsplit", "right", "left", "top", "bottom"
				layout = "float",
				-- Persistent sessions - terminals stay open after closing
				persistent = true,
				-- Focus the CLI window when toggling
				focus = true,
				-- Window options for float layout
				win_opts = {
					relative = "editor",
					width = 0.9,
					height = 0.85,
					border = "rounded",
				},
			},

			-- Next Edit Suggestions (NES) - FULLY ENABLED
			nes = {
				enabled = true,
				-- Auto-fetch suggestions on buffer changes
				auto_fetch = true,
				-- Debounce time in ms before fetching suggestions
				debounce = 300,
				-- Show suggestions in floating window
				float = true,
				-- Inline diff display: "word" or "character"
				diff_mode = "word",
				-- Trigger events for NES
				trigger_events = { "TextChanged", "TextChangedI", "InsertLeave" },
				-- Clear suggestions on these events
				clear_events = { "BufLeave", "InsertEnter" },
				-- Show virtual text indicators
				virtual_text = true,
				-- Maximum number of suggestions to show
				max_suggestions = 5,
				-- Priority for extmarks
				priority = 100,
				-- Keymaps for NES
				keys = {
					accept = "<CR>",
					reject = "<C-c>",
					next = "]h",
					prev = "[h",
					accept_word = "<C-Right>",
					accept_line = "<C-Down>",
				},
			},

			-- Copilot Language Server configuration
			copilot = {
				status = {
					enabled = true, -- Track Copilot status with didChangeStatus handler
				},
			},

			-- Terminal configuration
			terminal = {
				enabled = true,
				-- Terminal size (for float and split layouts)
				size = {
					width = 0.9,
					height = 0.85,
				},
				-- Position: "center", "top", "bottom", "left", "right"
				position = "center",
				-- Border style: "none", "single", "double", "rounded", "solid", "shadow"
				border = "rounded",
				-- Shell to use (defaults to $SHELL)
				shell = vim.o.shell,
				-- Environment variables for terminal
				env = {},
				-- On_exit callback
				on_exit = nil,
			},

			-- Diff view configuration
			diff = {
				-- Show line numbers
				line_numbers = true,
				-- Syntax highlighting
				syntax = true,
				-- Context lines around changes
				context = 5,
				-- Diff algorithm: "myers", "minimal", "patience", "histogram"
				algorithm = "histogram",
				-- Ignore whitespace changes
				ignore_whitespace = false,
				-- Show deleted lines
				show_deleted = true,
			},

			-- UI configuration
			ui = {
				-- Icons for different states
				icons = {
					suggestion = "󰛩",
					accepted = "✓",
					rejected = "✗",
					pending = "⏳",
					error = "",
					warning = "",
					info = "",
				},
				-- Sign column configuration
				signs = {
					add = "▎",
					change = "▎",
					delete = "▎",
				},
				-- Highlight groups
				highlights = {
					suggestion = "Comment",
					accepted = "DiffAdd",
					rejected = "DiffDelete",
				},
				-- Show notification messages
				notifications = true,
				-- Progress indicator
				progress = {
					enabled = true,
					format = "󰄛 {percentage}% {message}",
				},
			},

			-- Completion configuration
			completion = {
				enabled = true,
				-- Auto-trigger completion
				auto_trigger = true,
				-- Debounce time for completion (ms)
				debounce = 150,
				-- Max items to show
				max_items = 10,
			},

			-- Context configuration
			context = {
				-- Include buffer content in prompts
				include_buffer = true,
				-- Include visual selection
				include_selection = true,
				-- Include file path
				include_filepath = true,
				-- Include git diff
				include_git_diff = false,
				-- Include diagnostics
				include_diagnostics = true,
				-- Max context lines to include
				max_lines = 1000,
			},

			-- Logging configuration
			log = {
				enabled = true,
				level = "info", -- "trace", "debug", "info", "warn", "error"
				-- Log file path
				file = vim.fn.stdpath("log") .. "/sidekick.log",
			},

			-- Prompt library (custom prompts)
			prompts = {
				explain = {
					prompt = "Explain the following code in detail, including its purpose, how it works, and any important details:\n\n{selection}",
					description = "Explain selected code",
				},
				review = {
					prompt = "Review the following code for potential issues, bugs, performance problems, and suggest improvements:\n\n{selection}",
					description = "Review code quality",
				},
				document = {
					prompt = "Generate comprehensive documentation for the following code:\n\n{selection}",
					description = "Generate documentation",
				},
				optimize = {
					prompt = "Suggest optimizations for the following code to improve performance, readability, or maintainability:\n\n{selection}",
					description = "Optimize code",
				},
				test = {
					prompt = "Generate comprehensive unit tests for the following code:\n\n{selection}",
					description = "Generate tests",
				},
				refactor = {
					prompt = "Refactor the following code to improve its structure, readability, and maintainability:\n\n{selection}",
					description = "Refactor code",
				},
				debug = {
					prompt = "Help debug the following code. Identify potential issues and suggest fixes:\n\n{selection}",
					description = "Debug code",
				},
				simplify = {
					prompt = "Simplify the following code while maintaining its functionality:\n\n{selection}",
					description = "Simplify code",
				},
			},

			-- Custom commands
			commands = {
				-- Enable custom commands
				enabled = true,
			},

			-- Performance configuration
			performance = {
				-- Cache settings
				cache = {
					enabled = true,
					-- Cache TTL in seconds
					ttl = 3600,
				},
				-- Throttle requests
				throttle = {
					enabled = true,
					-- Max requests per minute
					max_requests = 60,
				},
			},
		})
		-- Sidekick automatically handles Copilot LSP status via its internal setup
	end,

	-- Key mappings
	keys = {
		-- NES Navigation and Application
		{
			"<tab>",
			function()
				-- Jump to or apply next edit suggestion
				if not require("sidekick").nes_jump_or_apply() then
					return "<Tab>" -- fallback to normal tab
				end
			end,
			expr = true,
			desc = "Goto/Apply Next Edit Suggestion",
		},
		{
			"<S-Tab>",
			function()
				require("sidekick").nes_prev()
			end,
			desc = "Previous Edit Suggestion",
		},

		-- CLI Focus and Toggle
		{
			"<c-.>",
			function()
				require("sidekick.cli").focus()
			end,
			desc = "Sidekick Switch Focus",
			mode = { "n", "v" },
		},
		{
			"<leader>aa",
			function()
				require("sidekick.cli").toggle({ focus = true })
			end,
			desc = "Sidekick Toggle CLI",
			mode = { "n", "v" },
		},

		-- AI Provider Specific Terminals (Each in separate Zellij pane)
		{
			"<leader>ac",
			function()
				require("sidekick.cli").toggle({ name = "claude", focus = true })
			end,
			desc = "Sidekick Claude (Separate Terminal)",
			mode = { "n", "v" },
		},
		{
			"<leader>am",
			function()
				require("sidekick.cli").toggle({ name = "gemini", focus = true })
			end,
			desc = "Sidekick Gemini (Separate Terminal)",
			mode = { "n", "v" },
		},
		{
			"<leader>ag",
			function()
				require("sidekick.cli").toggle({ name = "grok", focus = true })
			end,
			desc = "Sidekick Grok (Separate Terminal)",
			mode = { "n", "v" },
		},
		{
			"<leader>ao",
			function()
				require("sidekick.cli").toggle({ name = "copilot", focus = true })
			end,
			desc = "Sidekick Copilot (Separate Terminal)",
			mode = { "n", "v" },
		},

		-- Prompt Selection and Custom Prompts
		{
			"<leader>ap",
			function()
				require("sidekick.cli").prompt()
			end,
			desc = "Sidekick Select Prompt",
			mode = { "n", "v" },
		},
		{
			"<leader>ae",
			function()
				require("sidekick.cli").prompt()
			end,
			desc = "Sidekick Explain Code",
			mode = { "n", "v" },
		},
		{
			"<leader>ar",
			function()
				require("sidekick.cli").prompt()
			end,
			desc = "Sidekick Review Code",
			mode = { "n", "v" },
		},
		{
			"<leader>ad",
			function()
				require("sidekick.cli").prompt()
			end,
			desc = "Sidekick Document Code",
			mode = { "n", "v" },
		},
		{
			"<leader>at",
			function()
				require("sidekick.cli").prompt()
			end,
			desc = "Sidekick Generate Tests",
			mode = { "n", "v" },
		},

		-- NES Controls
		{
			"<leader>an",
			function()
				require("sidekick").nes_toggle()
			end,
			desc = "Toggle Next Edit Suggestions",
		},
		{
			"<leader>af",
			function()
				require("sidekick").nes_fetch()
			end,
			desc = "Fetch Next Edit Suggestions",
		},
		{
			"<leader>ax",
			function()
				require("sidekick").nes_clear()
			end,
			desc = "Clear Edit Suggestions",
		},

		-- Utility
		{
			"<leader>ah",
			"<cmd>checkhealth sidekick<cr>",
			desc = "Sidekick Health Check",
		},
	},
}
