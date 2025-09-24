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

-- Window navigation
keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to window below" })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to window above" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Buffer management
keymap.set("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete current buffer" })
keymap.set("n", "<leader>ba", ":bufdo bd<CR>", { desc = "Delete all buffers" })
keymap.set("n", "<leader>bo", ":only<CR>", { desc = "Keep only current window" })
keymap.set("n", "<leader>bs", ":ls<CR>", { desc = "Show buffer list" })

-- ToggleTerm clear terminal
keymap.set("n", "<leader>tc", ":TermExec cmd='clear'<CR>", { desc = "Clear terminal" })

-- Debug keymaps
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

-- LazyGit (commented out - uncomment if LazyGit is installed)
-- keymap.set("n", "<leader>lg", ":LazyGit<CR>", { desc = "Open LazyGit" })

-- Bufferline navigation
keymap.set("n", "<Tab>", ":BufferLineCycleNext<CR>", { desc = "Next buffer" })
keymap.set("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { desc = "Previous buffer" })
