-- Diagnostic script to check lua_ls and neodev integration
-- Run with: nvim -l test-lua-api-check.lua

print("=== Lua LSP & Neodev Diagnostic ===\n")

-- Check 1: Neodev installed
local has_neodev, neodev = pcall(require, "neodev")
print("1. Neodev installed:", has_neodev and "✓" or "✗")

-- Check 2: Lua LSP server installed via Mason
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
local lua_ls_path = mason_bin .. "/lua-language-server.cmd"
local lua_ls_exists = vim.fn.executable(lua_ls_path) == 1

print("2. lua-language-server installed:", lua_ls_exists and "✓" or "✗")
print("   Path:", lua_ls_path)

-- Check 3: VIMRUNTIME exists
print("\n3. VIMRUNTIME:", vim.env.VIMRUNTIME)
print("   Exists:", vim.fn.isdirectory(vim.env.VIMRUNTIME) == 1 and "✓" or "✗")

-- Check 4: Runtime files
local runtime_files = vim.api.nvim_get_runtime_file("", true)
print("\n4. Neovim runtime paths found:", #runtime_files)
if #runtime_files > 0 then
	print("   First 3 paths:")
	for i = 1, math.min(3, #runtime_files) do
		print("   -", runtime_files[i])
	end
end

print("\n=== Instructions ===")
print("1. Restart Neovim completely")
print("2. Open a Lua file (e.g., test-lua-lsp.lua)")
print("3. Run :LspInfo to verify lua_ls is attached")
print("4. Type 'vim.' and check if autocompletion appears")
print("5. Type 'vim.api.nvim_' and check for API functions")
print("\nIf autocompletion works, lua_ls + neodev integration is successful!")
