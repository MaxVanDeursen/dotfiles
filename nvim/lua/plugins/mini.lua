return {
  {
    "echasnovski/mini.nvim",
    config = function()
      local statusline = require "mini.statusline"
      statusline.setup { use_icons = true }
      require "mini.snippets".setup {}
      require "mini.completion".setup {}
    end
  }
}
