# Инструкции по тестированию lua_ls + neodev

## 🔧 Что было исправлено (итоговая версия):

### 1. Настроен neodev с правильными параметрами
```lua
require("neodev").setup({
	library = {
		enabled = true,
		runtime = true,
		types = true,
		plugins = true,
	},
	lspconfig = false,  -- ❗ Важно: false для vim.lsp.config()
	override = function(root_dir, library)
		library.enabled = true
		library.plugins = true
	end,
})
```

### 2. Внедрены настройки neodev в lua_ls
```lua
local neodev_settings = require("neodev.lsp").settings()

vim.lsp.config("lua_ls", {
	cmd = { get_mason_bin("lua-language-server") },
	filetypes = { "lua" },
	settings = vim.tbl_deep_extend("force", {
		Lua = { ... }
	}, neodev_settings), -- ❗ Объединение с настройками neodev
})
```

---

## ✅ Шаги для тестирования:

### Шаг 1: Перезапустите Neovim
Полностью закройте и откройте Neovim заново.

### Шаг 2: Откройте тестовый файл
```vim
:e C:\Users\shaln\AppData\Local\nvim\FINAL_TEST.lua
```

### Шаг 3: Проверьте LSP статус
```vim
:LspInfo
```

**Ожидаемый результат:**
```
vim.lsp: Active Clients
- lua_ls (id: X)
  - Attached buffers: [номер буфера]
  - Root directory: C:\Users\shaln\AppData\Local\nvim
```

### Шаг 4: Проверьте автодополнение
В файле `FINAL_TEST.lua`:
- Найдите строку `vim.` (строка 12)
- Начните печатать после точки
- **Должно появиться меню** с `api`, `fn`, `lsp`, `diagnostic` и т.д.

### Шаг 5: Проверьте документацию
- Поставьте курсор на `vim.api.nvim_create_autocmd`
- Нажмите `K`
- **Должна появиться документация** функции

### Шаг 6: Проверьте диагностику
- Не должно быть предупреждений `undefined global 'vim'`
- Все функции vim.* должны распознаваться

---

## 🐛 Если не работает:

### Диагностика 1: Запустите debug скрипт
```vim
:luafile C:\Users\shaln\AppData\Local\nvim\debug-lua-lsp.lua
```

Проверьте вывод:
- [ ] Neodev loaded: должно быть `true`
- [ ] lua_ls is running: должно быть `✓`
- [ ] LSP clients attached: должен быть `lua_ls`

### Диагностика 2: Проверьте LSP логи
```vim
:lua print(vim.lsp.get_log_path())
```

Откройте файл и ищите строки с `lua_ls`. Должны быть:
- `[START]` записи (сервер запустился)
- **НЕ** должно быть `[ERROR]` про lua_ls

### Диагностика 3: Проверьте neodev настройки
```vim
:lua print(vim.inspect(require("neodev.lsp").settings()))
```

Должен вывести таблицу с `Lua.workspace.library` содержащую пути к Neovim runtime.

### Диагностика 4: Ручной запуск
Попробуйте запустить lua_ls вручную:
```vim
:lua vim.lsp.start({name='lua_ls', cmd={vim.fn.stdpath('data')..'/mason/bin/lua-language-server.cmd'}})
```

Если ошибка - проверьте путь к Mason binary.

---

## 📝 Возможные проблемы:

### Проблема 1: lua_ls не запускается
**Симптом:** `:LspInfo` не показывает lua_ls

**Решение:**
1. Проверьте установку: `:Mason` → найдите `lua-language-server` → должна быть ✓
2. Проверьте путь: `:lua print(vim.fn.stdpath('data') .. '/mason/bin/lua-language-server.cmd')`
3. Проверьте executable: `:lua print(vim.fn.executable(vim.fn.stdpath('data') .. '/mason/bin/lua-language-server.cmd'))`

### Проблема 2: lua_ls запущен, но нет автодополнения vim.*
**Симптом:** lua_ls в `:LspInfo`, но `vim.` не дает подсказок

**Решение:**
1. Проверьте neodev: `:lua print(pcall(require, 'neodev'))`
2. Проверьте настройки: `:lua print(vim.inspect(require("neodev.lsp").settings()))`
3. Убедитесь, что `lspconfig = false` в neodev.setup()

### Проблема 3: Есть предупреждения "undefined global 'vim'"
**Симптом:** Красные подчеркивания под `vim`

**Решение:**
1. Убедитесь, что в lua_ls settings есть `diagnostics.globals = { "vim" }`
2. Перезапустите lua_ls: `:LuaLsRestart`

---

## 🎯 Ожидаемый результат (SUCCESS):

После успешной настройки:

✅ `:LspInfo` показывает `lua_ls` attached
✅ Автодополнение работает для:
   - `vim.*`
   - `vim.api.nvim_*`
   - `vim.fn.*`
   - `vim.lsp.*`
✅ Hover (K) показывает документацию
✅ Go to definition (gd) работает
✅ Нет warnings про "undefined global 'vim'"
✅ Inlay hints показывают типы

---

## 📞 Контакты для дальнейшей помощи:

Если проблема сохраняется:
1. Предоставьте вывод `:LspInfo`
2. Предоставьте вывод `:checkhealth lsp`
3. Предоставьте последние 50 строк LSP лога
4. Предоставьте вывод `debug-lua-lsp.lua` скрипта

---

**Дата:** 2025-11-03
**Версия Neovim:** 0.11.4
**Ключевые изменения:** Интеграция neodev с vim.lsp.config() через `.settings()` и `lspconfig=false`
