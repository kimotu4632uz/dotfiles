require('packer-bootstrap')

vim.cmd('colorscheme nordfox')
vim.o.winblend = 10
vim.o.pumblend = 10

require('lualine').setup {
  options = {
    theme = 'nord',
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
vim.g['fern#default_hidden'] = 1

require("nvim-autopairs").setup {}

require('snippy').setup {
  mappings = {
    is = {
      ['<Tab>'] = 'expand_or_advance',
      ['<S-Tab>'] = 'previous',
    },
    nx = {
      ['<leader>x'] = 'cut_text',
    },
  },
}

require('mason').setup {
  ui = {
    border = 'rounded',
  },
}


local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<Leader>ef', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '<Leader>en', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', '<Leader>ep', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<Leader>el', vim.diagnostic.setloclist, opts)

local on_attach = function(client, bufnr)
  local bufopts = { noremap=true, silent=true, buffer=bufnr }

  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', '<Leader>s', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<Leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<Leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<Leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<Leader>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<Leader>m', vim.lsp.buf.formatting, bufopts)
end


local lsp = require('lspconfig')
require('mason-lspconfig').setup_handlers({ function(server_name)
  lsp[server_name].setup {
    on_attach = on_attach,
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
  }
end })


local cmp = require('cmp')
cmp.setup {
    snippet = {
      expand = function(args)
        require('snippy').expand_snippet(args.body)
      end,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'snippy' },
      { name = 'path' },
      { name = 'cmdline' },
    }, {
      { name = 'buffer' },
    }),
}

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'path' },
    { name = 'cmdline' },
  },
})


require("noice").setup {
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
  },
  -- you can enable a preset for easier configuration
  presets = {
    bottom_search = false, -- use a classic bottom cmdline for search
    command_palette = true, -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = false, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = true, -- add a border to hover docs and signature help
  },
}

require('nvim-treesitter.configs').setup {
  ensure_installed = { "vim", "regex", "lua", "bash", "fish", "markdown", "markdown_inline" },

  auto_install = true,
  highlight = {
    enable = true,
  },
}


vim.o.wrap = false
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.number = true
vim.o.guicursor = 'a:ver10-blinkon100'
vim.o.ignorecase = true
vim.o.smartcase = true

vim.opt.clipboard:append{'unnamedplus'}

vim.g.mapleader = ' '
vim.keymap.set('i', 'jj', '<ESC>')
vim.keymap.set('n', '<Leader>f', ':Fern . -reveal=%<CR>')
vim.keymap.set('n', '<Leader>o', '<C-o>')

