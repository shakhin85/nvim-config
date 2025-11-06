-- snacks.nvim - Collection of useful utilities by folke
-- A Swiss Army knife plugin that provides many helpful features
--
-- Features enabled:
--   - bigfile: Disable heavy features for large files (>1MB)
--   - quickfile: Better quickfix/loclist handling
--   - statuscolumn: Enhanced statuscolumn with git signs
--   - words: Highlight word under cursor throughout buffer
--   - input/select: Better UI for vim.ui.input and vim.ui.select
--   - lazygit: Integration with lazygit
--   - gitbrowse: Open git URLs in browser
--   - bufdelete: Smart buffer deletion
--
-- Keymaps:
--   <leader>gg  : Open lazygit
--   <leader>gb  : Show git blame for current line
--   <leader>gB  : Open file in git browser (GitHub/GitLab)
--   <leader>bd  : Delete buffer (smarter than :bd)
--   <leader>un  : Dismiss all notifications
--   <leader>gf  : Open lazygit file history

return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false, -- Load immediately for core utilities
	opts = {
		-- Automatically disable heavy features for large files
		bigfile = {
			enabled = true,
			size = 1024 * 1024, -- 1MB threshold
			-- Features to disable for big files
			setup = function(ctx)
				vim.cmd([[NoMatchParen]]) -- Disable matching parentheses
				vim.opt_local.foldmethod = "manual"
				vim.opt_local.spell = false
				vim.opt_local.swapfile = false
				vim.opt_local.undofile = false
				vim.opt_local.breakindent = false
				vim.opt_local.colorcolumn = ""
				vim.opt_local.statuscolumn = ""
				vim.opt_local.signcolumn = "no"
				vim.opt_local.foldcolumn = "0"
				vim.opt_local.winbar = ""
				-- Disable syntax highlighting
				vim.schedule(function()
					vim.bo[ctx.buf].syntax = ctx.ft
				end)
			end,
		},

		-- Better quickfix list handling
		quickfile = {
			enabled = true,
		},

		-- Enhanced statuscolumn with git signs integration
		-- This provides a better sign column with line numbers and git changes
		statuscolumn = {
			enabled = true,
			left = { "mark", "sign" }, -- priority of signs on the left (high to low)
			right = { "fold", "git" }, -- priority of signs on the right (high to low)
			folds = {
				open = true, -- show open fold icons
				git_hl = false, -- use git sign hl for fold icons
			},
			git = {
				patterns = { "GitSign", "MiniDiffSign" }, -- patterns to match git signs
			},
			refresh = 50, -- refresh at most every 50ms
		},

		-- Highlight all instances of word under cursor
		-- Similar to vim-illuminate but lighter
		words = {
			enabled = true,
			debounce = 200, -- ms delay before highlighting
			notify_jump = false, -- don't show notification on jump
			notify_end = false, -- don't show notification when reaching end
			foldopen = true, -- open folds when jumping
			jumplist = true, -- add jumps to jumplist
			modes = { "n" }, -- only in normal mode
		},

		-- Better vim.ui.input (for things like rename, etc.)
		input = {
			enabled = true,
			icon = " ",
			icon_hl = "SnacksInputIcon",
			icon_pos = "left",
			prompt_pos = "title",
			win = { style = "input" },
			expand = true,
		},

		-- Scroll animations (optional, set to true if you want smooth scrolling)
		scroll = {
			enabled = false, -- Disable by default for performance
			animate = {
				duration = { step = 15, total = 250 },
				easing = "linear",
			},
			spamming = 10, -- threshold for spamming detection
		},

		-- Dim inactive windows (optional)
		dim = {
			enabled = false, -- Disable by default, enable if you like it
			scope = {
				min_size = 5,
				suf = true,
			},
			animate = {
				enabled = vim.fn.has("nvim-0.10") == 1,
				easing = "outQuad",
				duration = {
					step = 10,
					total = 150,
				},
			},
		},

		-- Dashboard (disabled, you already have alpha.nvim)
		dashboard = {
			enabled = false,
		},

		-- Notifications (disabled, you already have nvim-notify)
		notifier = {
			enabled = false,
		},

		-- Indent scope animations (optional)
		indent = {
			enabled = false, -- You have indent-blankline already
		},

		-- Zen mode (optional)
		zen = {
			enabled = false,
		},
	},

	keys = {
		-- Git integration
		{
			"<leader>gg",
			function()
				Snacks.lazygit()
			end,
			desc = "Lazygit (snacks)",
		},
		{
			"<leader>gf",
			function()
				Snacks.lazygit.log_file()
			end,
			desc = "Lazygit File History",
		},
		{
			"<leader>gb",
			function()
				Snacks.git.blame_line()
			end,
			desc = "Git Blame Line (snacks)",
		},
		{
			"<leader>gB",
			function()
				Snacks.gitbrowse()
			end,
			desc = "Git Browse (open in browser)",
		},

		-- Buffer management
		{
			"<leader>bd",
			function()
				Snacks.bufdelete()
			end,
			desc = "Delete Buffer (snacks)",
		},
		{
			"<leader>bo",
			function()
				Snacks.bufdelete.other()
			end,
			desc = "Delete Other Buffers",
		},

		-- Utility
		{
			"<leader>un",
			function()
				Snacks.notifier.hide()
			end,
			desc = "Dismiss All Notifications",
		},

		-- Word navigation (alternative to *, # with better behavior)
		{
			"]]",
			function()
				Snacks.words.jump(vim.v.count1)
			end,
			desc = "Next Reference",
			mode = { "n", "t" },
		},
		{
			"[[",
			function()
				Snacks.words.jump(-vim.v.count1)
			end,
			desc = "Prev Reference",
			mode = { "n", "t" },
		},

		-- Create scratch buffer
		{
			"<leader>.",
			function()
				Snacks.scratch()
			end,
			desc = "Toggle Scratch Buffer",
		},
		{
			"<leader>,",
			function()
				Snacks.scratch.select()
			end,
			desc = "Select Scratch Buffer",
		},
	},

	config = function(_, opts)
		local snacks = require("snacks")
		snacks.setup(opts)

		-- Optional: Set up autocommands for additional features
		vim.api.nvim_create_autocmd("User", {
			pattern = "VeryLazy",
			callback = function()
				-- Create some additional commands
				vim.api.nvim_create_user_command("LazyGitCurrentFile", function()
					snacks.lazygit.log_file()
				end, { desc = "Lazygit Current File History" })

				vim.api.nvim_create_user_command("GitBlame", function()
					snacks.git.blame_line()
				end, { desc = "Show Git Blame for Current Line" })
			end,
		})

		-- Set up statuscolumn highlight groups to match your colorscheme
		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = function()
				-- You can customize colors here if needed
				-- vim.api.nvim_set_hl(0, "SnacksIndent", { fg = "#3b4261" })
			end,
		})
	end,
}
