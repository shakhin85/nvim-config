return {
  "nvim-pack/nvim-spectre",
  build = false,
  cmd = "Spectre",
  opts = { open_cmd = "noswapfile vnew" },
  -- stylua: ignore
  keys = {
    { "<leader>sr", function() require("spectre").toggle() end, desc = "Replace in files (Spectre)" },
    { "<leader>sw", function() require("spectre").open_visual({select_word=true}) end, desc = "Search current word" },
    { "<leader>sw", function() require("spectre").open_visual() end, mode = "v", desc = "Search current word" },
    { "<leader>sp", function() require("spectre").open_file_search({select_word=true}) end, desc = "Search on current file" },
  },
}