local lsp = require('lsp-zero')
local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

lsp.preset('recommended')

cmp.setup({
    mapping = {
        ['<CR>'] = cmp.mapping.confirm({select = true}),
        ['<Tab>'] = cmp_action.luasnip_supertab(),
        ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
    }
})

lsp.on_attach(function(client, bufnr)
  -- Configuração padrão de mapeamentos
  lsp.default_keymaps({buffer = bufnr})

  -- Mapeamento adicional para code_action
  local opts = { noremap=true, silent=true }
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>e', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
end)

lsp.setup()
