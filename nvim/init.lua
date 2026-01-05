require('options')
require('plugins')
require('keybindings')

-- Configure tokyonight with transparent background
require("tokyonight").setup({
  transparent = true,
  styles = {
    sidebars = "transparent",
    floats = "transparent",
  },
})

vim.cmd.colorscheme("tokyonight-night")

-- Orange line numbers (dimmer for inactive, bright for active)
vim.api.nvim_set_hl(0, "LineNr", { fg = "#b36b00" })
vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#b36b00" })
vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#b36b00" })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#ff9e00", bold = true })

-- plugins
require("plugins.treesitter")
require("plugins.telescope")
require("plugins.tree")
require("plugins.lsp")
require("plugins.lualine")
