require("shakhin.core")
require("shakhin.lazy")

local function get_uv_python()
	-- Попробуем найти активный UV Python
	local handle = io.popen("uv python find 2>/dev/null")
	if handle then
		local result = handle:read("*a")
		local success = handle:close()

		if success and result and result ~= "" then
			local python_path = result:gsub("%s+", "") -- убираем переносы строк

			-- Проверяем, что путь действительно существует и это исполняемый файл
			if vim.fn.executable(python_path) == 1 then
				return python_path
			end
		end
	end

	-- Fallback: пробуем найти Python в PATH
	local fallback_paths = { "python3", "python", "/usr/bin/python3" }
	for _, path in ipairs(fallback_paths) do
		if vim.fn.executable(path) == 1 then
			return path
		end
	end

	-- Последний fallback
	return "/usr/bin/python3"
end

-- Устанавливаем Python provider динамически
vim.g.python3_host_prog = get_uv_python()

vim.opt.fileformats = { "unix", "dos" }
