-- Test file for lua_ls Neovim API integration
-- Open this file in Neovim and check if vim.* has autocompletion

-- Test 1: vim global should be recognized
vim.█

-- Test 2: vim.api should have autocompletion
vim.api.nvim_█

-- Test 3: vim.fn should work
vim.fn.expand█

-- Test 4: vim.lsp should work
vim.lsp.buf.█

-- Test 5: Should NOT show warnings for 'vim' undefined
local test = vim.version()

print("If you see autocompletion at █ positions, lua_ls is working correctly!")
