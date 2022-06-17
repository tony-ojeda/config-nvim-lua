------------------
--  LSP CONFIG  --
------------------
local nvim_lsp = require('lspconfig')
nvim_lsp.diagnosticls.setup {
on_attach = on_attach,
  filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'json', 'typescript', 'typescriptreact', 'typescript.tsx', 'css', 'less', 'scss', 'markdown', 'pandoc' },
  root_dir = nvim_lsp.util.root_pattern("package.json", "tsconfig.json", ".git"),
  init_options = {
    linters = {
      -- eslint = {
      --   command = 'eslint_d',
      --   rootPatterns = { '.git' },
      --   debounce = 100,
      --   args = { '--stdin', '--stdin-filename', '%filepath', '--format', 'json' },
      --   sourceName = 'eslint_d',
      --   parseJson = {
      --     errorsRoot = '[0].messages',
      --     line = 'line',
      --     column = 'column',
      --     endLine = 'endLine',
      --     endColumn = 'endColumn',
      --     message = '[eslint] ${message} [${ruleId}]',
      --     security = 'severity'
      --   },
      --   securities = {
      --     [2] = 'error',
      --     [1] = 'warning'
      --   }
      -- },
    },
    filetypes = {
      -- javascript = 'eslint',
      -- javascriptreact = 'eslint',
      -- typescript = 'eslint',
      -- typescriptreact = 'eslint',
    },
    formatters = {
      -- eslint_d = {
      --   command = 'eslint_d',
      --   args = { '--stdin', '--stdin-filename', '%filename', '--fix-to-stdout' },
      --   rootPatterns = { '.git' },
      -- },
      -- prettier = {
      --   command = 'prettier',
      --   args = { '--stdin-filepath', '%filename' }
      -- }
    },
    formatFiletypes = {
      -- css = 'prettier',
      -- javascript = 'eslint_d',
      -- javascriptreact = 'eslint_d',
      -- json = 'prettier',
      -- scss = 'prettier',
      -- less = 'prettier',
      -- typescript = 'eslint_d',
      -- typescriptreact = 'eslint_d',
      -- json = 'prettier',
      -- markdown = 'prettier',
    }
  }
}


nvim_lsp.tsserver.setup({
    -- Needed for inlayHints. Merge this table with your settings or copy
    -- it from the source if you want to add your own init_options.
    init_options = require("nvim-lsp-ts-utils").init_options,
    --
    on_attach = function(client, bufnr)
        local ts_utils = require("nvim-lsp-ts-utils")

        -- defaults
        ts_utils.setup({
            debug = false,
            disable_commands = false,
            enable_import_on_completion = false,

            -- import all
            import_all_timeout = 5000, -- ms
            -- lower numbers = higher priority
            import_all_priorities = {
                same_file = 1, -- add to existing import statement
                local_files = 2, -- git files or files with relative path markers
                buffer_content = 3, -- loaded buffer content
                buffers = 4, -- loaded buffer names
            },
            import_all_scan_buffers = 100,
            import_all_select_source = false,
            -- if false will avoid organizing imports
            always_organize_imports = true,

            -- filter diagnostics
            filter_out_diagnostics_by_severity = {},
            filter_out_diagnostics_by_code = {},

            -- inlay hints
            auto_inlay_hints = true,
            inlay_hints_highlight = "Comment",
            inlay_hints_priority = 200, -- priority of the hint extmarks
            inlay_hints_throttle = 150, -- throttle the inlay hint request
            inlay_hints_format = { -- format options for individual hint kind
                Type = {},
                Parameter = {},
                Enum = {},
                -- Example format customization for `Type` kind:
                -- Type = {
                --     highlight = "Comment",
                --     text = function(text)
                --         return "->" .. text:sub(2)
                --     end,
                -- },
            },

            -- update imports on file move
            update_imports_on_move = false,
            require_confirmation_on_move = false,
            watch_dir = nil,
        })

        -- required to fix code action ranges and filter diagnostics
        ts_utils.setup_client(client)

        -- no default maps, so you may want to define some here
        local opts = { silent = true }
        vim.api.nvim_buf_set_keymap(bufnr, "n", "gs", ":TSLspOrganize<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", ":TSLspRenameFile<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", ":TSLspImportAll<CR>", opts)
    end,
})
----------------
--  LSP UTIL  --
----------------
if vim.fn.has('nvim-0.5.1') == 1 then
    vim.lsp.handlers['textDocument/codeAction'] = require'lsputil.codeAction'.code_action_handler
    vim.lsp.handlers['textDocument/references'] = require'lsputil.locations'.references_handler
    vim.lsp.handlers['textDocument/definition'] = require'lsputil.locations'.definition_handler
    vim.lsp.handlers['textDocument/declaration'] = require'lsputil.locations'.declaration_handler
    vim.lsp.handlers['textDocument/typeDefinition'] = require'lsputil.locations'.typeDefinition_handler
    vim.lsp.handlers['textDocument/implementation'] = require'lsputil.locations'.implementation_handler
    vim.lsp.handlers['textDocument/documentSymbol'] = require'lsputil.symbols'.document_handler
    vim.lsp.handlers['workspace/symbol'] = require'lsputil.symbols'.workspace_handler
