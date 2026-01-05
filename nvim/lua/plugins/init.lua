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
  -- Colorscheme
  { "EdenEast/nightfox.nvim", lazy = false },
  { "folke/tokyonight.nvim", lazy = false },

  -- Syntax Highlighting
  { "nvim-treesitter/nvim-treesitter" },

  -- Java Language Server
  { "mfussenegger/nvim-jdtls" },


  -- Telescope (FuzzyFinder)
  { "nvim-telescope/telescope.nvim",
    dependencies = {
      'nvim-lua/plenary.nvim'
    }
  },

  -- Diagnostics
  { 'folke/trouble.nvim',
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
