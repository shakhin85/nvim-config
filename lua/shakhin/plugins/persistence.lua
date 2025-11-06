-- persistence.nvim - Simple session management
-- Better alternative to auto-session with more reliable session handling
--
-- Usage:
--   Sessions are automatically saved per directory
--   <leader>qs : Restore session for current directory
--   <leader>ql : Restore last session (regardless of directory)
--   <leader>qd : Don't save current session (stop persistence)
--
-- How it works:
--   - Automatically saves session when you exit Neovim
--   - Sessions are saved to ~/.local/state/nvim/sessions/
--   - Each directory gets its own session file
--   - Restores buffers, windows, tabs, and working directory

return {
	"folke/persistence.nvim",
	event = "BufReadPre", -- Load early to catch session restore
	opts = {
		-- Directory where session files are saved
		dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),

		-- Session options to save
		options = {
			"buffers", -- Save all buffers
			"curdir", -- Save current directory
			"tabpages", -- Save tab pages
			"winsize", -- Save window sizes
			-- Note: We don't save 'help' to avoid issues with help windows
		},

		-- Automatically save session on exit
		-- Set to false if you want manual control
		pre_save = nil, -- Function to run before saving session

		-- Automatically load session on startup
		-- Set to false if you prefer manual restoration
		-- (We keep this false and use keymaps for explicit control)
		save_empty = false, -- Don't save session if there are no buffers
	},

	keys = {
		{
			"<leader>qs",
			function()
				require("persistence").load()
			end,
			desc = "Restore Session (cwd)",
		},
		{
			"<leader>ql",
			function()
				require("persistence").load({ last = true })
			end,
			desc = "Restore Last Session",
		},
		{
			"<leader>qd",
			function()
				require("persistence").stop()
			end,
			desc = "Don't Save Current Session",
		},
		{
			"<leader>qw",
			function()
				require("persistence").save()
			end,
			desc = "Save Session Now",
		},
	},

	config = function(_, opts)
		require("persistence").setup(opts)

		-- Optional: Auto-load session on startup for specific directories
		-- Uncomment if you want automatic session restoration
		-- vim.api.nvim_create_autocmd("VimEnter", {
		-- 	group = vim.api.nvim_create_augroup("persistence_auto_restore", { clear = true }),
		-- 	callback = function()
		-- 		-- Only load session if nvim was started with no arguments
		-- 		if vim.fn.argc() == 0 then
		-- 			require("persistence").load()
		-- 		end
		-- 	end,
		-- 	nested = true,
		-- })
	end,
}
