return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		preset = "modern",
		delay = 300,
		icons = {
			mappings = true,
			keys = {},
		},
		win = {
			border = "rounded",
		},
	},
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer Local Keymaps (which-key)",
		},
	},
	config = function()
		local wk = require("which-key")

		-- Main groups and all keymaps organized by category
		wk.add({
			-- ============================================
			-- CORE GROUPS
			-- ============================================
			{ "<leader>s", group = "Split/Window" },
			{ "<leader>sv", desc = "Split vertically" },
			{ "<leader>sh", desc = "Split horizontally" },
			{ "<leader>se", desc = "Equal splits" },
			{ "<leader>sx", desc = "Close split" },

			{ "<leader>t", group = "Tab/Terminal" },
			{ "<leader>to", desc = "Open new tab" },
			{ "<leader>tx", desc = "Close tab" },
			{ "<leader>tn", desc = "Next tab" },
			{ "<leader>tP", desc = "Previous tab" },
			{ "<leader>tF", desc = "Open buffer in new tab" },

			-- Terminal subgroup
			{ "<leader>tt", desc = "Toggle terminal" },
			{ "<leader>tf", desc = "Floating terminal" },
			{ "<leader>th", desc = "Horizontal terminal" },
			{ "<leader>tv", desc = "Vertical terminal" },
			{ "<leader>t1", desc = "Terminal 1" },
			{ "<leader>t2", desc = "Terminal 2" },
			{ "<leader>t3", desc = "Terminal 3" },
			{ "<leader>tcc", desc = "Clear terminal" },

			-- Python terminal keymaps
			{ "<leader>tp", desc = "Run Python file" },
			{ "<leader>ti", desc = "Run in IPython" },
			{ "<leader>tI", desc = "Clean IPython" },
			{ "<leader>tR", desc = "Python REPL" }, -- Changed from tP to avoid conflict

			{ "<leader>b", group = "Buffer" },
			{ "<leader>bd", desc = "Delete buffer" },
			{ "<leader>ba", desc = "Delete all buffers" },
			{ "<leader>bo", desc = "Keep only current" },
			{ "<leader>bs", desc = "Show buffer list" },

			-- ============================================
			-- TELESCOPE (Find)
			-- ============================================
			{ "<leader>f", group = "Find (Telescope)" },
			{ "<leader>ff", desc = "Find files" },
			{ "<leader>fF", desc = "Find files (fast)" },
			{ "<leader>fr", desc = "Recent files" },
			{ "<leader>fg", desc = "Grep string" },
			{ "<leader>fG", desc = "Grep (limited depth)" },
			{ "<leader>fc", desc = "String under cursor" },
			{ "<leader>ft", desc = "Find todos" },
			{ "<leader>fk", desc = "Find keymaps" },
			{ "<leader>f.", desc = "Files in current dir" },
			{ "<leader>fp", desc = "Format file/range" }, -- Changed from <leader>mp to avoid conflict

			-- ============================================
			-- FILE EXPLORER
			-- ============================================
			{ "<leader>e", group = "Explorer" },
			{ "<leader>ee", desc = "Toggle explorer" },
			{ "<leader>ef", desc = "Explorer on file" },
			{ "<leader>ec", desc = "Collapse explorer" },
			{ "<leader>er", desc = "Refresh explorer" },

			-- ============================================
			-- HARPOON (changed from <leader>a to <leader>j for "jump")
			-- ============================================
			{ "<leader>j", group = "Harpoon (Jump)" },
			{ "<leader>ja", desc = "Add file" },
			{ "<leader>jm", desc = "Toggle menu" },
			{ "<leader>j1", desc = "Jump to file 1" },
			{ "<leader>j2", desc = "Jump to file 2" },
			{ "<leader>j3", desc = "Jump to file 3" },
			{ "<leader>j4", desc = "Jump to file 4" },
			{ "<leader>jc", desc = "Clear list" },
			{ "<leader>jr", desc = "Remove current" },
			{ "<leader>jt", desc = "Telescope harpoon" },

			-- ============================================
			-- GIT
			-- ============================================
			{ "<leader>g", group = "Git" },

			-- GitSigns hunks
			{ "<leader>h", group = "Git Hunk" },
			{ "<leader>hs", desc = "Stage hunk" },
			{ "<leader>hr", desc = "Reset hunk" },
			{ "<leader>hS", desc = "Stage buffer" },
			{ "<leader>hu", desc = "Undo stage hunk" },
			{ "<leader>hR", desc = "Reset buffer" },
			{ "<leader>hp", desc = "Preview hunk" },
			{ "<leader>hb", desc = "Blame line" },
			{ "<leader>hd", desc = "Diff this" },
			{ "<leader>hD", desc = "Diff this ~" },

			-- Git tools
			{ "<leader>gb", desc = "Toggle blame" },
			{ "<leader>gB", desc = "Blame window" },
			{ "<leader>gd", desc = "Diffview open" },
			{ "<leader>gc", desc = "Diffview close" },
			{ "<leader>gh", desc = "File history" },
			{ "<leader>gH", desc = "Current file history" },
			{ "<leader>gs", desc = "Git search" },
			{ "<leader>gS", desc = "Git search (adv)" },
			{ "<leader>gl", desc = "Git log" },
			{ "<leader>gL", desc = "Git log (adv)" },

			-- ============================================
			-- LSP & DIAGNOSTICS
			-- ============================================
			{ "<leader>l", group = "LSP" },
			{ "<leader>lf", desc = "Format (Python)" }, -- Changed from <leader>f
			{ "<leader>lr", desc = "Rename" }, -- Alias for <leader>rn
			{ "<leader>la", desc = "Code action" }, -- Alias for <leader>ca
			{ "<leader>ls", desc = "LSP restart" }, -- Alias for <leader>rs
			{ "<leader>ld", desc = "Line diagnostics" }, -- Alias for <leader>d
			{ "<leader>lD", desc = "Buffer diagnostics" }, -- Alias for <leader>D
			{ "<leader>lo", desc = "Organize imports" }, -- Alias for <leader>oi

			-- Keep original LSP keymaps too
			{ "<leader>ca", desc = "Code action" },
			{ "<leader>rn", desc = "Rename" },
			{ "<leader>rs", desc = "Restart LSP" },
			{ "<leader>d", desc = "Line diagnostics" },
			{ "<leader>D", desc = "Buffer diagnostics" },
			{ "<leader>oi", desc = "Organize imports" },

			-- ============================================
			-- FORMATTING
			-- ============================================
			{ "<leader>m", group = "Format" },
			{ "<leader>mp", desc = "Format (default)" },
			{ "<leader>ma", desc = "Format (autopep8)" },
			{ "<leader>mr", desc = "Format (ruff)" },

			-- ============================================
			-- REFACTORING
			-- ============================================
			{ "<leader>r", group = "Refactor" },
			{ "<leader>re", desc = "Extract function", mode = "x" },
			{ "<leader>rf", desc = "Extract to file", mode = "x" },
			{ "<leader>rv", desc = "Extract variable", mode = "x" },
			{ "<leader>rI", desc = "Inline function" },
			{ "<leader>ri", desc = "Inline variable" },
			{ "<leader>rb", desc = "Extract block" },
			{ "<leader>rbf", desc = "Extract block to file" },
			{ "<leader>rp", desc = "Debug print" },
			{ "<leader>rd", desc = "Debug print var" }, -- Changed from rv to avoid conflict
			{ "<leader>rc", desc = "Debug cleanup" },
			{ "<leader>rr", desc = "Refactor menu" },

			-- ============================================
			-- WORKSPACE/SESSION
			-- ============================================
			{ "<leader>w", group = "Workspace/Session" },
			{ "<leader>wr", desc = "Restore session" },
			{ "<leader>ws", desc = "Save session" },

			-- ============================================
			-- AI/SIDEKICK (changed from <leader>a to <leader>A)
			-- ============================================
			{ "<leader>A", group = "AI/Sidekick" },
			{ "<leader>Ai", desc = "Open Sidekick" },
			{ "<leader>An", desc = "Next Edit Suggestions" },
			{ "<leader>At", desc = "AI Terminal" },
			{ "<leader>Ap", desc = "AI Prompts" },

			-- ============================================
			-- MISC
			-- ============================================
			{ "<leader>lg", desc = "LazyGit" },
			{ "<leader>pt", desc = "Toggle theme" },
			{ "<leader>nhl", desc = "Clear highlights" },
			{ "<leader>+", desc = "Increment number" },
			{ "<leader>-", desc = "Decrement number" },

			-- ============================================
			-- TOGGLE
			-- ============================================
			{ "<leader>T", group = "Toggle" },
			{ "<leader>tb", desc = "Line blame" },
			{ "<leader>td", desc = "Deleted lines" },

			-- ============================================
			-- NAVIGATION (non-leader)
			-- ============================================
			{ "g", group = "Go to" },
			{ "gR", desc = "LSP references" },
			{ "gD", desc = "LSP declaration" },
			{ "gd", desc = "LSP definitions" },
			{ "gi", desc = "LSP implementations" },
			{ "gt", desc = "LSP type definitions" },

			{ "[", group = "Previous" },
			{ "[c", desc = "Previous hunk" },
			{ "[d", desc = "Previous diagnostic" },
			{ "[t", desc = "Previous todo" },

			{ "]", group = "Next" },
			{ "]c", desc = "Next hunk" },
			{ "]d", desc = "Next diagnostic" },
			{ "]t", desc = "Next todo" },

			{ "z", group = "Fold" },
			{ "zR", desc = "Open all folds" },
			{ "zM", desc = "Close all folds" },
			{ "zr", desc = "Fold less" },
			{ "zm", desc = "Fold more" },
			{ "zp", desc = "Peek fold" },

			-- ============================================
			-- WINDOW NAVIGATION (non-leader)
			-- ============================================
			{ "<C-h>", desc = "Window left" },
			{ "<C-j>", desc = "Window down" },
			{ "<C-k>", desc = "Window up" },
			{ "<C-l>", desc = "Window right" },

			{ "<A-h>", desc = "Decrease width" },
			{ "<A-l>", desc = "Increase width" },
			{ "<A-j>", desc = "Decrease height" },
			{ "<A-k>", desc = "Increase height" },

			-- ============================================
			-- SPECIAL KEYS
			-- ============================================
			{ "<Tab>", desc = "Next buffer" },
			{ "<S-Tab>", desc = "Previous buffer" },
			{ "<C-e>", desc = "Harpoon menu" },
			{ "<C-\\>", desc = "Toggle terminal" },
			{ "K", desc = "Hover docs" },

			-- Insert mode
			{ "jk", desc = "Exit insert mode", mode = "i" },
		})
	end,
}
