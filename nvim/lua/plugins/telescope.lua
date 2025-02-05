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
      pickers = {
        find_files = {
          theme = "ivy"
        }
      },
      extensions = {
        fzf = {}
      }
    }

    require("telescope").load_extension("fzf")

    -- Fuzzy find files from current working directory.
    vim.keymap.set("n", "<space>fd", require("telescope.builtin").find_files)

    -- Fuzzy find help tags.
    vim.keymap.set("n", "<space>fh", require("telescope.builtin").help_tags)

    -- Find current references to text under cursor.
    vim.keymap.set("n", "<space>fr", require("telescope.builtin").lsp_references)

    -- Fuzzy find files in configuration.
    vim.keymap.set("n", "<space>en", function()
      require("telescope.builtin").find_files {
        cwd = vim.fn.stdpath("config")
      }
    end)

    vim.keymap.set("n", "<space>ep", function()
      require("telescope.builtin").find_files {
        cwd = vim.fs.joinpath(vim.fn.stdpath("data")[0], "lazy")
      }
    end)

    require "plugins/telescope/multigrep".setup()
  end
}
