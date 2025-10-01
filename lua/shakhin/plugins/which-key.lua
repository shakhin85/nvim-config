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
	end,
}
