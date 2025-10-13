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

local function get_uv_python()
	-- 1. Приоритет: локальный .venv в текущей директории
	local cwd = vim.fn.getcwd()
	local venv_python

	if vim.fn.has("win32") == 1 then
		venv_python = cwd .. "/.venv/Scripts/python.exe"
	else
		venv_python = cwd .. "/.venv/bin/python"
	end

	if vim.fn.executable(venv_python) == 1 then
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
				return result:gsub("%s+", "") -- убираем переносы строк
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
			return candidate
		end
	end

	-- 4. Последний fallback
	return vim.fn.has("win32") == 1 and "python" or "python3"
end

-- Устанавливаем Python provider динамически
vim.g.python3_host_prog = get_uv_python()

vim.opt.fileformats = { "unix", "dos" }
