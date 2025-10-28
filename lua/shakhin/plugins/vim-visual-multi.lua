return {
  "mg979/vim-visual-multi",
  event = "VeryLazy",
  init = function()
    -- Must be set before plugin loads
    vim.g.VM_maps = {
      ["Find Under"] = "<leader>mn",
      ["Find Subword Under"] = "<leader>mn",
      ["Add Cursor Down"] = "<C-Down>",
      ["Add Cursor Up"] = "<C-Up>",
      ["Find Next"] = "<leader>mj",  -- следующее совпадение
      ["Find Prev"] = "<leader>mk",  -- предыдущее совпадение
      ["Skip Region"] = "",  -- отключить <C-x>
    }
  end,
  config = function()
    -- Явно отключаем <C-n> после загрузки плагина
    vim.keymap.set("n", "<C-n>", "<Nop>", { desc = "Disabled (vim-visual-multi)", noremap = true, silent = true })
  end,
}