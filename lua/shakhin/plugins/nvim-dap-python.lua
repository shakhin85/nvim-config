return {
  "mfussenegger/nvim-dap-python",
  ft = "python",
  dependencies = {
    "mfussenegger/nvim-dap",
  },
  config = function()
    local dap_python = require("dap-python")

    -- Setup debugpy path (Mason installs it here)
    dap_python.setup("~/.local/share/nvim/mason/packages/debugpy/venv/bin/python")

    -- Test method keybinding
    vim.keymap.set("n", "<leader>dpr", function()
      require("dap-python").test_method()
    end, { desc = "Debug Python test method" })

    -- Test class keybinding
    vim.keymap.set("n", "<leader>dpc", function()
      require("dap-python").test_class()
    end, { desc = "Debug Python test class" })
  end,
}