-- lua/keymaps.lua
local map = vim.keymap.set
local api = require('nvim-tree.api')

-- Normal mode mappings
map('n', '<leader>w', ':w<CR>', { desc = 'Save file' })
map('n', '<leader>q', ':q<CR>', { desc = 'Quit' })
map('n', '<leader>x', ':wqa<CR>', { desc = 'Save & Quit' })
map('n', '<leader>l', ':Lazy<CR>', { desc = 'Save & Quit' })
map('n', '<C-u>', '<C-u>zz', { desc = "Half page up and center" })
map('n', '<C-d>', '<C-d>zz', { desc = "Half page down and center" })
map('n', 'n', 'nzzzv', { desc = "Next search result and center" })
map('n', 'N', 'Nzzzv', { desc = "Previous search result and center" })

-- Buffer Navigations
map('n', '<C-h>', '<C-w>h', { desc = "Move to left window" })
map('n', '<C-l>', '<C-w>l', { desc = "Move to right window" })
map('n', '<C-j>', '<C-w>j', { desc = "Move to bottom window" })
map('n', '<C-k>', '<C-w>k', { desc = "Move to top window" })
-- Buffer Resize
map('n', '<C-Right>', ':vertical resize +5<CR>', { desc = "Increase window width" })
map('n', '<C-Left>', ':vertical resize -5<CR>', { desc = "Decreate window width" })
map('n', '+', ':vertical resize +5<CR>', { desc = "Increase window width" })
map('n', '_',  ':vertical resize -5<CR>', { desc = "Decrease window width" })
map('n', '<C-Up>',    ':resize +3<CR>', { desc = "Increase window height" })
map('n', '<C-Down>',  ':resize -3<CR>', { desc = "Decrease window height" })

map('n', '<leader>tv', ':vsplit | terminal<CR>i', { desc = "Vertical terminal right" })
map('n', '<leader>th', ':split | terminal<CR>i', { desc = "Horizontal terminal below" })

-- Map jk in terminal mode to exit to normal mode
map('t', 'jk', [[<C-\><C-n>]], { desc = "Exit terminal mode" })
map('t', '<Esc>', [[<C-\><C-n>]], { desc = "Exit terminal mode" })

-- Visual mode mappings
map('v', '<leader>c', '"+y', { desc = 'Copy to system clipboard' })

-- Insert mode mappings
map('i', 'jk', '<ESC>', { desc = 'Exit insert mode' })
map('i', 'JK', '<ESC>', { desc = 'Exit insert mode' })
map('i', 'jK', '<ESC>', { desc = 'Exit insert mode' })
map('i', 'Jk', '<ESC>', { desc = 'Exit insert mode' })


-- LSP keybindings
map('n', 'gD', vim.lsp.buf.declaration, { desc = 'Go to declaration' })
map('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
map('n', 'K', vim.lsp.buf.hover, { desc = 'Hover documentation' })
map('n', 'gi', vim.lsp.buf.implementation, { desc = 'Go to implementation' })
map('n', '<C-k>', vim.lsp.buf.signature_help, { desc = 'Signature help' })
map('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename' })
map('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code actions' })
map('n', 'gr', vim.lsp.buf.references, { desc = 'Go to references' })

-- Telescope
map('n', '<leader>f', '<cmd>Telescope find_files<cr>', { desc = "Find File"})
map('n', '<leader>g', '<cmd>Telescope live_grep<cr>', { desc = "Grep Search"})
map('n', '<leader>h', '<cmd>Telescope help_tags<cr>', { desc = "Find Help"})
map('n', '<leader>b', function()
    require('telescope.builtin').buffers({
        sort_lastused = true,
        ignore_current_buffer = true,
        path_display = { "tail" },
        sort_mru = true,
        layout_config = {
            width = 0.7,
            height = 0.5,
        }
    })
end, { desc = "Find buffers" })
map('n', ';', function()
    require('telescope.builtin').buffers({
        sort_lastused = true,
        ignore_current_buffer = true,
        path_display = { "tail" },
        sort_mru = true,
        layout_config = {
            width = 0.7,
            height = 0.5,
        }
    })
end, { desc = "Find buffers" })
map('n', '<leader>d', vim.diagnostic.open_float, { desc = "Show diagnostics" })



-- Tree
map('n', '<leader>e', ':NvimTreeToggle<CR>')
map('n', '<leader>o', ':NvimTreeFindFile!<CR>', { desc = "Locate current file in tree" })
map('n', '<leader>v', function()
  api.node.open.vertical()
end, { desc = "Open NvimTree file in vertical split" })
map('n', '<leader>s', function()
  api.node.open.horizontal()
end, { desc = "Open NvimTree file in horizontal split" })

