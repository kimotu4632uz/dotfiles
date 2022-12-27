local lsp = require('lspconfig')
local mason = require('mason-lspconfig')
local cmp_lsp = require('cmp_nvim_lsp')

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


mason.setup_handlers({ function(server_name)
  lsp[server_name].setup {
    on_attach = on_attach,
    capabilities = cmp_lsp.default_capabilities(),
  }
end })

