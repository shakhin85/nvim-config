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
