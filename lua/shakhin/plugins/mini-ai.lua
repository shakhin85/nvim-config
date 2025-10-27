return {
  "echasnovski/mini.ai",
  version = false,
  event = "VeryLazy",
  config = function()
    local ai = require("mini.ai")

    -- Безопасная обертка для treesitter с fallback
    local function safe_ts_spec(spec, opts)
      return function(...)
        local ok, ts_spec = pcall(ai.gen_spec.treesitter, spec, opts or {})
        if ok then
          local result_ok, result = pcall(ts_spec, ...)
          if result_ok then
            return result
          end
        end
        -- Fallback: вернуть nil, чтобы использовать стандартные text objects
        return nil
      end
    end

    ai.setup({
      n_lines = 500,
      custom_textobjects = {
        -- Блоки: с treesitter fallback
        o = safe_ts_spec({
          a = { "@block.outer", "@conditional.outer", "@loop.outer" },
          i = { "@block.inner", "@conditional.inner", "@loop.inner" },
        }),

        -- Функции: с treesitter fallback
        f = safe_ts_spec({ a = "@function.outer", i = "@function.inner" }),

        -- Классы: с treesitter fallback
        c = safe_ts_spec({ a = "@class.outer", i = "@class.inner" }),

        -- HTML/XML теги
        t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },

        -- Числа
        d = { "%f[%d]%d+" },

        -- Слова (camelCase, snake_case)
        e = {
          {
            "%u[%l%d]+%f[^%l%d]",
            "%f[%S][%l%d]+%f[^%l%d]",
            "%f[%P][%l%d]+%f[^%l%d]",
            "^[%l%d]+%f[^%l%d]",
          },
          "^().*()$",
        },

        -- Вызовы функций
        u = ai.gen_spec.function_call(),
        U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }),

        -- SQL-специфичные text objects
        -- 's' для SQL SELECT блока
        s = function(mode)
          local from = vim.fn.search("SELECT", "bnW")
          if from == 0 then
            return nil
          end
          local to = vim.fn.search("\\(WHERE\\|FROM\\|GROUP\\|ORDER\\|UNION\\|;\\|\\n)\\)", "nW")
          if to == 0 then
            to = vim.fn.line("$")
          end
          return { from = { line = from, col = 1 }, to = { line = to, col = vim.fn.col({ to, "$" }) } }
        end,

        -- 'w' для WHERE условий
        w = function(mode)
          local from = vim.fn.search("WHERE", "bnW")
          if from == 0 then
            return nil
          end
          local to = vim.fn.search("\\(GROUP\\|ORDER\\|UNION\\|\\n)\\)", "nW")
          if to == 0 then
            to = vim.fn.line("$")
          end
          return { from = { line = from, col = 1 }, to = { line = to, col = vim.fn.col({ to, "$" }) } }
        end,

        -- 'j' для JOIN блоков
        j = function(mode)
          local from = vim.fn.search("\\(LEFT \\|INNER \\|RIGHT \\|FULL \\)\\?JOIN", "bnW")
          if from == 0 then
            return nil
          end
          local to = vim.fn.search("\\(JOIN\\|WHERE\\|GROUP\\|ORDER\\)", "nW")
          if to == 0 then
            to = vim.fn.line("$")
          end
          return { from = { line = from, col = 1 }, to = { line = to, col = vim.fn.col({ to, "$" }) } }
        end,

        -- 'k' для CASE блоков (k как "kase")
        k = function(mode)
          local from = vim.fn.search("CASE", "bnW")
          if from == 0 then
            return nil
          end
          local to = vim.fn.search("END", "nW")
          if to == 0 then
            return nil
          end
          return { from = { line = from, col = 1 }, to = { line = to, col = vim.fn.col({ to, "$" }) } }
        end,
      },
    })
  end,
}