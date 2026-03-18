return {
  "nvim-neorg/neorg",
  build = ":Neorg sync-parsers",
  lazy = false,
  version = "9.*",
  config = function()
    require "neorg".setup {
      load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {
          config = {
            folds = false,
            init_open_folds = "always"
          }
        },
        ["core.dirman"] = {
          config = {
            workspaces = {
              notes = "~/neorg"
            },
            default_workspace = "notes"
          }
        }
      }
    }
    vim.keymap.set("n", "<leader>njt", function() vim.cmd [[Neorg journal today]] end)
  end
}
