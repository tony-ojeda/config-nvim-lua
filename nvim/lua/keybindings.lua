---------------
--  GENERAL  --
---------------
--mappings
local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- luasnip setup
local luasnip = require 'luasnip'
-- nvim-cmp setup
local cmp = require 'cmp'
local nvim_lsp = require('lspconfig')

local numbers = {"1", "2", "3", "4", "5", "6", "7", "8", "9"}

map('n', '<c-s>', ':w!<CR>')
map('i', '<c-s>', '<Esc>:w!<CR>')
map('n', '<leader>+', ':5winc +<CR>')
map('n', '<leader><', ':20winc <<CR>')
map('n', '<leader>>', ':20winc ><CR>')
map('n', '<leader>-', ':5winc -<CR>')
map('n', '<leader>w', ':w! -<CR>')
map('n', '<leader>q', ':q<CR>')
map('n', '<CR>', 'o<ESC>')
map('n', '<space>ul', ':call ListUltisnips()')
map('i', '<c-o>ul', ':call ListUltisnips()')

vim.cmd([[
set notimeout
set encoding=utf-8
]])

--use tab to navigate autocomplete
local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
local opts_expr = { noremap = true, expr = true }

_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  --elseif vim.fn.call("vsnip#available", {1}) == 1 then
   -- return t "<Plug>(vsnip-expand-or-jump)"
  elseif check_back_space() then
   return t "<Tab>"
  end
end

_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  --elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
   -- return t "<Plug>(vsnip-jump-prev)"
  else
    return t "<S-Tab>"
  end
end
-- vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", opts_expr)
-- map("i", "<Tab>", "v:lua.tab_complete()", opts_expr)
-- map("s", "<Tab>", "v:lua.tab_complete()", opts_expr)
-- map("i", "<S-Tab>", "v:lua.s_tab_complete()", opts_expr)
-- map("s", "<S-Tab>", "v:lua.s_tab_complete()", opts_expr)

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  source = {
    path = true,
    nvim_lsp = true,
    luasnip = true,
    buffer = false,
    calc = false,
    nvim_lua = false,
    vsnip = true,
    ultisnips = true,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

-- Utility functions for compe and luasnip
local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = vim.fn.col '.' - 1
  if col == 0 or vim.fn.getline('.'):sub(col, col):match '%s' then
    return true
  else
    return false
  end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
local luasnip = require 'luasnip'

_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t '<C-n>'
  elseif luasnip.expand_or_jumpable() then
    return t '<Plug>luasnip-expand-or-jump'
  elseif check_back_space() then
    return t '<Tab>'
  end
end

_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t '<C-p>'
  elseif luasnip.jumpable(-1) then
    return t '<Plug>luasnip-jump-prev'
  else
    return t '<S-Tab>'
  end
end

-- Map tab to the above tab complete functiones
vim.api.nvim_set_keymap('i', '<Tab>', 'v:lua.tab_complete()', { expr = true })
vim.api.nvim_set_keymap('s', '<Tab>', 'v:lua.tab_complete()', { expr = true })
vim.api.nvim_set_keymap('i', '<S-Tab>', 'v:lua.s_tab_complete()', { expr = true })
vim.api.nvim_set_keymap('s', '<S-Tab>', 'v:lua.s_tab_complete()', { expr = true })


map('n', '<c-j>', '<c-w>j')
map('n', '<c-h>', '<c-w>h')
map('n', '<c-k>', '<c-w>k')
map('n', '<c-l>', '<c-w>l')

------------------
--  LSP CONFIG  --
------------------
local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    -- Mappings.
    local opts = { noremap=true, silent=true }
    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    --buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    --buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<space>di', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
    buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)--...

    --protocol.CompletionItemKind = 
end

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)


-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'tsserver', 'pyright','intelephense', 'html', 'cssls', 'dockerls', 'angularls', 'vuels', 'tailwindcss', 'diagnosticls','eslint' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
    capabilities = capabilities,
  }
end

----------------
--  LSP SAGA  --
----------------
map("n", "gr", "<cmd>Lspsaga rename<cr>", {silent = true, noremap = true})
map("n", "gx", "<cmd>Lspsaga code_action<cr>", {silent = true, noremap = true})
map("x", "gx", ":<c-u>Lspsaga range_code_action<cr>", {silent = true, noremap = true})
map("n", "<leader>K",  "<cmd>Lspsaga hover_doc<cr>", {silent = true, noremap = true})
map("n", "go", "<cmd>Lspsaga show_line_diagnostics<cr>", {silent = true, noremap = true})
map("n", "gj", "<cmd>Lspsaga diagnostic_jump_next<cr>", {silent = true, noremap = true})
map("n", "gk", "<cmd>Lspsaga diagnostic_jump_prev<cr>", {silent = true, noremap = true})
map("n", "<C-u>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<cr>")
map("n", "<C-d>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<cr>")

-----------------
--  TELESCOPE  --
----------------
map('n', '<leader>ft', '<cmd>Telescope<CR>')                   --fuzzy
map('n', '<leader>fr', '<cmd>Telescope oldfiles<CR>')                   --fuzzy
map('n', '<leader>p', '<cmd>Telescope find_files<CR>')
map('n', '<leader>fb', '<cmd>Telescope buffers<CR>')
map('n', '<leader>f', '<cmd>Telescope current_buffer_fuzzy_find<CR>')
map('n', '<leader>g', '<cmd>Telescope live_grep<CR>')
--map('n', '<leader>fs', '<cmd>Telescope treesitter<CR>')
map('n', '<leader>fc', '<cmd>Telescope commands<CR>')
map('n', '<leader>fp', '<cmd>Telescope project<CR>')
map('n', '<leader>fm', '<cmd>Telescope marks<CR>')

--------------------
--  NERDTREEFIND  --
--------------------
map('n', '<leader>nt', ':NERDTreeFind<CR>')
map('n', '<leader>;', ':Files<CR>')
map('n', '<leader>:', ':Lines<CR>')

-----------------
--  GITGUTTER  --
-----------------
map('n', '<leader>gh', ':GitGutterLineHighlightsToggle<CR>')
map('n', ']g', ':GitGutterNextHunk<CR>')
map('n', '[g', ':GitGutterPrevHunk<CR>')

-----------------
--  MULTITERM  --
-----------------
map('n', 't', ':Multiterm<CR>')
map('t', '<f2>', '<c-\\><c-n>:Multiterm<CR>')
for _, num in pairs(numbers) do
  map('n', num..'t', ':'..num..'Multiterm<CR>')
end


-- https://stackoverflow.com/questions/11993851/how-to-delete-not-cut-in-vim
map('n', '<leader>d', '"_d')
map('x', '<leader>d', '"_d')
map('x', '<leader>p', '"_dP')

---------------
--  LAZYGIT  --
---------------
map('n', '<leader>lg', ':LazyGit<CR>')

---------------
--  TEST  --
---------------
map('n', '<leader>t', ':TestNearest<CR>')
map('n', '<leader>T', ':TestFile<CR>')
map('n', '<leader>TT', ':TestSuite<CR>')

------------------
--  Quick semi  --
------------------
map('n', '<leader>;', '$a;<Esc>')

------------------
--  diagnostic  --
------------------
map('n', '<leader>kp', ':let @*=expand("%")<CR>')

---------------
--  Buffers  --
---------------
map('n', '<leader>ob', ':Buffers<CR>')

---------------
--  easymotion  --
---------------
map('n', '<leader>s', '<Plug>(easymotion-s2)')

---------------
--  run current file  --
---------------
map('n', '<leader>x', ':!node %<CR>')
