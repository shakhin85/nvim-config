require("shakhin.core")
require("shakhin.lazy")

local function get_python()
	-- 1. Проверяем VIRTUAL_ENV (активированное окружение)
	local venv = os.getenv("VIRTUAL_ENV")
	if venv then
		local venv_python = venv .. "/bin/python"
		if vim.fn.executable(venv_python) == 1 then
			return venv_python
		end
	end

	-- 2. Ищем .venv в текущей директории
	local cwd = vim.fn.getcwd()
	local venv_paths = {
		cwd .. "/.venv/bin/python",
		cwd .. "/venv/bin/python",
		cwd .. "/.virtualenv/bin/python",
	}
	for _, path in ipairs(venv_paths) do
		if vim.fn.executable(path) == 1 then
			return path
		end
	end

	-- 3. Попробуем найти UV Python
	local handle = io.popen("uv python find 2>/dev/null")
	if handle then
		local result = handle:read("*a")
		handle:close()
		if result and result ~= "" then
			local uv_python = result:gsub("%s+", "")
			if vim.fn.executable(uv_python) == 1 then
				return uv_python
			end
		end
	end

	-- 4. Fallback к системному Python
	return "/usr/bin/python3"
end

-- Устанавливаем Python provider динамически
vim.g.python3_host_prog = get_python()

-- Команда для проверки используемого Python
vim.api.nvim_create_user_command("CheckPython", function()
	local python = vim.g.python3_host_prog
	print("Python provider: " .. python)

	-- Проверяем доступность pynvim
	local handle = io.popen(python .. ' -c "import pynvim; print(\\"pynvim OK\\")" 2>&1')
	if handle then
		local result = handle:read("*a")
		handle:close()
		print(result)
	end
end, {})

vim.opt.fileformats = { "unix", "dos" }
