return {
	"benlubas/molten-nvim",
	build = ":UpdateRemotePlugins",
	init = function()
		vim.g.molten_image_provider = "none"
		vim.g.molten_output_win_max_height = 20
		vim.g.molten_auto_open_output = false
		vim.g.molten_wrap_output = true
		vim.g.molten_virt_text_output = true
		vim.g.molten_virt_lines_off_by_1 = true
	end,
	config = function()
		-- Основные команды (используя точные названия из Molten)
		vim.keymap.set("n", "<leader>mi", ":MoltenInit python3<CR>", { desc = "Initialize Molten" })
		vim.keymap.set("n", "<leader>ml", ":MoltenEvaluateLine<CR>", { desc = "Evaluate line" })
		vim.keymap.set("v", "<leader>mr", ":<C-u>MoltenEvaluateVisual<CR>", { desc = "Evaluate visual selection" })
		vim.keymap.set("n", "<leader>ma", ":MoltenEvaluateArgument<CR>", { desc = "Evaluate argument" })
		vim.keymap.set("n", "<leader>mo", ":MoltenEvaluateOperator<CR>", { desc = "Evaluate operator" })

		-- Повторное выполнение
		vim.keymap.set("n", "<leader>rc", ":MoltenReevaluateCell<CR>", { desc = "Re-evaluate cell" })
		vim.keymap.set("n", "<leader>ra", ":MoltenReevaluateAll<CR>", { desc = "Re-evaluate all cells" })

		-- Управление виртуальным текстом
		vim.keymap.set("n", "<leader>mv", ":MoltenToggleVirtual<CR>", { desc = "Toggle virtual text" })

		-- Навигация
		vim.keymap.set("n", "]c", ":MoltenNext<CR>", { desc = "Next cell" })
		vim.keymap.set("n", "[c", ":MoltenPrev<CR>", { desc = "Previous cell" })

		-- Управление ядрами
		vim.keymap.set("n", "<leader>mk", ":MoltenInterrupt<CR>", { desc = "Interrupt kernel" })
		vim.keymap.set("n", "<leader>mK", ":MoltenRestart<CR>", { desc = "Restart kernel" })

		-- F5 для повторного выполнения ячейки
		vim.keymap.set("n", "<F5>", ":MoltenReevaluateCell<CR>", { desc = "Re-evaluate cell" })
	end,
}
