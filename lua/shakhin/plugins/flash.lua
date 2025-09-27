return {
  "folke/flash.nvim",
  event = "VeryLazy",
  ---@type Flash.Config
  opts = {
    modes = {
      search = {
        enabled = true,
      },
      -- char = {
      --   jump_labels = true,
      -- },
    },
  },
  config = function(_, opts)
    require("flash").setup(opts)

    -- Custom function for window navigation with flash
    local function flash_window_jump()
      local windows = vim.api.nvim_list_wins()
      if #windows <= 1 then
        vim.notify("Only one window open", vim.log.levels.INFO)
        return
      end

      local current_win = vim.api.nvim_get_current_win()
      local targets = {}

      for _, win in ipairs(windows) do
        if win ~= current_win and vim.api.nvim_win_get_config(win).relative == "" then
          local buf = vim.api.nvim_win_get_buf(win)
          local row, col = unpack(vim.api.nvim_win_get_cursor(win))
          table.insert(targets, {
            pos = { row, col },
            end_pos = { row, col },
            win = win,
            buf = buf,
          })
        end
      end

      if #targets == 0 then
        vim.notify("No other windows available", vim.log.levels.INFO)
        return
      end

      require("flash").jump({
        search = { mode = "search" },
        label = { uppercase = false },
        targets = targets,
        action = function(match)
          vim.api.nvim_set_current_win(match.win)
        end,
      })
    end

    -- Custom function for buffer navigation with flash
    local function flash_buffer_jump()
      local buffers = vim.api.nvim_list_bufs()
      local current_buf = vim.api.nvim_get_current_buf()
      local targets = {}

      for _, buf in ipairs(buffers) do
        if buf ~= current_buf and vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
          local name = vim.api.nvim_buf_get_name(buf)
          if name and name ~= "" then
            -- Create a target for the buffer name in the command line area
            table.insert(targets, {
              pos = { 1, 1 },
              end_pos = { 1, #vim.fn.fnamemodify(name, ":t") },
              buf = buf,
              label = vim.fn.fnamemodify(name, ":t"):sub(1, 1):upper(),
            })
          end
        end
      end

      if #targets == 0 then
        vim.notify("No other buffers available", vim.log.levels.INFO)
        return
      end

      -- Show buffer list and use flash to select
      vim.cmd("ls")
      vim.defer_fn(function()
        require("flash").jump({
          search = { mode = "search" },
          label = { uppercase = true },
          targets = targets,
          action = function(match)
            vim.api.nvim_set_current_buf(match.buf)
          end,
        })
      end, 100)
    end

    -- Make functions available globally
    _G.flash_window_jump = flash_window_jump
    _G.flash_buffer_jump = flash_buffer_jump
  end,
  -- stylua: ignore
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    { "<leader>fw", mode = "n", function() _G.flash_window_jump() end, desc = "Flash Window Jump" },
    { "<leader>fb", mode = "n", function() _G.flash_buffer_jump() end, desc = "Flash Buffer Jump" },
  },
}
