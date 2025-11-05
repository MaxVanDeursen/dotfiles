return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          }
        }
      },
      { "mason-org/mason.nvim", opts = {} },
      "mason-org/mason-lspconfig.nvim",
      { "j-hui/fidget.nvim",    opts = {} },
    },
    config = function()
      local servers = {
        ["lua_ls"] = {},
      }

      require("mason-lspconfig").setup {
        ensure_installed = vim.tbl_keys(servers),
        handlers = {
          function(server_name)
            local configuration = servers[server_name]
            require("lspconfig")[server_name].setup(configuration)
          end
        }
      }

      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then return end

          -- Format the current buffer on save.
          if client:supports_method('textDocument/formatting') then
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = args.buf,
              callback = function()
                vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
              end,
            })
          end
        end,
      })
    end
  }
}
