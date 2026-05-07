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
      vim.diagnostic.config({ update_in_insert = true })

      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "ts_ls",
          "pyright",
          "eslint",
          "tailwindcss",
          "lua_ls",
          "rust_analyzer",
          "clangd",
        },
        -- v2 default: vim.lsp.enable() is called for every installed server.
        -- automatic_enable = true,
      })

      -- Default capabilities applied to every server (nvim-cmp completion support).
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      vim.lsp.config("*", { capabilities = capabilities })

      -- Per-server overrides (merged on top of nvim-lspconfig's defaults).
      vim.lsp.config("clangd", {
        cmd = { "clangd", "--background-index" },
      })

      -- Completion
      local cmp = require("cmp")
      cmp.setup({
        sources = {
          { name = "nvim_lsp" },
          { name = "buffer" },
        },
        mapping = cmp.mapping.preset.insert({
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        }),
      })
    end,
  },
}