else
    local bufnr = vim.api.nvim_buf_get_number(0)

    vim.lsp.handlers['textDocument/codeAction'] = function(_, _, actions)
        require('lsputil.codeAction').code_action_handler(nil, actions, nil, nil, nil)
    end

    vim.lsp.handlers['textDocument/references'] = function(_, _, result)
        require('lsputil.locations').references_handler(nil, result, { bufnr = bufnr }, nil)
    end

    vim.lsp.handlers['textDocument/definition'] = function(_, method, result)
        require('lsputil.locations').definition_handler(nil, result, { bufnr = bufnr, method = method }, nil)
    end

    vim.lsp.handlers['textDocument/declaration'] = function(_, method, result)
        require('lsputil.locations').declaration_handler(nil, result, { bufnr = bufnr, method = method }, nil)
    end

    vim.lsp.handlers['textDocument/typeDefinition'] = function(_, method, result)
        require('lsputil.locations').typeDefinition_handler(nil, result, { bufnr = bufnr, method = method }, nil)
    end

    vim.lsp.handlers['textDocument/implementation'] = function(_, method, result)
        require('lsputil.locations').implementation_handler(nil, result, { bufnr = bufnr, method = method }, nil)
    end

    vim.lsp.handlers['textDocument/documentSymbol'] = function(_, _, result, _, bufn)
        require('lsputil.symbols').document_handler(nil, result, { bufnr = bufn }, nil)
    end

    vim.lsp.handlers['textDocument/symbol'] = function(_, _, result, _, bufn)
        require('lsputil.symbols').workspace_handler(nil, result, { bufnr = bufn }, nil)
    end
end

-- icon
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    -- This sets the spacing and the prefix, obviously.
    virtual_text = {
      spacing = 4,
      prefix = ''
    }
  }
)

----------------
--- LSP SAGA ---
----------------
local saga = require 'lspsaga'

-- other packer lspsaga
-- saga.init_lsp_saga {
--   error_sign = '',
--   warn_sign = '',
--   hint_sign = '',
--   infor_sign = '',
--   border_style = "round",
-- }
--
local lspsaga = require 'lspsaga'
lspsaga.setup { -- defaults ...
  debug = false,
  use_saga_diagnostic_sign = true,
  -- diagnostic sign
  error_sign = "",
  warn_sign = "",
  hint_sign = "",
  infor_sign = "",
  diagnostic_header_icon = "   ",
  -- code action title icon
  code_action_icon = " ",
  code_action_prompt = {
    enable = true,
    sign = true,
    sign_priority = 40,
    virtual_text = true,
  },
  finder_definition_icon = "  ",
  finder_reference_icon = "  ",
  max_preview_lines = 10,
  finder_action_keys = {
    open = "o",
    vsplit = "s",
    split = "i",
    quit = "q",
    scroll_down = "<C-f>",
    scroll_up = "<C-b>",
  },
  code_action_keys = {
    quit = "q",
    exec = "<CR>",
  },
  rename_action_keys = {
    quit = "<C-c>",
    exec = "<CR>",
  },
  definition_preview_icon = "  ",
  border_style = "single",
  rename_prompt_prefix = "➤",
  server_filetype_map = {},
  diagnostic_prefix_format = "%d. ",
}

-- Add the below lines to `on_attach`
local on_attach = function(client, bufnr)
  if client.resolved_capabilities.document_formatting then
    vim.api.nvim_command [[augroup Format]]
    vim.api.nvim_command [[autocmd! * <buffer>]]
    vim.api.nvim_command [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()]]
    vim.api.nvim_command [[augroup END]]
  end

  require'completion'.on_attach(client, bufnr)
end


