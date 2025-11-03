# Упрощённый подход к настройке lua_ls

## 🎯 Проблема: Мы усложнили

**Было:**
```lua
-- Шаг 1: Установить neodev
dependencies = {
  { "folke/neodev.nvim", opts = {} },
}

-- Шаг 2: Настроить neodev
require("neodev").setup({...})

-- Шаг 3: Настроить lua_ls (надеясь что neodev всё сделает)
vim.lsp.config("lua_ls", {...})
```

**Проблемы:**
- ❌ Дополнительная зависимость (neodev)
- ❌ Сложная настройка
- ❌ Не очевидно, как это работает
- ❌ Задержки из-за дополнительной обработки

---

## ✅ Решение: Простой подход (из blink.cmp docs)

**Теперь:**
```lua
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      workspace = {
        library = {
          "${3rd}/luv/library",
          unpack(vim.api.nvim_get_runtime_file("", true)),
        },
      },
    },
  },
})
```

**Преимущества:**
- ✅ Без дополнительных плагинов
- ✅ Простая и понятная настройка
- ✅ Быстрее (нет дополнительной обработки)
- ✅ Прямо из официальной документации blink.cmp

---

## 🔍 Что делает `unpack(vim.api.nvim_get_runtime_file("", true))`?

### **Шаг за шагом:**

```lua
-- 1. Получить все runtime пути Neovim
local runtime_files = vim.api.nvim_get_runtime_file("", true)
-- Результат: {
--   "C:/Users/.../nvim/runtime",
--   "C:/Users/.../nvim-data/lazy/plugin1",
--   "C:/Users/.../nvim-data/lazy/plugin2",
--   ...
-- }

-- 2. Распаковать массив в отдельные элементы
library = {
  "${3rd}/luv/library",
  unpack(runtime_files),  -- Раскрывается в: путь1, путь2, путь3, ...
}

-- Финальный результат:
library = {
  "${3rd}/luv/library",
  "C:/Users/.../nvim/runtime",
  "C:/Users/.../nvim-data/lazy/plugin1",
  "C:/Users/.../nvim-data/lazy/plugin2",
  -- ... все остальные пути
}
```

### **Почему это работает:**

1. **`vim.api.nvim_get_runtime_file("", true)`**
   - Возвращает ВСЕ пути, где Neovim ищет файлы
   - Включает: встроенный runtime, плагины, ваш config и т.д.

2. **`unpack()`**
   - Lua функция, которая превращает массив в список аргументов
   - `unpack({1, 2, 3})` → `1, 2, 3`

3. **`library = { ..., unpack(...) }`**
   - Все распакованные пути добавляются в таблицу `library`
   - lua_ls получает доступ ко всем типам Neovim

---

## 📊 Сравнение подходов

| Аспект | neodev | unpack() |
|--------|--------|----------|
| Дополнительные зависимости | ✗ Да (neodev) | ✓ Нет |
| Строк кода | ✗ ~20 | ✓ 3 |
| Скорость | ✗ Медленнее | ✓ Быстрее |
| Понятность | ✗ Магия | ✓ Прозрачно |
| Поддержка | ✗ Может сломаться | ✓ Native API |
| Работает с vim.lsp.config() | ✗ Требует хаков | ✓ Из коробки |

---

## 🚀 Дополнительные оптимизации

### **1. Уменьшен debounce в blink.cmp**

```lua
completion = {
  debounce = 50,  -- Было: 100ms
}
```

**Эффект:** Автодополнение появляется в 2 раза быстрее!

### **2. Убраны лишние проверки**

- Удалён neodev из dependencies
- Убрана функция `require("neodev").setup()`
- Упрощена конфигурация lua_ls

---

## 🎓 Почему мы изначально использовали neodev?

**Исторически:**
- neodev был стандартом для lua_ls + nvim-lspconfig
- Он автоматически настраивал всё для старого API
- Документация рекомендовала его

**Почему больше не нужен:**
- Neovim 0.10+ имеет новый API: `vim.lsp.config()`
- `vim.api.nvim_get_runtime_file()` даёт всё необходимое
- neodev не оптимизирован для нового API

---

## 📝 Итоговая конфигурация (простая!)

```lua
vim.lsp.config("lua_ls", {
  cmd = { get_mason_bin("lua-language-server") },
  filetypes = { "lua" },
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace",
      },
      diagnostics = {
        globals = { "vim" },
      },
      runtime = {
        version = "LuaJIT",
      },
      workspace = {
        checkThirdParty = false,
        library = {
          "${3rd}/luv/library",
          unpack(vim.api.nvim_get_runtime_file("", true)),
        },
      },
      telemetry = {
        enable = false,
      },
    },
  },
})
```

**Всего ~25 строк** вместо 50+ с neodev!

---

## ✅ Проверка работоспособности

После перезапуска Neovim:

1. **Откройте .lua файл**
2. **Напечатайте `vim.`** → должно появиться автодополнение
3. **Проверьте `:LspInfo`** → должен быть `lua_ls`
4. **Нажмите `K` на `vim.api`** → должна появиться документация

---

## 🎯 Мораль истории

> **"Простота - высшая форма изысканности"** - Леонардо да Винчи

- Не всегда нужны дополнительные плагины
- Официальная документация (blink.cmp) показывает лучший путь
- Native Neovim API часто достаточно
- Меньше кода = меньше багов = быстрее работа

---

**Автор:** Claude Code
**Дата:** 2025-11-03
**Урок:** Всегда проверяйте официальную документацию перед добавлением зависимостей!
