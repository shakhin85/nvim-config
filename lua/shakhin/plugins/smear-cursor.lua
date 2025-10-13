return {
	"sphamba/smear-cursor.nvim",
	opts = {
		-- Smear behavior
		smear_between_buffers = true,
		smear_between_neighbor_lines = true,
		scroll_buffer_space = true,
		smear_insert_mode = true,

		-- Animation dynamics - Normal mode
		stiffness = 0.8, -- Higher = faster animation (range: 0-1)
		trailing_stiffness = 0.6, -- Stiffness of trailing effect
		damping = 0.95, -- Higher = less elastic (range: 0-1)
		trailing_exponent = 0.5, -- Controls trail fade

		-- Animation dynamics - Insert mode
		stiffness_insert_mode = 0.7,
		trailing_stiffness_insert_mode = 0.7,
		damping_insert_mode = 0.95,

		-- Visual customization
		cursor_color = "#d9e0ee", -- Match Catppuccin or use "none" for text color
		transparent_bg_fallback_color = "#1e1e2e", -- Catppuccin background

		-- Performance
		time_interval = 17, -- Draw frequency in milliseconds

		-- Advanced settings
		legacy_computing_symbols_support = false,
		hide_target_hack = true,
	},
}
