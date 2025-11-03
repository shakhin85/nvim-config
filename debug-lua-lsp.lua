-- Debug script to check lua_ls status
-- Run this inside Neovim with :luafile %

print("=== Lua LSP Debug Information ===\n")

-- 1. Check if neodev is loaded
local has_neodev, neodev = pcall(require, "neodev")
print("1. Neodev loaded:", has_neodev)
if not has_neodev then
	print("   ERROR:", neodev)
end

-- 2. Check current buffer filetype
print("\n2. Current buffer info:")
print("   Filetype:", vim.bo.filetype)
print("   Buftype:", vim.bo.buftype)

-- 3. Check LSP clients attached to current buffer
print("\n3. LSP clients attached to current buffer:")
local clients = vim.lsp.get_clients({ bufnr = 0 })
if #clients == 0 then
	print("   ❌ No LSP clients attached!")
else
	for _, client in ipairs(clients) do
		print("   ✓", client.name, "(id:", client.id .. ")")
	end
end

-- 4. Check if lua_ls is configured
print("\n4. Checking lua_ls configuration:")
local lua_ls_configs = vim.lsp.get_clients({ name = "lua_ls" })
if #lua_ls_configs == 0 then
	print("   ❌ lua_ls not running at all!")
else
	print("   ✓ lua_ls is running")
	for _, client in ipairs(lua_ls_configs) do
		print("   Client ID:", client.id)
		print("   Root dir:", client.config.root_dir or "nil")
		print("   Attached buffers:", vim.inspect(client.attached_buffers))
	end
end

-- 5. Check Mason binary
print("\n5. Mason binary check:")
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
local lua_ls_cmd = mason_bin .. "\\lua-language-server.cmd"
print("   Path:", lua_ls_cmd)
print("   Executable:", vim.fn.executable(lua_ls_cmd) == 1 and "✓" or "❌")

-- 6. Check vim.lsp.config registry
print("\n6. LSP config registry:")
-- Try to see if lua_ls is in the config
local ok, configs = pcall(function()
	return vim.lsp.config.lua_ls
end)
if ok and configs then
	print("   ✓ lua_ls config found")
	print("   Config:", vim.inspect(configs))
else
	print("   ❌ lua_ls config not found")
end

-- 7. Try to manually start lua_ls
print("\n7. Attempt to manually start lua_ls:")
print("   Run this command in Neovim:")
print("   :lua vim.lsp.start({ name = 'lua_ls', cmd = { vim.fn.stdpath('data') .. '/mason/bin/lua-language-server.cmd' } })")

print("\n=== Debug Complete ===")
print("\nNext steps:")
print("1. Run :LspInfo to see all LSP clients")
print("2. Run :checkhealth lsp to check LSP health")
print("3. Check :messages for any error messages")
print("4. Look at LSP log: :e " .. vim.lsp.get_log_path())
