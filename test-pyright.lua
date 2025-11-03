-- Diagnostic script to test Pyright configuration
-- Run this with: nvim -l test-pyright.lua

print("=== Pyright Diagnostic Test ===\n")

-- Test 1: Check Python path detection
local function get_python_path()
	local cwd = vim.fn.getcwd()
	local venv_python

	if vim.fn.has("win32") == 1 then
		venv_python = cwd .. "\\.venv\\Scripts\\python.exe"
	else
		venv_python = cwd .. "/.venv/bin/python"
	end

	print("1. Checking for .venv Python:")
	print("   Path: " .. venv_python)

	if vim.fn.executable(venv_python) == 1 then
		print("   Status: ✓ Found and executable")
		return venv_python
	else
		print("   Status: ✗ Not found")
	end

	local python_cmd = vim.fn.has("win32") == 1 and "python" or "python3"
	print("\n2. Checking fallback Python:")
	print("   Command: " .. python_cmd)

	if vim.fn.executable(python_cmd) == 1 then
		print("   Status: ✓ Found in PATH")
		return python_cmd
	else
		print("   Status: ✗ Not found")
		return nil
	end
end

-- Test 2: Check Pyright installation
print("\n3. Checking Pyright installation:")
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
local pyright_cmd
if vim.fn.has("win32") == 1 then
	pyright_cmd = mason_bin .. "/pyright-langserver.cmd"
else
	pyright_cmd = mason_bin .. "/pyright-langserver"
end

print("   Path: " .. pyright_cmd)
if vim.fn.executable(pyright_cmd) == 1 then
	print("   Status: ✓ Installed via Mason")
else
	print("   Status: ✗ Not found - run :Mason and install pyright")
end

-- Test 3: Display detected Python path
local detected_python = get_python_path()
print("\n4. Final Python path to be used:")
if detected_python then
	print("   " .. detected_python)
else
	print("   ✗ No Python found!")
end

print("\n=== Test Complete ===")
print("\nNext steps:")
print("1. If .venv not found, create it: python -m venv .venv")
print("2. If Pyright not installed, run: :Mason and install pyright")
print("3. After fixing, restart Neovim and run: :LspInfo")
