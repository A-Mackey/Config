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
map('n', 'gd', require('telescope.builtin').lsp_definitions, { desc = 'Go to definition' })
map('n', 'gk', vim.lsp.buf.hover, { desc = 'Hover documentation' })
map('n', 'gi', require('telescope.builtin').lsp_implementations, { desc = 'Go to implementation' })
map('n', '<C-k>', vim.lsp.buf.signature_help, { desc = 'Signature help' })
map('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename' })
map('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code actions' })
map('n', '<leader>cf', function()
    vim.lsp.buf.format({ async = true })
end, { desc = 'Format file' })
map('n', '<leader>cl', function()
    -- Apply "fix all" / organize imports (e.g. remove unused imports), but only
    -- for the action kinds the attached server actually advertises. This avoids
    -- the "No code actions available" message on servers like rust-analyzer that
    -- don't implement source.organizeImports.
    local supported = {}
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
        local provider = client.server_capabilities.codeActionProvider
        for _, kind in ipairs((type(provider) == 'table' and provider.codeActionKinds) or {}) do
            supported[kind] = true
        end
    end
    for _, kind in ipairs({ 'source.fixAll', 'source.organizeImports' }) do
        if supported[kind] then
            vim.lsp.buf.code_action({
                context = { only = { kind }, diagnostics = {} },
                apply = true,
            })
        end
    end
end, { desc = 'Lint fix & organize imports' })
map('n', 'gr', require('telescope.builtin').lsp_references, { desc = 'Go to references' })

-- Telescope
map('n', '<leader>f', '<cmd>Telescope find_files<cr>', { desc = "Find File"})
map('n', '<leader>g', '<cmd>Telescope live_grep<cr>', { desc = "Grep Search"})
-- Grep prefilled with the system clipboard (Neovim's "+" register). Newlines
-- are flattened so a multi-line clipboard doesn't break the search.
map('n', '<leader>G', function()
    require('telescope.builtin').live_grep({
        default_text = (vim.fn.getreg('+') or ''):gsub('[\r\n]+', ' '),
    })
end, { desc = "Grep clipboard contents" })
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
map('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', { desc = "Toggle Trouble diagnostics" })
map('n', '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', { desc = "Toggle Trouble diagnostics (current buffer)" })



-- Tree
map('n', '<leader>e', ':NvimTreeToggle<CR>')
map('n', '<leader>o', ':NvimTreeFindFile!<CR>', { desc = "Locate current file in tree" })
map('n', '<leader>v', function()
  api.node.open.vertical()
end, { desc = "Open NvimTree file in vertical split" })
map('n', '<leader>s', function()
  api.node.open.horizontal()
end, { desc = "Open NvimTree file in horizontal split" })
