vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

keymap.set("n", "<leader>nhl", ":nohl<CR>", { desc = "Clear search highlights" })

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- Навигация между окнами/панелями
keymap.set("n", "<C-h>", "<C-w>h", opts) -- Переход в левое окно
keymap.set("n", "<C-j>", "<C-w>j", opts) -- Переход в нижнее окно
keymap.set("n", "<C-k>", "<C-w>k", opts) -- Переход в верхнее окно
keymap.set("n", "<C-l>", "<C-w>l", opts) -- Переход в правое окно

-- Управление буферами
keymap.set("n", "<leader>bd", ":bdelete<CR>", opts) -- Закрыть текущий буфер
keymap.set("n", "<leader>ba", ":bufdo bd<CR>", opts) -- Закрыть все буферы
keymap.set("n", "<leader>bo", ":only<CR>", opts) -- Оставить только текущее окно
keymap.set("n", "<leader>bs", ":ls<CR>", opts) -- Показать список буферов

-- ToggleTerm clear terminal
keymap.set("n", "<leader>tc", ":TermExec cmd='clear'<CR>", { desc = "Clear terminal" })

-- Debug keymaps (добавить в основной keymaps.lua для быстрого доступа)
keymap.set("n", "<F5>", ":DebugPythonSimple<CR>", { desc = "Start debugging" })
keymap.set("n", "<F9>", function()
	require("dap").toggle_breakpoint()
end, { desc = "Toggle breakpoint" })
keymap.set("n", "<F3>", function()
	require("dap").step_over()
end, { desc = "Step over" })
keymap.set("n", "<F4>", function()
	require("dap").step_into()
end, { desc = "Step into" })
keymap.set("n", "<F12>", function()
	require("dap").continue()
end, { desc = "Continue" })

-- keymap.set("n", "<leader>lg", ":LazyGit<CR>", { desc = "Open LazyGit" })
--
---- Bufferline navigation (улучшенные кеймапы для существующего bufferline)
keymap.set("n", "<Tab>", ":BufferLineCycleNext<CR>", { desc = "Next buffer" })
keymap.set("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { desc = "Previous buffer" })
--
--
--
