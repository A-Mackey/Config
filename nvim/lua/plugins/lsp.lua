-- lua/plugins/lsp.lua
return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          -- Typescript
          "ts_ls",
          "pyright",
          "eslint",
          "tailwindcss",

          -- c/c++
          "clangd",

          -- Lua
          "lua_ls"
        },
      })

      -- Configure capabilities
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- Define server commands
      local servers = {
        lua_ls = {
          cmd = { "lua-language-server" },
          capabilities = capabilities,
        },
        tsserver = {
          cmd = { "typescript-language-server", "--stdio" },
          capabilities = capabilities,
          filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
        },
      }

      -- Register and start servers
      for server_name, config in pairs(servers) do
        vim.lsp.start({
          name = server_name,
          cmd = config.cmd,
          root_dir = vim.fn.getcwd(),
          capabilities = config.capabilities,
          filetypes = config.filetypes,
        })
      end

      -- Setup completion
      local cmp = require('cmp')
      cmp.setup({
        sources = {
          { name = 'nvim_lsp' },
          { name = 'buffer' },
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping.select_next_item(),
          ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        }),
      })
    end,
  }
}
