return {
  {
    "nvim-neorg/neorg",
    build = ":Neorg sync-parsers",
    lazy = false,
    version = "9.*",
    opts = {
      load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {
          config = {
            folds = false,
            init_open_folds = "always"
          }
        },
      }
    }
  }
}
