return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make"
    }
  },
  config = function()
    require("telescope").setup {
      defaults = {
        file_ignore_patterns = { "^.git/" },
      },
      pickers = {
        find_files = {
          theme = "ivy",
          hidden = true,
        }
      },
      extensions = {
        fzf = {}
      }
    }

    require("telescope").load_extension("fzf")

    local builtin = require "telescope.builtin"

    -- Fuzzy find files from current working directory.
    vim.keymap.set("n", "<space>fd", builtin.find_files)
    vim.keymap.set("n", "<space>fg", builtin.find_files)

    -- Fuzzy find help tags.
    vim.keymap.set("n", "<space>fh", builtin.help_tags)

    -- Fuzzy find files in configuration.
    vim.keymap.set("n", "<space>en", function()
      builtin.find_files {
        cwd = vim.fn.stdpath("config")
      }
    end)

    vim.keymap.set("n", "<space>ep", function()
      builtin.find_files {
        cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy")
      }
    end)

    require "plugins/telescope/multigrep".setup()
  end
}
