require("shakhin.core")
require("shakhin.lazy")

local function get_uv_python()
	-- Попробуем найти активный UV Python
	local handle = io.popen("uv python find")
	if handle then
		local result = handle:read("*a")
		handle:close()
		if result and result ~= "" then
			return result:gsub("%s+", "") -- убираем переносы строк
		end
	end

	-- Fallback к системному Python
	return "/usr/bin/python3"
end

-- Устанавливаем Python provider динамически
vim.g.python3_host_prog = get_uv_python()

vim.opt.fileformats = { "unix", "dos" }