------------------
--  TREESITTER  --
------------------
-- require'nvim-treesitter.configs'.setup {
--   highlight = {
--     enable = true,
--     disable = {},
--   },
--   indent = {
--     enable = false,
--     disable = {},
--   },
--   ensure_installed = {
--     "tsx",
--     "php",
--     "json",
--     "html",
--     "css",
--     "python",
--     "vue",
--     "html",
--     "scss"
--   },
-- }
-- local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
-- parser_config.tsx.used_by = { "javascript", "typescript.tsx" }


-----------------------
--  COMPLETION NVIM  --
-----------------------
-- local on_attach = function(client, bufnr)
--   require'completion'.on_attach(client, bufnr)
-- end

----------------
--  LUA LINE  --
----------------
local status, lualine = pcall(require, "lualine")
if (not status) then return end
lualine.setup {
  options = {
    icons_enabled = true,
    theme = 'solarized_dark',
    section_separators = {'', ''},
    component_separators = {'', ''},
    disabled_filetypes = {}
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch'},
    lualine_c = {'filename'},
    lualine_x = {
      { 'diagnostics', sources = {"nvim_diagnostic"}, symbols = {error = ' ', warn = ' ', info = ' ', hint = ' '} },
      'encoding',
      'filetype'
    },
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {'fugitive'}
}


require('vim.lsp.protocol').CompletionItemKind = {
    '', -- Text
    '', -- Method
    '', -- Function
    '', -- Constructor
    '', -- Field
    '', -- Variable
    '', -- Class
    'ﰮ', -- Interface
    '', -- Module
    '', -- Property
    '', -- Unit
    '', -- Value
    '', -- Enum
    '', -- Keyword
    '﬌', -- Snippet
    '', -- Color
    '', -- File
    '', -- Reference
    '', -- Folder
    '', -- EnumMember
    '', -- Constant
    '', -- Struct
    '', -- Event
    'ﬦ', -- Operator
    '' -- TypeParameter
    }
------------
--  KITE  --
------------
-- vim.g['kite_supported_languages']=['*']
--vim.g['kite_auto_complete']=0 -- not autocomplete at writing
-- vim.g['kite_tab_complete']=1


-----------------
--  GUTENTAGS  --
-----------------
vim.g['gutentags_ctags_auto_set_tags']=1
vim.g['gutentags_enabled']=1

-- if file_exists('ctags') then
--   vim.g['gutentags_dont_load']=1
-- end
-- if (not vim.g['ctags']) then
    vim.g['gutentags_dont_load']=1
-- end


----------------
--  NERDTREE  --
----------------
vim.g['NERDTreeQuitOnOpen']=1
-- vim.g['NERDTreeIgnore'] = ['^node_modules$']
-- vim.g['NERDTreeIgnore'] = [['tags']]
vim.g['NERDTreeShowHidden']=1
vim.g['NERDTreeAutoDeleteBuffer']=1
vim.g['NERDTreeMinimalUI']=1
vim.g['NERDTreeDirArrows']=1

-----------------
--  GITGUTTER  --
-----------------
vim.g['gitgutter_sign_modified_removed']='+'
vim.g['gitgutter_terminal_reports_focus']=0


----------------
--  Gitsigns  --
----------------
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}

-----------------
--  MULTITERM  --
-----------------
-- Default options, do not put this in your configuration file
vim.g['multiterm_opts']={
            height = 'float2nr(&lines * 0.8)',
            width = 'float2nr(&columns * 0.8)',
            row = '(&lines - height) / 2',
            col = '(&columns - width) / 2',
            border_hl = 'Comment',
            border_chars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
            show_term_tag = 1,
            term_hl = 'Normal'
            }
-- Your configuration should start here
if (not vim.g['multiterm_opts']) then
    vim.g['multiterm_opts'] = {}
end
-- This option has a string value instead of number because it is uesd for eval()
vim.g['multiterm_opts']['height'] = '30'

-------------------
--  WEBDEBICONS  --
-------------------
vim.g['airline_powerline_fonts']=1
-- vim.opt.guifont="Droid Sans Mono for Poweline Plus Nerd File Types 12"
--

---------------------------
--  Enable Comment.nvim  --
---------------------------
--require('Comment').setup()

