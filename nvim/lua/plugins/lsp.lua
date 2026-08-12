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
          "arduino_language_server",
        },
        -- v2 default: vim.lsp.enable() is called for every installed server.
        -- rustaceanvim owns rust_analyzer (starts/configures it itself), so we
        -- still let Mason install the binary but exclude it from auto-enable to
        -- avoid attaching it twice.
        automatic_enable = { exclude = { "rust_analyzer" } },
      })

      -- Default capabilities applied to every server (nvim-cmp completion support).
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      vim.lsp.config("*", { capabilities = capabilities })

      -- Per-server overrides (merged on top of nvim-lspconfig's defaults).
      vim.lsp.config("clangd", {
        cmd = { "clangd", "--background-index" },
      })

      -- arduino-language-server is a thin wrapper: it shells out to arduino-cli
      -- to compile the sketch, then feeds the resulting compile_commands to
      -- clangd. lspconfig's default cmd passes no flags, so it can't find any of
      -- those and silently returns no completions/diagnostics. All four must be
      -- explicit.
      local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/"
      vim.lsp.config("arduino_language_server", {
        cmd = {
          mason_bin .. "arduino-language-server",
          "-cli", vim.fn.exepath("arduino-cli"),
          "-cli-config", vim.fn.expand("~/.arduino15/arduino-cli.yaml"),
          "-clangd", mason_bin .. "clangd",
          -- Fallback only; a sketch.yaml with default_fqbn takes precedence.
          "-fqbn", "arduino:avr:uno",
        },
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
