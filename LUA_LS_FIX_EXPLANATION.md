# Исправление lua_ls интеграции с Neovim API

## 🔍 Проблема

Lua Language Server (lua_ls) не распознавал Neovim API:
- `vim.*` не имел автодополнения
- `vim.api`, `vim.fn`, `vim.lsp` не работали
- Возможно были предупреждения "undefined global 'vim'"

## 🎯 Решение

### **Что было сделано:**

1. **Добавлена правильная настройка neodev.nvim**
   - `neodev` - это плагин, который автоматически настраивает lua_ls для работы с Neovim API
   - Он добавляет все необходимые типы и документацию для `vim.*`

2. **Упрощена конфигурация lua_ls**
   - Удалены ручные настройки `workspace.library`
   - neodev теперь управляет этим автоматически

3. **Добавлен `filetypes = { "lua" }`**
   - lua_ls теперь работает только с `.lua` файлами

---

## 📝 Что делает neodev

### **До neodev:**
```lua
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			workspace = {
				library = {
					vim.env.VIMRUNTIME,  -- ❌ Неполная настройка
					"${3rd}/luv/library", -- ❌ Может не работать
				},
			},
		},
	},
})
```

### **После neodev:**
```lua
require("neodev").setup({
	library = {
		enabled = true,
		runtime = true,  -- ✅ Полный Neovim runtime
		types = true,    -- ✅ Все типы vim.api, vim.lsp, vim.treesitter
		plugins = true,  -- ✅ Типы для установленных плагинов
	},
})

vim.lsp.config("lua_ls", {
	-- neodev автоматически настроит workspace.library
	settings = {
		Lua = {
			workspace = {
				checkThirdParty = false,
			},
		},
	},
})
```

---

## 🔧 Как работает интеграция

### **1. Neodev инициализация (в config функции)**

```lua
config = function()
	-- ПЕРВЫМ делом настраиваем neodev
	require("neodev").setup({
		library = {
			enabled = true,  -- Включить библиотеки типов
			runtime = true,  -- Neovim runtime (vim.*, vim.fn.*, etc)
			types = true,    -- Полные сигнатуры и документация
			plugins = true,  -- Типы из плагинов
		},
		setup_jsonls = true,   -- Настроить jsonls для package.json
		lspconfig = true,      -- Интеграция с lspconfig
		pathStrict = true,     -- Строгие пути
	})

	-- Потом настраиваем lua_ls
	vim.lsp.config("lua_ls", { ... })
end
```

### **2. Что получает lua_ls от neodev**

- **Runtime библиотека:** все файлы из `$VIMRUNTIME/lua`
- **Типы vim API:**
  - `vim.api.*` - низкоуровневое API
  - `vim.fn.*` - Vimscript функции
  - `vim.lsp.*` - LSP клиент
  - `vim.treesitter.*` - Treesitter API
  - И многое другое!
- **Документация:** полные описания функций, параметров, возвращаемых значений
- **Типы плагинов:** если плагин предоставляет типы, lua_ls их увидит

### **3. Результат**

Теперь при наборе кода в `.lua` файле:

```lua
vim.█
-- ↓ Автодополнение показывает:
-- vim.api
-- vim.fn
-- vim.lsp
-- vim.treesitter
-- vim.diagnostic
-- ... и т.д.

vim.api.nvim_█
-- ↓ Автодополнение показывает:
-- nvim_buf_get_lines
-- nvim_create_autocmd
-- nvim_set_keymap
-- ... все функции API
```

---

## 🎨 Визуальное сравнение

### **Без neodev:**
```
vim.api.nvim_create_autocmd()
     ^^^
     ⚠️ "Unknown field 'api'"
```

### **С neodev:**
```
vim.api.nvim_create_autocmd("FileType", {
          ^^^^^^^^^^^^^^^^^^
          ✅ Автодополнение + документация

  pattern = "python",
  ^^^^^^^^
  ✅ Предлагает валидные поля

  callback = function()
    vim.opt_local.tabstop = 4
        ^^^^^^^^^
        ✅ Знает про vim.opt_local
  end,
})
```

---

## 📊 Архитектура интеграции

```
┌─────────────────────────────────────────────────┐
│  Neovim Lua файл (test.lua)                    │
└──────────────────┬──────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────┐
│  lua_ls (Language Server)                      │
│  ┌──────────────────────────────────────────┐  │
│  │ Нужна информация о vim.* API             │  │
│  └──────────────────┬───────────────────────┘  │
└─────────────────────┼───────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────┐
│  neodev.nvim                                    │
│  ┌──────────────────────────────────────────┐  │
│  │ Предоставляет:                           │  │
│  │ • $VIMRUNTIME/lua библиотеки            │  │
│  │ • Типы из vim/api.lua                   │  │
│  │ • Типы из vim/lsp.lua                   │  │
│  │ • Документацию функций                  │  │
│  │ • Типы плагинов                         │  │
│  └──────────────────────────────────────────┘  │
└─────────────────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────┐
│  Результат:                                     │
│  ✅ Автодополнение vim.*                        │
│  ✅ Подсказки параметров                        │
│  ✅ Документация при наведении (K)              │
│  ✅ Go to definition (gd)                       │
│  ✅ Нет ошибок "undefined global 'vim'"         │
└─────────────────────────────────────────────────┘
```

---

## 🧪 Тестирование

### **Тестовый файл создан:** `test-lua-lsp.lua`

```lua
-- Test 1: vim global
vim.█  -- Должно показать автодополнение

-- Test 2: vim.api
vim.api.nvim_█  -- Должно показать nvim_* функции

-- Test 3: Hover документация
vim.api.nvim_create_autocmd()
--     ^^^^ Нажмите K здесь - должна появиться документация
```

### **Проверка:**

1. Перезапустите Neovim
2. Откройте `test-lua-lsp.lua`
3. Выполните `:LspInfo` → должен быть `lua_ls` attached
4. Начните печатать `vim.` → должно появиться автодополнение
5. Нажмите `K` на функции → должна появиться документация

---

## ⚙️ Настройки neodev

Вы можете дополнительно настроить neodev:

```lua
require("neodev").setup({
	library = {
		enabled = true,
		runtime = true,
		types = true,
		plugins = true,  -- Можно отключить, если плагины замедляют работу
	},
	setup_jsonls = true,
	lspconfig = true,
	pathStrict = true,

	-- Дополнительные опции:
	override = function(root_dir, library)
		-- Можно настроить особую логику для конкретных проектов
	end,
})
```

---

## 🎓 Ключевые моменты

1. **neodev ДОЛЖЕН быть настроен ДО lua_ls**
   - Поэтому `require("neodev").setup()` в начале `config` функции

2. **workspace.library НЕ нужно настраивать вручную**
   - neodev делает это автоматически

3. **Плагин уже был установлен**
   - Он был в dependencies, но не настроен
   - Теперь он активно работает

4. **Работает только для .lua файлов**
   - `filetypes = { "lua" }` гарантирует это

---

## 📚 Дополнительные ресурсы

- [neodev.nvim GitHub](https://github.com/folke/neodev.nvim)
- [lua_ls документация](https://luals.github.io/)
- [Neovim Lua guide](https://neovim.io/doc/user/lua-guide.html)

---

**Автор исправления:** Claude Code
**Дата:** 2025-11-03
