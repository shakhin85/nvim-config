return {
	"MeanderingProgrammer/render-markdown.nvim",
	ft = { "markdown" },
	dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
	opts = {
		-- Render style
		heading = {
			-- Enable heading rendering with icons
			enabled = true,
			-- Icons for each heading level
			icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
			-- Highlight for each heading level
			backgrounds = {
				"RenderMarkdownH1Bg",
				"RenderMarkdownH2Bg",
				"RenderMarkdownH3Bg",
				"RenderMarkdownH4Bg",
				"RenderMarkdownH5Bg",
				"RenderMarkdownH6Bg",
			},
			foregrounds = {
				"RenderMarkdownH1",
				"RenderMarkdownH2",
				"RenderMarkdownH3",
				"RenderMarkdownH4",
				"RenderMarkdownH5",
				"RenderMarkdownH6",
			},
		},
		code = {
			-- Enable code block rendering
			enabled = true,
			-- Style: 'full' (default), 'normal', 'language', or 'none'
			style = "full",
			-- Width: 'full' or 'block'
			width = "full",
			-- Highlight for code blocks
			highlight = "RenderMarkdownCode",
		},
		bullet = {
			-- Enable list bullet rendering
			enabled = true,
			-- Icons for different list levels
			icons = { "●", "○", "◆", "◇" },
		},
		checkbox = {
			-- Enable checkbox rendering
			enabled = true,
			unchecked = { icon = "󰄱 " },
			checked = { icon = "󰱒 " },
		},
		quote = {
			-- Enable quote rendering
			enabled = true,
			icon = "▋",
		},
		-- Render in normal mode (toggle with command)
		render_modes = { "n", "c" },
	},
	config = function(_, opts)
		require("render-markdown").setup(opts)

		-- Keymaps for markdown files only
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "markdown",
			callback = function(args)
				local bufnr = args.buf
				vim.keymap.set("n", "<leader>mr", "<cmd>RenderMarkdown toggle<cr>", {
					desc = "Toggle Markdown rendering",
					buffer = bufnr,
				})
			end,
		})
	end,
}