--------------------------
--  lsp_signature.nvim  --
--------------------------
cfg = {
  debug = false, -- set to true to enable debug logging
  log_path = vim.fn.stdpath("cache") .. "/lsp_signature.log", -- log dir when debug is on
  -- default is  ~/.cache/nvim/lsp_signature.log
  verbose = false, -- show debug line number

  bind = true, -- This is mandatory, otherwise border config won't get registered.
               -- If you want to hook lspsaga or other signature handler, pls set to false
  doc_lines = 10, -- will show two lines of comment/doc(if there are more than two lines in doc, will be truncated);
                 -- set to 0 if you DO NOT want any API comments be shown
                 -- This setting only take effect in insert mode, it does not affect signature help in normal
                 -- mode, 10 by default

  floating_window = true, -- show hint in a floating window, set to false for virtual text only mode

  floating_window_above_cur_line = true, -- try to place the floating above the current line when possible Note:
  -- will set to true when fully tested, set to false will use whichever side has more space
  -- this setting will be helpful if you do not want the PUM and floating win overlap

  floating_window_off_x = 1, -- adjust float windows x position.
  floating_window_off_y = 1, -- adjust float windows y position.


  fix_pos = false,  -- set to true, the floating window will not auto-close until finish all parameters
  hint_enable = true, -- virtual hint enable
  hint_prefix = "🐼 ",  -- Panda for parameter
  hint_scheme = "String",
  hi_parameter = "LspSignatureActiveParameter", -- how your parameter will be highlight
  max_height = 12, -- max height of signature floating_window, if content is more than max_height, you can scroll down
                   -- to view the hiding contents
  max_width = 80, -- max_width of signature floating_window, line will be wrapped if exceed max_width
  handler_opts = {
    border = "rounded"   -- double, rounded, single, shadow, none
  },

  always_trigger = false, -- sometime show signature on new line or in middle of parameter can be confusing, set it to false for #58

  auto_close_after = nil, -- autoclose signature float win after x sec, disabled if nil.
  extra_trigger_chars = {}, -- Array of extra characters that will trigger signature completion, e.g., {"(", ","}
  zindex = 200, -- by default it will be on top of all floating windows, set to <= 50 send it to bottom

  padding = '', -- character to pad on left and right of signature can be ' ', or '|'  etc

  transparency = nil, -- disabled by default, allow floating win transparent value 1~100
  shadow_blend = 36, -- if you using shadow as border use this set the opacity
  shadow_guibg = 'Black', -- if you using shadow as border use this set the color e.g. 'Green' or '#121315'
  timer_interval = 200, -- default timer check interval set to lower value if you want to reduce latency
  toggle_key = nil -- toggle signature on and off in insert mode,  e.g. toggle_key = '<M-x>'
}  -- add you config here
-- require "lsp_signature".setup(cfg)
-------------
--  EMMET  --
-------------
vim.g['user_emmet_mode']='a'
vim.g['user_emmet_install_global']=0
--autocmd FileType html,css,blade,php,vue EmmetInstall
vim.api.nvim_command("autocmd FileType * EmmetInstall")
--vim.api.nvim_command("autocmd FileType html,css,blade,php,vue EmmetInstall")
-- vim.api.nvim_command("autocmd FileType javascript.jsx setlocal filetype=jsx")

vim.g['user_emmet_leader_key']=',' --" <C-y>
-- let g:user_emmet_leader_key='<C-Z>'

------------------
--  NVIM COMPE  --
------------------
require'cmp'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    calc = true;
    spell = false;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = true;
    -- tabnine = true;
  };
}

------------------------
--  THEME PaperColor  --
------------------------
vim.g['PaperColor_Theme_Options'] = {
     theme = {
       default = {
         transparent_background = 0
       }
     }
   }


--------------
--  BARBAR  --
--------------
-- vim.g.bufferline = {
--     -- Enable/disable animations
--     animation = true,
--     -- Enable/disable auto-hiding the tab bar when there is a single buffer
--     auto_hide = false,
--     -- Enable/disable current/total tabpages indicator (top right corner)
--     tabpages = true,
--     -- Enable/disable close button
--     closable = true,

--     -- Enables/disable clickable tabs
--     --  - left-click: go to buffer
--     --  - middle-click: delete buffer
--     clickable = true,
--     -- Excludes buffers from the tabline
--     exclude_ft = {'javascript'},
--     exclude_name = {'package.json'},

--     -- Enable/disable icons
--     -- if set to 'numbers', will show buffer index in the tabline
--     -- if set to 'both', will show buffer index and icons in the tabline
--     icons = true,

--     -- If set, the icon color will follow its corresponding buffer
--     -- highlight group. By default, the Buffer*Icon group is linked to the
--     -- Buffer* group (see Highlighting below). Otherwise, it will take its
--     -- default value as defined by devicons.
--     icon_custom_colors = false,

--     -- Configure icons on the bufferline.
--     icon_separator_active = '▎',
--     icon_separator_inactive = '▎',
--     icon_close_tab = '',
--     icon_close_tab_modified = '●',
--     icon_pinned = '車',

--     -- If true, new buffers will be inserted at the start/end of the list.
--     -- Default is to insert after current buffer.
--     insert_at_end = false,
--     insert_at_start = false,

--     -- Sets the maximum padding width with which to surround each tab
--     maximum_padding = 1,

--     -- Sets the maximum buffer name length.
--     maximum_length = 30,

--     -- If set, the letters for each buffer in buffer-pick mode will be
--     -- assigned based on their name. Otherwise or in case all letters are
--     -- already assigned, the behavior is to assign letters in order of
--     -- usability (see order below)
--     semantic_letters = true,

--     -- New buffer letters are assigned in this order. This order is
--     -- optimal for the qwerty keyboard layout but might need adjustement
--     -- for other layouts.
--     letters = 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP',

--     -- Sets the name of unnamed buffers. By default format is "[Buffer X]"
--     -- where X is the buffer number. But only a static string is accepted here.
--     no_name_title = nil,
-- }
-- -- vim.api.nvim_exec([[
-- --     let bufferline = get(g:, 'bufferline', {})
-- --     let bufferline.animation = v:true
-- --     let bufferline.auto_hide = v:true
-- --     let bufferline.icons = 'both'
-- -- ]], false)

