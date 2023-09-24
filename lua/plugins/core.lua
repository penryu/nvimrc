--
-- core editor functionality
--

local u = require 'util'

return {
   {
      'akinsho/toggleterm.nvim',
      version = '*',
      config = function()
         require('toggleterm').setup {
            -- directions: float / horizontal / tab / vertical
            direction = 'float',
            float_opts = {
               -- borders: single / double / shadow / curved
               border = 'single',
            },
            open_mapping = [[<c-\>]],
            shade_terminals = true,
            size = function(term)
               if term.direction == 'horizontal' then
                  return vim.o.lines * 0.42
               elseif term.direction == 'vertical' then
                  return vim.o.columns * 0.42
               end
            end,
         }
         u.tmap('<esc>', [[<c-\><c-n>:let b:insertMode = 'no'<cr>]])
         u.tmap('<c-h>', '<c-\\><c-n>:wincmd h<cr>')
         u.tmap('<c-j>', '<c-\\><c-n>:wincmd j<cr>')
         u.tmap('<c-k>', '<c-\\><c-n>:wincmd k<cr>')
         u.tmap('<c-l>', '<c-\\><c-n>:wincmd l<cr>')

         u.create_command('TabTerm', 'ToggleTerm direction=tab', {})
      end,
      keys = '<c-\\>',
      cmd = 'TabTerm',
   },
   {
      'dense-analysis/ale',
      config = function() vim.cmd 'ALEEnable' end,
      cmd = 'ALEEnable',
      ft = { 'perl' },
   },
   {
      'fidian/hexmode',
      init = function() vim.g.hexmode_patterns = '*.bin,*.exe,*.dat,*.wasm' end,
      event = {
         'BufNew *.bin',
         'BufNew *.exe',
         'BufNew *.dat',
         'BufNew *.wasm',
      },
   },
   {
      'folke/todo-comments.nvim',
      dependencies = 'nvim-lua/plenary.nvim',
      config = function()
         local todo = require 'todo-comments'
         todo.setup {}
         u.nmap(']t', function() todo.jump_next() end, { desc = 'Next TODO' })
         u.nmap('[t', function() todo.jump_prev() end, { desc = 'Prev TODO' })
      end,
   },
   { 'folke/twilight.nvim', cmd = { 'Twilight', 'TwilightEnable' } },
   {
      'iamcco/markdown-preview.nvim',
      init = function()
         vim.g.mkdp_echo_preview_url = true
         vim.g.mkdp_refresh_slow = true
         vim.g.mkdp_theme = 'light'
      end,
   },
   {
      'ii14/neorepl.nvim',
      cmd = 'Repl',
      keys = {
         {
            'g:',
            function()
               -- get current buffer and window
               local buf = vim.api.nvim_get_current_buf()
               local win = vim.api.nvim_get_current_win()
               -- create a new split for the repl
               vim.cmd 'split'
               -- spawn repl and set the context to our buffer
               require('neorepl').new {
                  lang = 'lua',
                  buffer = buf,
                  window = win,
               }
               -- resize repl window and make it fixed height
               vim.cmd 'resize 11 | setl winfixheight'
            end,
            desc = 'Open a Lua or VimScript REPL',
         },
      },
   },
   {
      'jakewvincent/mkdnflow.nvim',
      dependencies = 'ellisonleao/glow.nvim',
      config = function()
         require('mkdnflow').setup {
            perspective = {
               priority = 'root',
               root_tell = 'index.md',
            },
         }
         u.create_command('Notes', 'Files ~/Dropbox/Notes', {})
      end,
      cmd = 'Notes',
      ft = 'markdown',
   },
   {
      'jeetsukumaran/vim-buffergator',
      init = function()
         vim.cmd [[
            let g:buffergator_autodismiss_on_select = 0
            let g:buffergator_autoupdate = 1
            let g:buffergator_display_regime = 'parentdir'
            let g:buffergator_hsplit_size = 7
            let g:buffergator_show_full_directory_path = 0
            let g:buffergator_viewport_split_policy = 'B'
            let g:buffergator_vsplit_size = 42
         ]]
      end,
      keys = { '<leader>b' },
   },
   {
      'junegunn/fzf.vim',
      dependencies = 'junegunn/fzf',
      cmd = {
         'BCommits',
         'BLines',
         'Buffers',
         'Colors',
         'Commands',
         'Commits',
         'Files',
         'Filetypes',
         'FZF',
         'GFiles',
         'GFiles',
         'History',
         'Lines',
         'Maps',
         'Marks',
         'Rg',
         'Windows',
      },
   },
   { 'kovisoft/paredit', ft = { 'clojure', 'lisp' } },
   {
      'kristijanhusak/vim-dadbod-ui',
      dependencies = {
         'kristijanhusak/vim-dadbod-completion',
         'neoclide/coc.nvim',
         'tpope/vim-dadbod',
      },
      cmd = 'DBUI',
   },
   {
      'lambdalisue/suda.vim',
      init = function() vim.g.suda_smart_edit = true end,
   },
   {
      'liuchengxu/vista.vim',
      cmd = 'Vista',
      init = function()
         vim.g.vista_default_executive = 'coc'
         u.nmap('<Leader>vv', ':Vista!!<cr>')
      end,
   },
   {
      'machakann/vim-sandwich',
      keys = { 'sa', 'sd', 'sdb', 'sr', 'srb' },
   },
   {
      'mhinz/vim-startify', -- a functional "splash page"
      init = function()
         vim.g.startify_bookmarks = {
            -- { ['.'] = '.' },
            { ['.'] = '.' },
            { v = '~/.config/nvim' },
            { r = '~/code/rcfiles' },
            { s = '~/.ssh' },
            { n = '~/Dropbox/Notes/index.md' },
         }
         vim.g.startify_lists = {
            { type = 'bookmarks', header = { '   Bookmarks' } },
            { type = 'files', header = { '   MRU' } },
            {
               type = 'dir',
               header = { '   MRU ' .. vim.fn['getcwd']() },
            },
            { type = 'sessions', header = { '   Sessions' } },
            { type = 'commands', header = { '   Commands' } },
         }
         vim.g.startify_custom_header = false
         vim.g.startify_session_autoload = true
         vim.g.startify_skiplist = { 'Library/CloudStorage' }
      end,
   },
   {
      -- shows trailing whitespace
      'ntpeters/vim-better-whitespace',
      config = function()
         -- can probably be removed when this is merged:
         -- https://github.com/ntpeters/vim-better-whitespace/pull/161
         u.create_autocmd('TermOpen', {
            pattern = '*',
            callback = function() vim.cmd 'DisableWhitespace' end,
         })
      end,
      cmd = {
         'DisableWhitespace',
         'EnableWhitespace',
         'StripWhitespace',
         'ToggleWhitespace',
      },
      lazy = false,
   },
   {
      'nvim-lualine/lualine.nvim',
      config = function()
         require('lualine').setup {
            extensions = {
               'fugitive',
               'fzf',
               'lazy',
               'man',
               'mundo',
               'neo-tree',
               'quickfix',
               'toggleterm',
               'trouble',
            },
            options = {
               globalstatus = false,
               icons_enabled = false,
               -- theme = 'everforest',
               -- theme = 'gruvbox',
               -- theme = 'iceberg',
               -- theme = 'nord',
               theme = 'wombat',
            },
            sections = {
               lualine_b = {
                  'branch',
                  'diff',
                  {
                     'diagnostics',
                     symbols = {
                        error = 'E:',
                        warn = 'W:',
                        info = 'I:',
                        hint = 'H:',
                     },
                  },
               },
               lualine_c = { { 'filename', path = 1 } },
               lualine_x = {
                  'encoding',
                  {
                     'fileformat',
                     symbols = { dos = 'dos', mac = 'mac', unix = '' },
                  },
                  'filetype',
               },
            },
            tabline = {
               lualine_a = { 'buffers' },
               lualine_b = {},
               lualine_c = {},
               lualine_x = {},
               lualine_y = { 'tabs' },
               lualine_z = { 'branch' },
            },
         }
      end,
      priority = 1000,
   },
   {
      'nvim-neo-tree/neo-tree.nvim',
      branch = 'v2.x',
      dependencies = {
         'nvim-lua/plenary.nvim',
         'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
         'MunifTanjim/nui.nvim',
         {
            -- only needed if you want to use the commands with "_with_window_picker" suffix
            's1n7ax/nvim-window-picker',
            version = 'v1.*',
            config = function()
               require('window-picker').setup {
                  autoselect_one = true,
                  include_current = false,
                  filter_rules = {
                     -- filter using buffer options
                     bo = {
                        -- if the file type is one of following, the window will be ignored
                        filetype = {
                           'neo-tree',
                           'neo-tree-popup',
                           'notify',
                           'quickfix',
                        },
                        -- if the buffer type is one of following, the window will be ignored
                        buftype = { 'terminal' },
                     },
                  },
                  other_win_hl_color = '#e35e4f',
               }
            end,
         },
      },
      init = function()
         -- Unless you are still migrating, remove the deprecated commands from v1.x
         vim.g.neo_tree_remove_legacy_commands = true
         -- If you want icons for diagnostic errors, you'll need to define them somewhere:
         vim.fn.sign_define(
            'DiagnosticSignError',
            { text = ' ', texthl = 'DiagnosticSignError' }
         )
         vim.fn.sign_define(
            'DiagnosticSignWarn',
            { text = ' ', texthl = 'DiagnosticSignWarn' }
         )
         vim.fn.sign_define(
            'DiagnosticSignInfo',
            { text = ' ', texthl = 'DiagnosticSignInfo' }
         )
         vim.fn.sign_define(
            'DiagnosticSignHint',
            { text = '', texthl = 'DiagnosticSignHint' }
         )
      end,
      config = function()
         require('neo-tree').setup {
            close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
            enable_git_status = true,
            enable_diagnostics = true,
            window = { width = 36 },
            filesystem = {
               filtered_items = {
                  hide_dotfiles = true,
                  hide_gitignored = false,
                  hide_by_name = { 'node_modules' },
                  hide_by_pattern = { -- uses glob style patterns
                     -- "*.meta"
                  },
                  never_show = { -- remains hidden even if visible is toggled to true
                     '.DS_Store',
                     'thumbs.db',
                  },
               },
               -- This will find and focus the file in the active buffer every
               -- time the current file is changed while the tree is open.
               follow_current_file = true,
               -- This will use the OS level file watchers to detect changes
               -- instead of relying on nvim autocmd events.
               use_libuv_file_watcher = true,
            },
         }
      end,
      lazy = false,
      cmd = 'Neotree',
      keys = {
         { '\\', ':Neotree toggle<cr>', 'noremap' },
         { '<bar>', ':Neotree git_status<cr>', 'noremap' },
      },
   },
   {
      'nvim-telescope/telescope.nvim',
      dependencies = {
         'iamcco/markdown-preview.nvim',
         'mzlogin/vim-markdown-toc',
         'nvim-lua/plenary.nvim',
         'nvim-telescope/telescope-symbols.nvim',
      },
      opts = {
         defaults = {
            theme = 'dropdown',
            -- results_title = false,
            sorting_strategy = 'ascending',
            layout_strategy = 'center',
            layout_config = {
               preview_cutoff = 1, -- Preview should always show (unless previewer = false)
               width = function(_, max_columns, _)
                  return math.min(max_columns, 80)
               end,
               height = function(_, _, max_lines)
                  return math.min(max_lines, 15)
               end,
            },
         },
      },
      cmd = 'Telescope',
      keys = {
         {
            '<leader>ff',
            function() require('telescope.builtin').find_files() end,
         },
         {
            '<leader>fg',
            function() require('telescope.builtin').live_grep() end,
         },
         {
            '<leader>fb',
            function() require('telescope.builtin').buffers() end,
         },
         {
            '<leader>fh',
            function() require('telescope.builtin').help_tags() end,
         },
      },
   },
   {
      'nvim-treesitter/nvim-treesitter',
      dependencies = {
         -- Additional textobjects for treesitter.
         'nvim-treesitter/nvim-treesitter-textobjects',
      },
   },
   {
      'preservim/vim-markdown',
      dependencies = 'mzlogin/vim-markdown-toc',
      init = function()
         vim.g.vim_markdown_conceal = false
         vim.g.vim_markdown_folding_disabled = 1
      end,
      ft = 'markdown',
   },
   {
      'Ostralyan/scribe.nvim',
      dependencies = 'nvim-telescope/telescope.nvim',
      config = function()
         require('scribe').setup {
            directory = '~/Dropbox/Notes/',
            file_ext = '.md',
            default_file = 'index',
         }
      end,
      ft = 'markdown',
      keys = {
         { '<leader>ss', ':ScribeOpen<cr>', 'noremap' },
         { '<leader>so', ':ScribeOpen<space>', 'noremap' },
         { '<leader>sf', ':ScribeFind<cr>', 'noremap' },
      },
   },
   { 'sheerun/vim-polyglot', enabled = false },
   {
      'sindrets/diffview.nvim',
      dependencies = 'nvim-lua/plenary.nvim',
      cmd = 'DiffviewOpen',
      keys = {
         { '<leader>dv', ':DiffviewOpen<cr>' },
         { '<leader>dV', ':DiffviewClose<cr>' },
      },
   },
   {
      'tpope/vim-commentary',
      keys = {
         { 'gc', mode = { 'n', 'o', 'x' } },
         'gcc',
         'gcu',
      },
   },
   {
      -- asynchronizes synchronous vim tasks
      'tpope/vim-dispatch',
      dependencies = 'radenling/vim-dispatch-neovim',
      cmd = { 'Dispatch', 'Focus', 'Make', 'Start' },
   },
   {
      -- source env vars from .env files
      'tpope/vim-dotenv',
      dependencies = 'tpope/vim-dispatch',
      cmd = 'Dotenv',
   },
   {
      -- automated session management
      'tpope/vim-obsession',
      cmd = 'Obsession',
   },
   {
      -- enhances netrw
      'tpope/vim-vinegar',
      event = 'BufNew netrw',
   },
   {
      -- highlights all text past margin
      'whatyouhide/vim-lengthmatters',
      cmd = {
         'LengthmattersToggle',
         'LengthmattersEnable',
         'LengthmattersEnableAll',
      },
   },
   {
      'Yggdroot/indentLine',
      init = function()
         vim.g.indentLine_char_list = { '┆', '┊', '¦' }
         vim.g.indentLine_fileTypeExclude = { 'help', 'man', 'toggleterm' }
         -- vim.g.indentLine_conceallevel = 1
         -- vim.g.indentLine_setConceal = 0
      end,
   },
}
