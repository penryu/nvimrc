--
-- core editor functionality
--

local u = require('util')

local keyset = vim.keymap.set

return {
  {
    'nvim-neorg/neorg',
    dependencies = 'nvim-lua/plenary.nvim',
    build = ':Neorg sync-parsers',
    config = function()
      require('neorg').setup {
        load = {
          ['core.defaults'] = {},
          ['core.concealer'] = {},
          ['core.dirman'] = {
            config = {
              workspaces = {
                notes = '~/Dropbox/Notes',
              },
            },
          },
        },
      }
    end,
    cmd = 'Neorg',
    ft = 'norg',
  },
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = function()
      local f_width = function() return vim.o.columns end
      local f_height = function() return math.floor(vim.o.lines * 3 / 5) end
      local f_row = function()
        -- bottom of term above main status
        -- top term border + bottom term border + status line => 3
        return vim.o.lines - f_height() - vim.o.cmdheight - 3
      end

      require('toggleterm').setup {
        -- directions: float / horizontal / tab / vertical
        direction = 'float',
        float_opts = {
          -- borders: single / double / shadow / curved
          border = 'single',
          height = f_height,
          width = f_width,
          row = f_row,
        },
        open_mapping = [[<c-\>]],
        shade_terminals = true,
        size = function(term)
          if term.direction == 'horizontal' then
            return vim.o.lines * 0.42
          elseif term.direction == 'vertical' then
            return vim.o.columns
          end
        end,
      }
      u.tmap('<esc>', [[<c-\><c-n>:let b:insertMode = 'no'<cr>]])
      u.tmap('<c-h>', '<c-\\><c-n>:wincmd h<cr>')
      u.tmap('<c-j>', '<c-\\><c-n>:wincmd j<cr>')
      u.tmap('<c-k>', '<c-\\><c-n>:wincmd k<cr>')
      u.tmap('<c-l>', '<c-\\><c-n>:wincmd l<cr>')

      -- Go straight to insert mode; toggleterm handles this separately
      u.create_autocmd('TermOpen', { pattern = '*', command = 'startinsert' })
      -- Creates a toggleterm in a dedicated tab
      u.create_command('TabTerm', 'ToggleTerm direction=tab', {})
    end,
    keys = '<c-\\>',
    cmd = { 'TabTerm', 'ToggleTerm' },
  },
  {
    'atweiden/vim-fennel',
    ft = { 'fennel' },
  },
  {
    'psf/black',
    branch = 'stable',
    ft = 'python',
  },
  {
    'chentoast/marks.nvim',
    opts = {},
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
    'folke/noice.nvim',
    dependencies = {
      -- make sure to add proper `module="..."` entries
      -- if you lazy-load any plugin below
      'MunifTanjim/nui.nvim',
      -- `nvim-notify` is only needed, if you want to use the notification view.
      -- If not available, we use `mini` as the fallback
      'rcarriga/nvim-notify',
    },
    config = function()
      require('noice').setup {
        health = {
          checker = false,
        },
        lsp = {
          override = {
            ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
            ['vim.lsp.util.stylize_markdown'] = true,
            ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
          },
        },
        messages = {
          view = 'mini',
          -- view_error = 'mini',
          -- view_warn = 'mini',
        },
        presets = {
          bottom_search = true,
          command_palette = false,
          long_message_to_split = true,
          inc_rename = false,
          lsp_doc_border = true,
        },
        views = {
          split = {
            enter = true,
          },
        },
      }
      require('telescope').load_extension('noice')
    end,
    event = 'VeryLazy',
  },
  {
    'folke/todo-comments.nvim',
    dependencies = 'nvim-lua/plenary.nvim',
    config = function()
      local todo = require('todo-comments')
      todo.setup {}
      u.nmap(']t', function() todo.jump_next() end, { desc = 'Next TODO' })
      u.nmap('[t', function() todo.jump_prev() end, { desc = 'Prev TODO' })
    end,
  },
  {
    'folke/twilight.nvim',
    cmd = { 'Twilight', 'TwilightEnable', 'TwilightEnable' },
  },
  {
    'folke/which-key.nvim',
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {},
    event = 'VeryLazy',
  },
  {
    'iamcco/markdown-preview.nvim',
    init = function()
      vim.g.mkdp_echo_preview_url = true
      vim.g.mkdp_refresh_slow = true
      vim.g.mkdp_theme = 'light'
    end,
    ft = 'markdown',
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
          vim.cmd('split')
          -- spawn repl and set the context to our buffer
          require('neorepl').new {
            lang = 'lua',
            buffer = buf,
            window = win,
          }
          -- resize repl window and make it fixed height
          vim.cmd('resize 11 | setl winfixheight')
        end,
        desc = 'Open a Lua or VimScript REPL',
      },
    },
  },
  {
    'jakewvincent/mkdnflow.nvim',
    dependencies = {
      'ellisonleao/glow.nvim',
      'nvim-lua/plenary.nvim',
    },
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
      vim.cmd([[
            let g:buffergator_autodismiss_on_select = 0
            let g:buffergator_autoupdate = 1
            let g:buffergator_display_regime = 'parentdir'
            let g:buffergator_hsplit_size = 7
            let g:buffergator_show_full_directory_path = 0
            let g:buffergator_viewport_split_policy = 'B'
            let g:buffergator_vsplit_size = 42
         ]])
    end,
    keys = { '<leader>b', desc = 'Buffergator' },
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
      'tpope/vim-dadbod',
    },
    cmd = 'DBUI',
  },
  {
    'lambdalisue/suda.vim',
    init = function() vim.g.suda_smart_edit = true end,
  },
  {
    'machakann/vim-sandwich',
    keys = {
      { 'sa', desc = 'Add surroundings (sandwich)' },
      { 'sd', desc = 'Delete surroundings provided (sandwich)' },
      { 'sdb', desc = 'Add surroundings detected (sandwich)' },
      { 'sr', desc = 'Add surroundings provided (sandwich)' },
      { 'srb', desc = 'Add surroundings detected (sandwich)' },
    },
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
        { type = 'sessions', header = { '   Sessions' } },
        { type = 'files', header = { '   MRU' } },
        {
          type = 'dir',
          header = { '   MRU ' .. vim.fn['getcwd']() },
        },
        { type = 'commands', header = { '   Commands' } },
        { type = 'bookmarks', header = { '   Bookmarks' } },
      }
      vim.g.startify_custom_header = false
      vim.g.startify_session_autoload = false
      vim.g.startify_session_persistence = true
      vim.g.startify_skiplist = { 'Library/CloudStorage' }
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    config = function()
      local noice = require('noice')

      local encoding = function()
        local ret, _ = (vim.bo.fenc or vim.go.enc):gsub('^utf%-8$', '')
        return ret
      end

      local sections = {
        lualine_a = { 'mode' },
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
          {
            noice.api.status.command.get,
            cond = noice.api.status.command.has,
            color = { fg = '#ff9e64' },
          },
          {
            noice.api.status.mode.get,
            cond = noice.api.status.mode.has,
            color = { fg = '#ff9e64' },
          },
          {
            noice.api.status.search.get,
            cond = noice.api.status.search.has,
            color = { fg = '#ff9e64' },
          },
          encoding, -- function only displays encoding if not utf-8
          {
            'fileformat',
            symbols = { dos = 'dos', mac = 'mac', unix = '' },
          },
          'filetype',
        },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      }
      require('lualine').setup {
        extensions = {
          'fugitive',
          'fzf',
          'lazy',
          'man',
          'neo-tree',
          'toggleterm',
        },
        options = {
          globalstatus = false,
          icons_enabled = true,
          -- theme = 'codedark',
          theme = 'everforest',
          -- theme = 'gruvbox',
          -- theme = 'gruvbox_light',
          -- theme = 'gruvbox-material',
          -- theme = 'iceberg',
          -- theme = 'nord',
          -- theme = 'wombat',
        },
        sections = sections,
        inactive_sections = sections,
        tabline = {
          lualine_a = { 'buffers' },
          lualine_b = {},
          lualine_c = {},
          lualine_x = {
            {
              noice.api.status.message.get,
              cond = noice.api.status.message.has,
              color = { fg = '#eeeeee' },
            },
          },
          lualine_y = {},
          lualine_z = { 'tabs' },
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
        window = { width = 32 },
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
      {
        '\\',
        ':Neotree toggle<cr>',
        'noremap',
        desc = 'Toggle Neotree',
      },
      { '<bar>', ':Neotree git_status<cr>', 'noremap', desc = 'Toggle git' },
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
        results_title = false,
        sorting_strategy = 'ascending',
        layout_strategy = 'center',
        layout_config = {
          preview_cutoff = 1, -- Preview should always show (unless previewer = false)
          width = function(_, max_columns, _) return math.min(max_columns, 132) end,
          height = function(_, _, max_lines) return math.min(max_lines, 60) end,
        },
      },
    },
    cmd = 'Telescope',
    keys = {
      {
        '<leader>fa',
        function() require('telescope.builtin').autocommands() end,
        desc = 'Telescope autocommands',
      },
      {
        '<leader>fb',
        function() require('telescope.builtin').buffers() end,
        desc = 'Telescope buffers',
      },
      {
        '<leader>fc',
        function() require('telescope.builtin').commands() end,
        desc = 'Telescope commands',
      },
      {
        '<leader>fd',
        function() require('telescope.builtin').fd() end,
        desc = 'Telescope fd',
      },
      {
        '<leader>ff',
        function() require('telescope.builtin').find_files() end,
        desc = 'Telescope find_files',
      },
      {
        '<leader>fg',
        function() require('telescope.builtin').live_grep() end,
        desc = 'Telescope grep',
      },
      {
        '<leader>fh',
        function() require('telescope.builtin').help_tags() end,
        desc = 'Telescope tags',
      },
      {
        '<leader>fm',
        function() require('telescope.builtin').marks() end,
        desc = 'Telescope marks',
      },
      {
        '<leader>fo',
        function() require('telescope.builtin').vim_options() end,
        desc = 'Telescope vim options',
      },
      {
        '<leader>fs',
        function()
          local actions = require('telescope.actions')
          local action_state = require('telescope.actions.state')
          local sessions_dir = vim.fn.stdpath('data') .. '/session/'

          local function run_selection(prompt_bufnr, _map)
            actions.select_default:replace(function()
              actions.close(prompt_bufnr)
              local selection = action_state.get_selected_entry()
              vim.cmd(':source ' .. sessions_dir .. selection[1])
            end)
            return true
          end

          require('telescope.builtin').find_files {
            attach_mappings = run_selection,
            cwd = sessions_dir,
          }
        end,
        desc = 'Telescope sessions',
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
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      local harpoon = require('harpoon')
      harpoon:setup()

      keyset('n', '<leader>ha', function() harpoon:list():append() end)
      keyset(
        'n',
        '<leader>he',
        function() harpoon.ui:toggle_quick_menu(harpoon:list()) end
      )

      -- recall harpooned buffers
      keyset('n', '<leader>j', function() harpoon:list():select(1) end)
      keyset('n', '<leader>k', function() harpoon:list():select(2) end)
      keyset('n', '<leader>l', function() harpoon:list():select(3) end)
      keyset('n', '<leader>;', function() harpoon:list():select(4) end)

      -- toggle next/prev within harpoon
      keyset('n', '<leader>hp', function() harpoon:list():prev() end)
      keyset('n', '<leader>hn', function() harpoon:list():next() end)
    end,
    keys = {
      { '<leader>ha', desc = 'Harpoon append' },
      { '<leader>he', desc = 'Harpoon edit' },
      { '<leader>hp', desc = 'Harpoon prev' },
      { '<leader>hn', desc = 'Harpoon next' },
      { '<leader>j', desc = 'Harpoon 1' },
      { '<leader>k', desc = 'Harpoon 2' },
      { '<leader>l', desc = 'Harpoon 3' },
      { '<leader>;', desc = 'Harpoon 4' },
    },
  },
  {
    'jiaoshijie/undotree',
    dependencies = 'nvim-lua/plenary.nvim',
    config = true,
    keys = { -- load the plugin only when using it's keybinding:
      {
        '<leader>u',
        "<cmd>lua require('undotree').toggle()<cr>",
        desc = 'Undotree',
      },
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
    'fladson/vim-kitty',
    ft = 'kitty',
  },
  {
    -- enhances netrw
    'tpope/vim-vinegar',
    event = 'BufNew netrw',
  },
  -- highlight trailing whitespace, inconsistent indents, and long lines
  { 'tssm/nvim-snitch' },
  {
    'Yggdroot/indentLine',
    init = function()
      -- workaround https://github.com/Yggdroot/indentLine/issues/109
      vim.g.indentLine_faster = true
      vim.g.indentLine_setConceal = false

      vim.g.indentLine_char_list = { '┆', '┊', '¦' }
      vim.g.indentLine_fileTypeExclude = { 'help', 'man', 'toggleterm' }
    end,
  },
}
