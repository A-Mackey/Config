local actions = require('telescope.actions')

require('telescope').setup{
  defaults = {
    -- Default configuration for telescope goes here:
    mappings = {
      i = {
        ["<C-j>"] = "move_selection_next",
        ["<C-k>"] = "move_selection_previous",
      },
      n = {
        ["q"] = actions.close,
      }
    }
  },
  pickers = {
    buffers = {
      initial_mode = "normal"
    }
  }
}

