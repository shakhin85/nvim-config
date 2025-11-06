require("shakhin.core")
require("shakhin.lazy")

-- Clipboard configuration
if vim.fn.has("win32") == 1 then
	-- Windows: use win32yank
	vim.g.clipboard = {
		name = "win32yank",
		copy = {
			["+"] = "win32yank.exe -i --crlf",
			["*"] = "win32yank.exe -i --crlf",
		},
		paste = {
			["+"] = "win32yank.exe -o --lf",
			["*"] = "win32yank.exe -o --lf",
		},
		cache_enabled = 0,
	}
else
	-- Linux: use lemonade
	vim.g.clipboard = {
		name = "lemonade",
		copy = {
			["+"] = "lemonade copy",
			["*"] = "lemonade copy",
		},
		paste = {
			["+"] = "lemonade paste",
			["*"] = "lemonade paste",
		},
		cache_enabled = 1,
	}
end

-- Cached Python path detection (lazy-loaded on first Python file)
local python_path_cache = nil

local function get_uv_python()
	-- Return cached result if available
	if python_path_cache then
		return python_path_cache
	end

	-- 1. Приоритет: локальный .venv в текущей директории
	local cwd = vim.fn.getcwd()
	local venv_python

	if vim.fn.has("win32") == 1 then
		-- Windows: use backslashes and proper path
		venv_python = cwd .. "\\.venv\\Scripts\\python.exe"
	else
		venv_python = cwd .. "/.venv/bin/python"
	end

	if vim.fn.executable(venv_python) == 1 then
		python_path_cache = venv_python
		return venv_python
	end

	-- 2. Попробуем uv python find (для uv-managed Python)
	local uv_available = vim.fn.executable("uv") == 1

	if uv_available then
		local handle = io.popen("uv python find 2>nul") -- suppress errors on Windows
		if handle then
			local result = handle:read("*a")
			handle:close()
			if result and result ~= "" and not result:match("error") then
				local python = result:gsub("%s+", "") -- убираем переносы строк
				python_path_cache = python
				return python
			end
		end
	end

	-- 3. Fallback к системному Python (кросс-платформенно)
	local python_candidates = {}

	if vim.fn.has("win32") == 1 then
		python_candidates = { "python", "python3", "py" }
	else
		python_candidates = { "python3", "python", "/usr/bin/python3" }
	end

	for _, candidate in ipairs(python_candidates) do
		if vim.fn.executable(candidate) == 1 then
			python_path_cache = candidate
			return candidate
		end
	end

	-- 4. Последний fallback
	local fallback = vim.fn.has("win32") == 1 and "python" or "python3"
	python_path_cache = fallback
	return fallback
end

-- Lazy-load Python provider: only detect on first Python file or when explicitly needed
vim.api.nvim_create_autocmd({ "FileType", "BufRead" }, {
	pattern = { "python", "*.py" },
	once = true,
	callback = function()
		vim.g.python3_host_prog = get_uv_python()
	end,
})

-- Also invalidate cache when changing directories
vim.api.nvim_create_autocmd("DirChanged", {
	callback = function()
		python_path_cache = nil
		-- Re-detect if we're in a Python file
		if vim.bo.filetype == "python" then
			vim.g.python3_host_prog = get_uv_python()
		end
	end,
})

vim.opt.fileformats = { "unix", "dos" }
