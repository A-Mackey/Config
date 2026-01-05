require('options')
require('plugins')
require('keybindings')

vim.cmd.colorscheme("retrobox")

-- plugins
require("plugins.treesitter")
require("plugins.telescope")
require("plugins.tree")
require("plugins.lsp")
require("plugins.lualine")
