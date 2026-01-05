-- lua/plugins/treesitter.lua
return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.install").prefer_git = true

    require("nvim-treesitter.configs").setup({
      ensure_installed = { 
        "typescript",
        "javascript",
        "tsx",
      },
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
    })

    -- Force git protocol instead of tar
    for _, config in pairs(require("nvim-treesitter.parsers").get_parser_configs()) do
      config.install_info.use_makefile = true
    end
  end,
}
