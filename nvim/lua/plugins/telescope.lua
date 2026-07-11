local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

-- Paste the system clipboard (the "+" register, same as Neovim's clipboard
-- thanks to clipboard=unnamedplus) into the current Telescope prompt. Newlines
-- are flattened to spaces so a multi-line clipboard doesn't break the query.
local function paste_clipboard(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local clip = (vim.fn.getreg('+') or ''):gsub('[\r\n]+', ' ')
  picker:set_prompt(action_state.get_current_line() .. clip)
end

require('telescope').setup{
  defaults = {
    -- Default configuration for telescope goes here:
    mappings = {
      i = {
        ["<C-j>"] = "move_selection_next",
        ["<C-k>"] = "move_selection_previous",
        -- Paste clipboard into the prompt (<C-r>+ also works natively).
        ["<C-v>"] = paste_clipboard,
      },
      n = {
        ["q"] = actions.close,
        ["p"] = paste_clipboard,
      }
    }
  },
  pickers = {
    find_files = {
      hidden = true,
      no_ignore = true,
      no_ignore_parent = true,
    },
    buffers = {
      initial_mode = "normal"
    }
  }
}
