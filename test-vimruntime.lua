-- Test to check VIMRUNTIME path
print("VIMRUNTIME:", vim.env.VIMRUNTIME)
print("Is valid directory:", vim.fn.isdirectory(vim.env.VIMRUNTIME))

-- Check what should be in library
local runtime_path = vim.env.VIMRUNTIME
local lua_path = runtime_path .. "/lua"
print("Lua runtime path:", lua_path)
print("Lua path exists:", vim.fn.isdirectory(lua_path))

-- Correct library format for lua_ls
local library = vim.api.nvim_get_runtime_file("", true)
print("\nAll runtime paths:")
for _, path in ipairs(library) do
	print("  -", path)
end
