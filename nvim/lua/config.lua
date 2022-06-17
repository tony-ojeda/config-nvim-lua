--make life easier
local vimcmd
if vim.api ~= nil then
    vimcmd = vim.api.nvim_command
else
    vimcmd = vim.command
end

local g = vim.g
local fn = vim.fn

g.neovide_fullscreen = true
g.neovide_cursor_vfx_mode = "pixiedust"
vim.api.nvim_exec([[set guifont=Hack\ Regular\ NF:h14]], false)

--Remap space as leader key
vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.colors_name = "PaperColor"

--Remap for dealing with word wrap
vim.api.nvim_set_keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
vim.api.nvim_set_keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })

--Map blankline
vim.g.indent_blankline_char = '┊'
vim.g.indent_blankline_filetype_exclude = { 'help', 'packer' }
vim.g.indent_blankline_buftype_exclude = { 'terminal', 'nofile' }
vim.g.indent_blankline_show_trailing_blankline_indent = false

--theme
--g.material_style = "dark"
--g.material_borders = false
--g.material_contrast = false
--require('material').setup()

--##################################################
-- lines to save text folding
--##################################################
vim.g.foldmethod='manual'
vim.api.nvim_command("augroup AutoSaveFolds")
vim.api.nvim_command("autocmd!")
vim.api.nvim_command("au BufWinLeave ?* mkview 1")
vim.api.nvim_command("au BufWinEnter ?* silent! loadview 1")
vim.api.nvim_command("augroup END")

--settings
local scopes = {o = vim.o, b = vim.bo, w = vim.wo}

local function opt(scope, key, value)
  scopes[scope][key] = value
  if scope ~= 'o' then scopes['o'][key] = value end
end

local indent = 2
vimcmd 'hi NORMAL guibg=#2f334d'

opt('b', 'expandtab', true)                           -- Use spaces instead of tabs
opt('b', 'shiftwidth', indent)                        -- Size of an indent
--opt('b', 'smartindent', true)                         -- Insert indents automatically
opt('b', 'tabstop', indent)                           -- Number of spaces tabs count for
opt('o', 'completeopt', 'menuone,noinsert,noselect')           -- Completion options (for compe)
opt('o', 'fileencodings', 'utf-8,sjis,euc-jp,latin')
opt('o', 'encoding', 'utf-8')
opt('o', 'hidden', true)                              -- Enable modified buffers in background
opt('o', 'scrolloff', 3 )                             -- Lines of context
opt('o', 'shiftround', true)                          -- Round indent
opt('o', 'sidescrolloff', 8 )                         -- Columns of context
opt('o', 'smartcase', true)                           -- Don't ignore case with capitals
opt('o', 'title', true)                           
opt('o', 'background', 'light')                           
opt('o', 'autoindent', true)                           
opt('o', 'lazyredraw', true)                           
opt('o', 'ignorecase', true)                           
opt('o', 'splitbelow', true)                          -- Put new windows below current
opt('o', 'splitright', true)                          -- Put new windows right of current
opt('o', 'wildmode', 'list:longest')                  -- Command-line completion mode
opt('o', 'hlsearch', true)                           
opt('o', 'showcmd', true)                           
opt('o', 'laststatus', 2)                           
opt('o', 'updatetime', 250)                           
opt('o', 'signcolumn', 'yes')
opt('o', 'clipboard', 'unnamed,unnamedplus')
opt('o', 'pumblend', 25 )
opt('o', 'scrolloff', 2 )
opt('o', 'swapfile', false )
opt('o', 'showmode', false )
opt('o', 'backup', false )
opt('o', 'backspace', 'start,eol,indent' )
opt('w', 'number', true)                              -- Print line number
opt('o', 'lazyredraw', false)
opt('o', 'mouse', 'a')
--opt('o', 'cmdheight', 1)
opt('o', 'wrap', false)
opt('o', 'relativenumber', true)
opt('o', 'hlsearch', true)
opt('o', 'inccommand', 'split')
--opt('o', 'smarttab', true)
opt('o', 'incsearch', true)
opt('o', 'helplang', 'cn')

--opt('o', 'breakindent', true)
--opt('o', 'lbr', true)
--opt('o', 'formatoptions', 'l')

--set shortmess
vim.o.shortmess = vim.o.shortmess .. "c"

if vim.o.shell == 'fish$' then
  vim.o.shell = [[/bin/bash]]
end

