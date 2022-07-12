require('packer-bootstrap')

local lualine = require('lualine')
lualine.setup {
  options = {
    theme = 'ayu_light',
    component_separators = { left = '|', right = '|' },
    section_separators = { left = '', right = '' },
    globalstatus = true,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {
      'encoding',
      {'fileformat', icons_enabled = false},
      'filetype',
    },
    lualine_y = {},
    lualine_z = {'location'},
  },
}

vim.g['fern#renderer'] = 'nerdfont'


vim.o.wrap = false
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.number = true
vim.o.guicursor = 'a:ver10-blinkon100'
vim.o.ignorecase = true
vim.o.smartcase = true

vim.g.mapleader = ' '
vim.keymap.set('i', 'jj', '<ESC>')
vim.keymap.set('n', '<Leader>f', ':Fern . -reveal=%<CR>')
vim.keymap.set('n', '<Leader>o', '<C-o>')
