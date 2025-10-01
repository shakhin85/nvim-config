-- COMMENTED OUT: Copilot.lua is now configured inside sidekick.lua as a dependency
-- Uncomment this file and remove copilot config from sidekick.lua to use standalone

return {}

--[[ return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	config = function()
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
			-- Don't override handlers - let sidekick handle status notifications automatically
		})
	end,
} ]]
