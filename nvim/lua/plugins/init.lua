-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Initialize lazy.nvim with some plugins
require("lazy").setup({
  require("plugins.lsp"),

  -- Neovim Lua API completion / goto-def for config files
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  -- Colorscheme
  { "EdenEast/nightfox.nvim", lazy = false },
  { "folke/tokyonight.nvim", lazy = false },
  { "bluz71/vim-moonfly-colors", lazy = false },

  -- Syntax Highlighting
  { "nvim-treesitter/nvim-treesitter" },

  -- Java Language Server
  { "mfussenegger/nvim-jdtls" },

  -- Rust: rust-analyzer integration with extra commands (openDocs, hover
  -- actions, etc.). Configured through vim.g.rustaceanvim, which must be set
  -- before the plugin starts the LSP — hence `init` rather than `opts`.
  {
    "mrcjkb/rustaceanvim",
    version = "^6",
    lazy = false, -- the plugin lazy-loads itself on rust files
    init = function()
      vim.g.rustaceanvim = {
        server = {
          on_attach = function(_, bufnr)
            local map = vim.keymap.set
            -- Hover with actionable links (impls, go-to-type-def). Replaces the
            -- plain vim.lsp.buf.hover from keybindings.lua for Rust buffers.
            map("n", "gk", function()
              vim.cmd.RustLsp({ "hover", "actions" })
            end, { buffer = bufnr, desc = "Rust hover actions" })
            -- Full generated rustdoc for the symbol under cursor: lists every
            -- field and method with its visibility.
            map("n", "<leader>rd", function()
              vim.cmd.RustLsp("openDocs")
            end, { buffer = bufnr, desc = "Open rustdoc for symbol" })
          end,
          default_settings = {
            ["rust-analyzer"] = {
              hover = {
                show = {
                  fields = 50,
                  enumVariants = 50,
                  traitAssocItems = 50,
                },
                memoryLayout = { enable = true },
                documentation = { keywords = { enable = true } },
              },
            },
          },
        },
      }
    end,
  },


  -- Telescope (FuzzyFinder)
  { "nvim-telescope/telescope.nvim",
    dependencies = {
      'nvim-lua/plenary.nvim'
    }
  },

  -- Diagnostics
  { 'folke/trouble.nvim',
    opts = {},
    cmd = "Trouble",
    dependencies = {
      'nvim-tree/nvim-web-devicons'
    }
  },

  -- File Explorer
  { "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      'nvim-tree/nvim-web-devicons'
    }
  },

  -- Floating UI for vim.ui.select and vim.ui.input (code actions, rename, etc.)
  { 'stevearc/dressing.nvim', config = true },

  -- Render markdown in LSP hover popups
  { 'MeanderingProgrammer/render-markdown.nvim',
    opts = {
      file_types = { 'markdown', 'Avante' },
      overrides = {
        buftype = {
          nofile = { enabled = true },
        },
      },
    },
  },

  -- Autocomplete {}[]()"" etc
  { 'windwp/nvim-autopairs', config = true },

  -- Git blame
  { 'lewis6991/gitsigns.nvim' },

  -- Indentation
  { 'lukas-reineke/indent-blankline.nvim', main = "ibl" },

  -- Shows keymappings
  { 'folke/which-key.nvim', config = true },

  -- Lualine (Line at bottom of screen)
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons'
    }
  },
})
