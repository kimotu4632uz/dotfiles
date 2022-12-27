require('nvim-treesitter.configs').setup {
  ensure_installed = { "vim", "regex", "lua", "bash", "fish", "markdown", "markdown_inline" },
  
  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = true,

  auto_install = true,
  highlight = {
    enable = true,
  },
}