-----------------
--  TELESCOPE  --
-----------------
local telescope = require "telescope"

telescope.setup {
    find_files = {
        hidden = true
    },
    -- defaults = {
    --   mappings = {
    --     i = {
    --       ['<C-u>'] = false,
    --       ['<C-d>'] = false,
    --     },
    --   },
    -- },
}
-- Enable telescope fzf native
require('telescope').load_extension 'fzf'

----------------------
--  nvim-lightbulb  --
----------------------
vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]
require'nvim-lightbulb'.update_lightbulb {
    -- LSP client names to ignore
    -- Example: {"sumneko_lua", "null-ls"}
    ignore = {},
    sign = {
        enabled = true,
        -- Priority of the gutter sign
        priority = 10,
    },
    float = {
        enabled = false,
        -- Text to show in the popup float
        text = "💡",
        -- Available keys for window options:
        -- - height     of floating window
        -- - width      of floating window
        -- - wrap_at    character to wrap at for computing height
        -- - max_width  maximal width of floating window
        -- - max_height maximal height of floating window
        -- - pad_left   number of columns to pad contents at left
        -- - pad_right  number of columns to pad contents at right
        -- - pad_top    number of lines to pad contents at top
        -- - pad_bottom number of lines to pad contents at bottom
        -- - offset_x   x-axis offset of the floating window
        -- - offset_y   y-axis offset of the floating window
        -- - anchor     corner of float to place at the cursor (NW, NE, SW, SE)
        -- - winblend   transparency of the window (0-100)
        win_opts = {},
    },
    virtual_text = {
        enabled = false,
        -- Text to show at virtual text
        text = "💡",
        -- highlight mode to use for virtual text (replace, combine, blend), see :help nvim_buf_set_extmark() for reference
        hl_mode = "replace",
    },
    status_text = {
        enabled = false,
        -- Text to provide when code actions are available
        text = "💡",
        -- Text to provide when no actions are available
        text_unavailable = ""
    }
}

--------------------
--  lspkind-nvim  --
--------------------
require('lspkind').init({
    -- enables text annotations
    --
    -- default: true
    with_text = true,

    -- default symbol map
    -- can be either 'default' (requires nerd-fonts font) or
    -- 'codicons' for codicon preset (requires vscode-codicons font)
    --
    -- default: 'default'
    preset = 'codicons',

    -- override preset symbols
    --
    -- default: {}
    symbol_map = {
      Text = "",
      Method = "",
      Function = "",
      Constructor = "",
      Field = "ﰠ",
      Variable = "",
      Class = "ﴯ",
      Interface = "",
      Module = "",
      Property = "ﰠ",
      Unit = "塞",
      Value = "",
      Enum = "",
      Keyword = "",
      Snippet = "",
      Color = "",
      File = "",
      Reference = "",
      Folder = "",
      EnumMember = "",
      Constant = "",
      Struct = "פּ",
      Event = "",
      Operator = "",
      TypeParameter = ""
    },
})



------------------------
--  SirVer/ultisnips  --
------------------------
vim.g['UltiSnipsSnippetsDir']='~/.vim/UltiSnips'
--Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
vim.g['UltiSnipsExpandTrigger']='<tab>'
vim.g['UltiSnipsJumpForwardTrigger']='<tab>'
vim.g['UltiSnipsJumpBackwardTrigger']='<s-tab>'
vim.g['UltiSnipsEditSplit']='horizontal'
