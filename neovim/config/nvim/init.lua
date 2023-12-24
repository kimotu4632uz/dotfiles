require('plugins')
local utils = require('utils')


-- General Options

vim.o.wrap = false
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.number = true
vim.o.guicursor = 'a:ver10-blinkon100'
vim.opt.termguicolors = true
vim.o.ignorecase = true
vim.o.smartcase = true

vim.opt.clipboard:append{'unnamedplus'}

-- Set window opacity
vim.o.winblend = 10
vim.o.pumblend = 10

vim.o.shell = 'fish'

-- Keymaps

vim.g.mapleader = ' '

vim.keymap.set('i', 'jj', '<ESC>')

vim.keymap.set('n', '<Leader>o', '<C-o>')
vim.keymap.set('n', '<Leader>i', '<C-i>')

vim.keymap.set('t', '<ESC>', '<C-\\><C-n>')

vim.keymap.set('n', '<Leader>f', function() vim.cmd[[Fern . -reveal=%]] end)
vim.keymap.set('n', '<Leader>t', utils.open_term)


-- Commands

local command = vim.api.nvim_create_user_command

-- Helper command to install LSP from CLI
command(
  'InstallLsp', 
  function(opts)
    vim.cmd.MasonInstall(opts.fargs[1])
    vim.cmd.quitall()
  end,
  { nargs = 1 }
)


-- Autocommands

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup


-- Disable line number on fern
autocmd("FileType", {
  group = augroup('fern', { clear = true }),
  pattern = "fern",
  callback = function()
    vim.opt_local.number = false
  end
})


-- Show fern when app started with no argument and not bootstrap
autocmd("VimEnter", {
  group = augroup('start_screen', { clear = true }),
  once = true,
  nested = true,
  callback = function()
    -- From startify.vim 
    if
        vim.fn.argc() == 0
      and 
        vim.fn.line2byte('$') == -1
      and
        vim.regex([[^[-gmnq]\=vim\=x\=\%[\.exe]$]]):match_str(vim.v.progname) ~= nil
      and
        not(utils.packer_bootstrap())
    then
      vim.cmd.Fern('.')
    end
  end,
})

