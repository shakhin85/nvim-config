return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")

		-- REQUIRED
		harpoon:setup({
			settings = {
				save_on_toggle = false,
				sync_on_ui_close = true,
				key = function()
					return vim.loop.cwd()
				end,
			},
		})

		-- Кеймапы для Harpoon
		local keymap = vim.keymap.set

		-- Основные команды
		keymap("n", "<leader>ja", function()
			harpoon:list():add()
		end, { desc = "Add file to harpoon" })
		keymap("n", "<C-e>", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "Toggle harpoon menu" })

		-- Быстрая навигация по файлам (1-4)
		-- keymap("n", "<C-h>", function()
		-- 	harpoon:list():select(1)
		-- end, { desc = "Harpoon file 1" })
		keymap("n", "<leader>j2-removed", function()
			harpoon:list():select(2)
		end, { desc = "Harpoon file 2" })
		keymap("n", "<leader>j3-removed", function()
			harpoon:list():select(3)
		end, { desc = "Harpoon file 3" })
		keymap("n", "<leader>j4-removed", function()
			harpoon:list():select(4)
		end, { desc = "Harpoon file 4" })

		-- Альтернативные кеймапы с leader
		keymap("n", "<leader>j1", function()
			harpoon:list():select(1)
		end, { desc = "Go to harpoon file 1" })
		keymap("n", "<leader>j2", function()
			harpoon:list():select(2)
		end, { desc = "Go to harpoon file 2" })
		keymap("n", "<leader>j3", function()
			harpoon:list():select(3)
		end, { desc = "Go to harpoon file 3" })
		keymap("n", "<leader>j4", function()
			harpoon:list():select(4)
		end, { desc = "Go to harpoon file 4" })

		-- Навигация вперед/назад по списку
		keymap("n", "<C-S-P>", function()
			harpoon:list():prev()
		end, { desc = "Previous harpoon file" })
		keymap("n", "<C-S-N>", function()
			harpoon:list():next()
		end, { desc = "Next harpoon file" })

		-- Дополнительные команды
		keymap("n", "<leader>jc", function()
			harpoon:list():clear()
		end, { desc = "Clear harpoon list" })
		keymap("n", "<leader>jr", function()
			harpoon:list():remove()
		end, { desc = "Remove current file from harpoon" })

		-- Интеграция с Telescope (если нужно)
		keymap("n", "<leader>jt", function()
			local conf = require("telescope.config").values
			local function toggle_telescope(harpoon_files)
				local file_paths = {}
				for _, item in ipairs(harpoon_files.items) do
					table.insert(file_paths, item.value)
				end

				require("telescope.pickers")
					.new({}, {
						prompt_title = "Harpoon",
						finder = require("telescope.finders").new_table({
							results = file_paths,
						}),
						previewer = conf.file_previewer({}),
						sorter = conf.generic_sorter({}),
					})
					:find()
			end
			toggle_telescope(harpoon:list())
		end, { desc = "Open harpoon in telescope" })

		-- Команды для удобства
		vim.api.nvim_create_user_command("HarpoonAdd", function()
			harpoon:list():add()
			vim.notify("Added to harpoon: " .. vim.fn.expand("%:t"), vim.log.levels.INFO)
		end, { desc = "Add current file to harpoon" })

		vim.api.nvim_create_user_command("HarpoonMenu", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "Toggle harpoon menu" })

		vim.api.nvim_create_user_command("HarpoonClear", function()
			harpoon:list():clear()
			vim.notify("Harpoon list cleared", vim.log.levels.INFO)
		end, { desc = "Clear harpoon list" })

		-- Показать статус harpoon в statusline (опционально)
		vim.api.nvim_create_user_command("HarpoonStatus", function()
			local list = harpoon:list()
			local current_file = vim.fn.expand("%:p")
			local status = "Harpoon: "

			for i, item in ipairs(list.items) do
				if item.value == current_file then
					status = status .. "[" .. i .. "] "
				else
					status = status .. i .. " "
				end
			end

			if #list.items == 0 then
				status = status .. "empty"
			end

			print(status)
		end, { desc = "Show harpoon status" })
	end,
}
