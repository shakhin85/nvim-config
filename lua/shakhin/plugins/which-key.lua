return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
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

		-- Register AI/Sidekick keymaps
		wk.add({
			{ "<leader>a", group = "AI/Sidekick" },
			{ "<leader>ai", desc = "Open Sidekick" },
			{ "<leader>an", desc = "Next Edit Suggestions" },
			{ "<leader>at", desc = "AI Terminal" },
			{ "<leader>ap", desc = "AI Prompts" },
		})

		-- Register formatting keymaps
		wk.add({
			{ "<leader>F", group = "Format" },
			{ "<leader>Fp", desc = "Format file or range" },
			{ "<leader>Fa", desc = "Format with autopep8" },
			{ "<leader>Fr", desc = "Format with ruff" },
			{ "<leader>Fs", desc = "Format SQL/MDX selection" },
		})

		-- Register Molten/Jupyter keymaps
		wk.add({
			{ "<leader>m", group = "Molten/Jupyter" },
			{ "<leader>mi", desc = "Initialize kernel" },
			{ "<leader>mI", desc = "Init Python3 kernel" },
			{ "<leader>me", desc = "Evaluate line/selection" },
			{ "<leader>mr", desc = "Re-evaluate cell" },
			{ "<leader>mo", desc = "Show output" },
			{ "<leader>mh", desc = "Hide output" },
			{ "<leader>md", desc = "Delete cell" },
			{ "<leader>mx", desc = "Interrupt kernel" },
			{ "<leader>mk", desc = "Kernel info" },
			{ "<leader>ms", desc = "Save session" },
			{ "<leader>ml", desc = "Load session" },
			{ "<leader>mX", desc = "Run all cells" },
			{ "<leader>mH", desc = "Activate Hydra menu" },
		})

		-- Register Database keymaps
		wk.add({
			{ "<leader>d", group = "Database" },
			{ "<leader>db", desc = "Toggle DBUI" },
			{ "<leader>df", desc = "Find DB buffer" },
			{ "<leader>da", desc = "Add DB connection" },
			{ "<leader>de", desc = "Execute SQL query" },
		})

		-- Register Telescope keymaps
		wk.add({
			{ "<leader>f", group = "Find/Telescope" },
			{ "<leader>ff", desc = "Find files (depth 15)" },
			{ "<leader>fr", desc = "Recent files" },
			{ "<leader>fg", desc = "Live grep (depth 10)" },
			{ "<leader>fc", desc = "Find string under cursor" },
			{ "<leader>fk", desc = "Find keymaps" },
			{ "<leader>fR", desc = "Find files by REGEX" },
			{ "<leader>fF", desc = "Find ALL files (full)" },
			{ "<leader>fG", desc = "Live grep (full)" },
			{ "<leader>f.", desc = "Find in current dir" },
			{ "<leader>fb", desc = "Find binaries (>100KB)" },
		})
	end,
}
