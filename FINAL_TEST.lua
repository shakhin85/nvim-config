-- FINAL TEST FILE for lua_ls + neodev integration
--
-- Open this file in Neovim and:
-- 1. Run :LspInfo - should see lua_ls attached
-- 2. Type vim. below and wait - should see autocompletion
-- 3. Press K on vim.api functions - should see documentation
--
-- =================================================================

-- Test 1: vim global should autocomplete

-- Test 2: vim.api should show all nvim_* functions
vim.api.nvim_

-- Test 3: vim.fn should work
vim.fn.expand

-- Test 4: vim.lsp should show buf, handlers, etc.
vim.lsp.buf.

-- Test 5: Full example with no warnings
local function test_neovim_api()
	-- Create an autocommand (should have full autocomplete)
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "lua",
		callback = function()
			-- Set buffer-local options (should autocomplete)
			vim.opt_local.tabstop = 2
			vim.opt_local.shiftwidth = 2

			-- Print message
			print("Lua file detected!")
		end,
	})

	-- Use vim.fn (should have autocomplete for Vimscript functions)
	local cwd = vim.fn.getcwd()
	print("Current directory:", cwd)

	-- Use vim.lsp (should show all LSP functions)
	local clients = vim.lsp.get_clients()
	print("Active LSP clients:", #clients)
end

-- Test 6: Check if 'vim' is recognized (no undefined global warning)
if vim.version then
	print("Neovim version:", vim.inspect(vim.version()))
end

-- ================================================================
-- SUCCESS CRITERIA:
-- ✅ No "undefined global 'vim'" warnings
-- ✅ Autocompletion works for vim.*, vim.api.*, vim.fn.*, vim.lsp.*
-- ✅ Hover (K) shows documentation
-- ✅ Go to definition (gd) works
-- ✅ :LspInfo shows lua_ls attached
-- ================================================================
