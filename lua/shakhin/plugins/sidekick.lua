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
			-- Next Edit Suggestions (NES) - FULLY ENABLED
			nes = {
				enabled = true,
				-- Debounce time in ms before fetching suggestions
				debounce = 100,
				-- Trigger events for NES
				trigger = {
					events = { "InsertLeave", "TextChanged", "User SidekickNesDone" },
				},
				-- Clear suggestions on these events
				clear = {
					events = { "TextChangedI", "TextChanged", "BufWritePre", "InsertEnter" },
					esc = true,
				},
				-- Inline diff display
				diff = {
					inline = "words",
				},
			},

			-- CLI configuration
			cli = {
				-- Watch for changes in CLI output
				watch = true,
				-- Window configuration
				win = {
					-- Layout: "right", "left", "top", "bottom", or "float"
					layout = "float",
					-- Float window options
					float = {
						width = 0.9,
						height = 0.85,
					},
					-- Split window options
					split = {
						width = 80,
						height = 20,
					},
					-- Window keymaps
					keys = {
						hide_n = { "q", "hide", mode = "n" },
						hide_t = { "<c-q>", "hide" },
						win_p = { "<c-w>p", "blur" },
						prompt = { "<c-p>", "prompt" },
					},
				},
				-- Terminal multiplexer configuration (for session persistence)
				mux = {
					backend = "zellij", -- or "tmux"
					enabled = false, -- Disable mux on Windows
				},
				-- Context functions for prompts
				context = {},
				-- Prompt library (custom prompts)
				prompts = {
					changes = "Can you review my changes?",
					diagnostics = "Can you help me fix the diagnostics in {file}?\n{diagnostics}",
					review = "Can you review {file} for any issues or improvements?",
					explain = "Explain the following code in detail:\n{selection}",
					document = "Generate comprehensive documentation for:\n{selection}",
					optimize = "Suggest optimizations for:\n{selection}",
					test = "Generate comprehensive unit tests for:\n{selection}",
					refactor = "Refactor the following code:\n{selection}",
					debug = "Help debug this code:\n{selection}",
					simplify = "Simplify this code:\n{selection}",
				},
			},

			-- Copilot Language Server configuration
			copilot = {
				status = {
					enabled = true, -- Track Copilot status
				},
			},

			-- Signs configuration
			signs = {
				enabled = true,
				icon = " ",
			},

			-- Jump configuration
			jump = {
				jumplist = true, -- add an entry to the jumplist
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

		-- AI Provider Specific Terminals
		{
			"<leader>ac",
			function()
				require("sidekick.cli").toggle({ name = "claude", focus = true })
			end,
			desc = "Sidekick Claude",
			mode = { "n", "v" },
		},
		{
			"<leader>am",
			function()
				require("sidekick.cli").toggle({ name = "gemini", focus = true })
			end,
			desc = "Sidekick Gemini",
			mode = { "n", "v" },
		},
		{
			"<leader>ag",
			function()
				require("sidekick.cli").toggle({ name = "grok", focus = true })
			end,
			desc = "Sidekick Grok",
			mode = { "n", "v" },
		},
		{
			"<leader>ao",
			function()
				require("sidekick.cli").toggle({ name = "copilot", focus = true })
			end,
			desc = "Sidekick Copilot",
			mode = { "n", "v" },
		},

		-- Prompt Selection
		{
			"<leader>ap",
			function()
				require("sidekick.cli").prompt()
			end,
			desc = "Sidekick Select Prompt",
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
