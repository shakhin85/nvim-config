-- oil.nvim - Edit filesystem like a buffer
-- Usage:
--   <leader>- : Open parent directory in oil
--   <leader>_ : Open current working directory in oil
--   Once in oil buffer:
--     <CR>    : Open file/directory
--     -       : Go to parent directory
--     _       : Go to cwd
--     g.      : Toggle hidden files
--     <C-v>   : Open in vsplit
--     <C-x>   : Open in split
--     Edit filenames directly like text, then save buffer to apply changes!

return {
	"stevearc/oil.nvim",
	cmd = "Oil",
	keys = {
		{ "<leader>-", "<cmd>Oil<cr>", desc = "Open parent directory in Oil" },
		{
			"<leader>_",
			function()
				require("oil").open(vim.fn.getcwd())
			end,
			desc = "Open cwd in Oil",
		},
	},
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		-- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
		-- Set to false if you still want to use netrw
		default_file_explorer = false, -- Keep nvim-tree as default, use oil.nvim on demand

		-- Id is automatically added at the beginning, and name at the end
		-- See :help oil-columns
		columns = {
			"icon",
			"permissions",
			"size",
			"mtime",
		},

		-- Buffer-local options to use for oil buffers
		buf_options = {
			buflisted = false,
			bufhidden = "hide",
		},

		-- Window-local options to use for oil buffers
		win_options = {
			wrap = false,
			signcolumn = "no",
			cursorcolumn = false,
			foldcolumn = "0",
			spell = false,
			list = false,
			conceallevel = 3,
			concealcursor = "nvic",
		},

		-- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
		delete_to_trash = true,

		-- Skip the confirmation popup for simple operations
		skip_confirm_for_simple_edits = false,

		-- Selecting a new/moved/renamed file or directory will prompt you to save changes first
		prompt_save_on_select_new_entry = true,

		-- Oil will automatically delete hidden buffers after this delay
		-- You can set the delay to false to disable cleanup entirely
		-- Note that the cleanup process only starts when none of the oil buffers are currently displayed
		cleanup_delay_ms = 2000,

		-- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
		-- options with a `callback` (e.g. { callback = function() ... end, desc = "", mode = "n" })
		keymaps = {
			["g?"] = "actions.show_help",
			["<CR>"] = "actions.select",
			["<C-v>"] = "actions.select_vsplit",
			["<C-x>"] = "actions.select_split",
			["<C-t>"] = "actions.select_tab",
			["<C-p>"] = "actions.preview",
			["<C-c>"] = "actions.close",
			["<C-l>"] = "actions.refresh",
			["-"] = "actions.parent",
			["_"] = "actions.open_cwd",
			["`"] = "actions.cd",
			["~"] = "actions.tcd",
			["gs"] = "actions.change_sort",
			["gx"] = "actions.open_external",
			["g."] = "actions.toggle_hidden",
			["g\\"] = "actions.toggle_trash",
		},

		-- Set to false to disable all of the above keymaps
		use_default_keymaps = true,

		view_options = {
			-- Show files and directories that start with "."
			show_hidden = false,

			-- This function defines what is considered a "hidden" file
			is_hidden_file = function(name, bufnr)
				return vim.startswith(name, ".")
			end,

			-- This function defines what will never be shown, even when `show_hidden` is set
			is_always_hidden = function(name, bufnr)
				return name == ".." or name == ".git"
			end,

			-- Sort file names in a more intuitive order for humans.
			-- Can be "case_sensitive", "case_insensitive", or a custom sort function
			natural_order = true,

			sort = {
				-- sort order can be "asc" or "desc"
				{ "type", "asc" }, -- directories first
				{ "name", "asc" },
			},
		},

		-- Configuration for the floating window in oil.open_float
		float = {
			padding = 2,
			max_width = 90,
			max_height = 40,
			border = "rounded",
			win_options = {
				winblend = 0,
			},
			-- This is the config that will be passed to nvim_open_win.
			-- Change values here to customize the layout
			override = function(conf)
				return conf
			end,
		},

		-- Configuration for the actions floating preview window
		preview = {
			max_width = 0.9,
			min_width = { 40, 0.4 },
			width = nil,
			max_height = 0.9,
			min_height = { 5, 0.1 },
			height = nil,
			border = "rounded",
			win_options = {
				winblend = 0,
			},
		},

		-- Configuration for the floating progress window
		progress = {
			max_width = 0.9,
			min_width = { 40, 0.4 },
			width = nil,
			max_height = { 10, 0.9 },
			min_height = { 5, 0.1 },
			height = nil,
			border = "rounded",
			minimized_border = "none",
			win_options = {
				winblend = 0,
			},
		},
	},
}
