-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

require("nvim-tree").setup({
  sort = {
    -- Folders first, except a `foo.rs` sibling sorts right after `foo/` (Rust modules).
    sorter = function(nodes)
      local dirs = {}
      for _, n in ipairs(nodes) do
        if n.type == "directory" then dirs[n.name] = true end
      end
      local function key(n)
        if n.type ~= "directory" and n.name == "mod.rs" then
          -- `mod.rs` always pinned to the top of its directory.
          return { -1, "", 0 }
        end
        if n.type == "directory" then
          return { 0, n.name, 1 }
        end
        local stem = n.name:match("^(.+)%.rs$")
        if stem and dirs[stem] then
          return { 0, stem, 0 }
        end
        return { 1, n.name, 0 }
      end
      table.sort(nodes, function(a, b)
        local ka, kb = key(a), key(b)
        for i = 1, 3 do
          if ka[i] ~= kb[i] then return ka[i] < kb[i] end
        end
        return false
      end)
    end,
  },
  git = {
    ignore = false,
  },
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
    icons = {
      -- Draw git status in the sign column (gutter) instead of inline, so
      -- changed-file icons never shift the filename/directory text around.
      git_placement = "signcolumn",
    },
  },
  filters = {
  },
})
