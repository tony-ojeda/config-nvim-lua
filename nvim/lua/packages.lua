--Install packer
local execute = vim.api.nvim_command
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim '.. install_path)
end

require('packer').startup(function()
    use 'wbthomason/packer.nvim'

    -------------
    --  THEME  --
    -------------
    --use 'shaunsingh/moonlight.nvim'
    --use 'marko-cerovac/material.nvim'
    --use 'gruvbox-community/gruvbox'
    --use 'itchyny/lightline.vim'
    --use 'ayu-theme/ayu-vim'
    use 'NLKNguyen/papercolor-theme'

    -----------
    --  IDE  --
    -----------
    use {'hoob3rt/lualine.nvim', requires = {'kyazdani42/nvim-web-devicons', opt = true}}
    use 'junegunn/vim-emoji'
    use 'mhinz/vim-signify'
    use 'yggdroot/indentline'
    use 'easymotion/vim-easymotion'
    use 'editorconfig/editorconfig-vim'
    --use 'romgrk/barbar.nvim'
    use 'wakatime/vim-wakatime'
    use 'kosayoda/nvim-lightbulb' --The plugin shows a lightbulb in the sign column whenever a textDocument/codeAction is available at the current cursor position.
    use 'onsails/lspkind-nvim' --This tiny plugin adds vscode-like pictograms to neovim built-in lsp:
    use 'SirVer/ultisnips'
    use 'mlaursen/vim-react-snippets'
    -- LSP
    -- use 'glepnir/lspsaga.nvim'
    use { 'tami5/lspsaga.nvim', branch = 'nvim6.0' }
    use 'neovim/nvim-lspconfig'
    use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
    --use {'ray-x/lsp_signature.nvim',} --Show function signature when you type (working in lsp_saga)
    use 'RishabhRD/popfix'
    use 'RishabhRD/nvim-lsputils'
    use 'jose-elias-alvarez/nvim-lsp-ts-utils'

    -- use 'kiteco/vim-plugin' -- config for Kite
    use 'pangloss/vim-javascript'
    use 'mxw/vim-jsx'
    -- post install (yarn install | npm install) then load plugin only for editing supported files
    use {'prettier/vim-prettier', 
    run = 'npm install --frozen-lockfile --production', ft  = { 'javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'svelte', 'yaml', 'html' } }
    --use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    --use 'nvim-lua/completion-nvim' 
    --use 'hrsh7th/nvim-compe' -- not recommend nvim-treesitter (deprecated)
    use 'hrsh7th/nvim-cmp' -- (now)
    use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
    use {'neoclide/coc.nvim', branch='master', run = 'npm install --frozen-lockfile'}
    use 'andymass/vim-matchup' -- resalta las etiquetas html
    use 'L3MON4D3/LuaSnip' -- Snippets plugin
    use 'nvim-lua/popup.nvim'
    use 'lukas-reineke/indent-blankline.nvim' -- Add indentation guides even on blank lines
    use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } } ---- Add git related info in the signs columns and popups
    use 'nvim-lua/plenary.nvim'
    use { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim' } }
    use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    --use 'scrooloose/nerdtree'
    use 'preservim/nerdtree'
    use 'Xuyuanp/nerdtree-git-plugin'
      -- Highlight, edit, and navigate code using a fast incremental parsing library
    use 'nvim-treesitter/nvim-treesitter'
    -- Additional textobjects for treesitter
   use 'nvim-treesitter/nvim-treesitter-textobjects' 
    use 'tpope/vim-fugitive' -- Git commands in nvim
    use 'tpope/vim-rhubarb' -- Fugitive-companion to interact with github
    use 'ludovicchabant/vim-gutentags' -- Automatic tags management
    use 'christoomey/vim-tmux-navigator'
    --use 'skammer/vim-css-color' -- Display the hexadecimal colors  #slow in open files (nerdtre, telescope)
    use 'ap/vim-css-color'
    use 'machakann/vim-swap' -- swap arguments in parenthesis
    use 'mileszs/ack.vim' -- Search text  and $sudo apt-get install ack-grep
    use {'mg979/vim-visual-multi', branch= 'master'} -- use ctro + n "multi select"
    use {'turbio/bracey.vim', run = 'npm install --prefix server'}
    use 'jiangmiao/auto-pairs' --Insert or delete brackets, parens, quotes in pair.
    use 'chengzeyi/multiterm.vim'
    use 'ryanoasis/vim-webdevicons'
    use 'jwalton512/vim-blade' -- blade laravel
    use 'heapslip/vimage.nvim'
    use 'tpope/vim-surround' -- 'text test' change to *text test*
    use 'tpope/vim-repeat' 
    -- use 'tpope/vim-commentary'
    -- use 'numToStr/Comment.nvim' -- "gc" to comment visual regions/lines
    use 'scrooloose/nerdcommenter'
    use 'mattn/emmet-vim'
    use 'moll/vim-bbye' -- Bbye allows you to do delete buffers (close files) without closing your windows or messing up your layout.
    use {'kdheepak/lazygit.nvim', branch='nvim-v0.4.3'}
    use 'APZelos/blamer.nvim'
    use '0x84/vim-coderunner' -- run selected code (php, js, python, ...)

    ------------
    --  TEST  --
    ------------
    use 'tyewang/vimux-jest-test'
    use 'janko-m/vim-test'

end)

