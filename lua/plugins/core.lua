--
-- core editor functionality
--

local u = require('util')

local keyset = vim.keymap.set

return {
  {
    'sindrets/diffview.nvim',
    dependencies = 'nvim-lua/plenary.nvim',
    cmd = 'DiffviewOpen',
    keys = {
      { '<leader>dv', ':DiffviewOpen<cr>', desc = 'DiffViewOpen (current)' },
      { '<leader>dV', ':DiffviewClose<cr>', desc = 'DiffViewClose' },
    },
  },
  {
    'junegunn/fzf.vim',
    dependencies = 'junegunn/fzf',
    -- only loaded if explicitly desired; see telescope for alternatives
    cmd = 'FZF',
  },
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = {
      'nvim-lua/plenary.nvim',
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
      { '<leader>ha', desc = 'Harpoon current file' },
      { '<leader>he', desc = 'edit Harpoon list' },
      { '<leader>hp', desc = 'goto previous Harpoon' },
      { '<leader>hn', desc = 'goto next Harpoon' },
      { '<leader>j', desc = 'goto Harpoon 1' },
      { '<leader>k', desc = 'goto Harpoon 2' },
      { '<leader>l', desc = 'goto Harpoon 3' },
      { '<leader>;', desc = 'goto Harpoon 4' },
    },
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'folke/noice.nvim',
      'rcarriga/nvim-notify',
    },
    init = function() vim.o.termguicolors = true end,
    config = function()
      local noice = require('noice')

      local encoding = function()
        local ret, _ = (vim.bo.fenc or vim.go.enc):gsub('^utf%-8$', '')
        return ret
      end

      local tabline_sections = {
        lualine_a = {
          {
            'buffers',
            mode = 4,
            show_filename_only = true,
            use_mode_colors = true,
          },
        },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {
          {
            noice.api.status.message.get,
            cond = noice.api.status.message.has,
            color = { fg = '#eeeeee' },
          },
        },
        lualine_y = {
          {
            noice.api.status.command.get,
            cond = noice.api.status.command.has,
            color = { fg = '#ff9e64' },
          },
        },
        lualine_z = { { 'tabs', mode = 0, path = 0, use_mode_colors = true } },
      }
      local sections = {
        lualine_a = { 'mode' },
        lualine_b = {
          'branch',
          'diff',
          {
            'diagnostics',
            symbols = {
              error = ' ',
              warn = ' ',
              info = ' ',
              hint = ' ',
            },
          },
        },
        lualine_c = { { 'filename', file_status = false, path = 3 } },
        lualine_x = {
          {
            noice.api.status.search.get,
            cond = noice.api.status.search.has,
            color = { fg = '#ff9e64' },
          },
        },
        lualine_y = {
          encoding, -- function only displays encoding if not utf-8
          {
            'fileformat',
            symbols = { dos = ' ', mac = ' ', unix = '' },
          },
          'filetype',
        },
        lualine_z = {
          'progress',
          'location',
        },
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
          --    
          --      
          --    
          section_separators = { left = '', right = '' },
          component_separators = { left = '', right = '' },
          -- theme = 'codedark',
          -- theme = 'everforest',
          -- theme = 'gruvbox',
          -- theme = 'gruvbox_light',
          theme = 'gruvbox-material',
          -- theme = 'iceberg',
          -- theme = 'nord',
          -- theme = 'wombat',
        },
        sections = sections,
        inactive_sections = sections,
        tabline = tabline_sections,
      }
    end,
    priority = 1000,
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
    'chentoast/marks.nvim',
    opts = {},
  },
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
      'MunifTanjim/nui.nvim',
      {
        -- only needed if you want to use the commands with "_with_window_picker" suffix
        's1n7ax/nvim-window-picker',
        version = '2.*',
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
                  'toggleterm',
                },
                -- if the buffer type is one of following, the window will be ignored
                buftype = { 'quickfix', 'terminal' },
              },
            },
            other_win_hl_color = '#e35e4f',
          }
        end,
      },
    },
    config = function()
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
      require('neo-tree').setup {
        -- Close Neo-tree if it is the last window left in the tab
        close_if_last_window = true,
        enable_git_status = true,
        enable_diagnostics = true,
        -- when opening files, do not use windows containing these filetypes or buftypes
        open_files_do_not_replace_types = { 'terminal', 'trouble', 'qf' },
        popup_border_style = 'rounded',
        sort_case_insensitive = false,
        filesystem = {
          filtered_items = {
            hide_dotfiles = true,
            hide_gitignored = true,
            hide_by_name = { 'node_modules' },
            hide_by_pattern = {
              -- uses glob style patterns
              -- "*.meta"
            },
            never_show = {
              -- remains hidden even if visible is toggled to true
              '.DS_Store',
              'thumbs.db',
            },
          },
          follow_current_file = {
            -- This will find and focus the file in the active buffer every
            -- time the current file is changed while the tree is open.
            enabled = true,
            -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
            leave_dirs_open = true,
          },
          -- This will use the OS level file watchers to detect changes
          -- instead of relying on nvim autocmd events.
          use_libuv_file_watcher = true,
        },
        buffers = {
          follow_current_file = {
            -- This will find and focus the file in the active buffer every
            -- time the current file is changed while the tree is open.
            enabled = true,
            -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
            leave_dirs_open = true,
          },
          show_unloaded = true,
        },
        window = { position = 'float', width = 40 },
      }
    end,
    -- needs to load early to override netrw
    lazy = false,
    cmd = 'Neotree',
    keys = {
      {
        '\\',
        function()
          require('neo-tree.command').execute {
            toggle = true,
            source = 'filesystem',
          }
        end,
        desc = 'Toggle neotree filesystem view',
      },
      {
        '<bar>',
        function()
          require('neo-tree.command').execute {
            toggle = true,
            source = 'git_status',
          }
        end,
        desc = 'Toggle neotree git status view',
      },
      {
        '<leader>b',
        function()
          require('neo-tree.command').execute {
            toggle = true,
            source = 'buffers',
          }
        end,
        desc = 'Toggle neotree buffers view',
      },
    },
  },
  {
    'nvim-neorg/neorg',
    enabled = false, -- ignore until I have time to dig into this
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
    'folke/noice.nvim',
    opts = {
      messages = {
        view = 'mini',
        view_error = 'notify',
        view_warn = 'notify',
      },
      presets = {
        bottom_search = true,
        command_palette = false,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = true,
      },
    },
  },
  {
    'rcarriga/nvim-notify',
    opts = {
      render = 'wrapped-compact',
      stages = 'fade',
      top_down = true,
    },
  },
  'tssm/nvim-snitch', -- highlight trailing whitespace, inconsistent indents, and long lines
  {
    'nvim-treesitter/nvim-treesitter',
    tag = 'v0.9.2', -- update if nvim-treesitter emits node type errors
    dependencies = {
      -- Additional textobjects for treesitter.
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
  },
  {
    'kovisoft/paredit',
    ft = { 'clojure', 'fennel', 'lisp' },
  },
  {
    'penryu/rp.nvim',
    opts = { bin = 'hpnc' },
    cmd = 'Rp',
    keys = {
      { '<leader>rp', '<cmd>Rp<cr>', desc = 'Launch RPN calculator' },
      {
        '<leader>ry',
        function()
          local rp = require('rp-nvim')
          for k, _ in pairs(package.loaded) do
            print(k)
          end
          rp.open()
        end,
      },
    },
  },
  {
    'lambdalisue/suda.vim',
    init = function() vim.g.suda_smart_edit = true end,
  },
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'rcarriga/nvim-notify',
      'nvim-treesitter/nvim-treesitter',
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-symbols.nvim',
    },
    config = function()
      local telescope = require('telescope')
      telescope.setup {
        defaults = {
          layout_strategy = 'vertical',
          sorting_strategy = 'ascending',
          layout_config = {
            height = function() return math.min(vim.o.lines - 10, 60) end,
            width = function() return math.min(vim.o.columns - 10, 132) end,
            preview_height = 0.6,
            prompt_position = 'top',
          },
        },
      }
      telescope.load_extension('notify')
    end,
    cmd = 'Telescope',
    keys = {
      {
        '<leader>tb',
        function() require('telescope.builtin').buffers() end,
        desc = 'Telescope buffers',
      },
      {
        '<leader>tc',
        function() require('telescope.builtin').commands() end,
        desc = 'Telescope commands',
      },
      {
        '<leader>tf',
        function() require('telescope.builtin').fd() end,
        desc = 'Telescope find (fd)',
      },
      {
        '<leader>tg',
        function() require('telescope.builtin').git_files() end,
        desc = 'Telescope find_files',
      },
      {
        '<leader>rg',
        function() require('telescope.builtin').live_grep() end,
        desc = 'Telescope ripgrep (rg)',
      },
      {
        '<leader>th',
        function() require('telescope.builtin').help_tags() end,
        desc = 'Telescope tags',
      },
      {
        '<leader>tm',
        function() require('telescope.builtin').marks() end,
        desc = 'Telescope marks',
      },
      {
        '<leader>to',
        function() require('telescope.builtin').vim_options() end,
        desc = 'Telescope vim options',
      },
    },
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
    'akinsho/toggleterm.nvim',
    version = '*',
    config = function()
      local row = 1
      local width = function()
        return math.floor(math.max(100, 0.64 * vim.o.columns))
      end
      local col = function() return vim.o.columns - width() end
      local height = function() return vim.o.lines - 4 end

      require('toggleterm').setup {
        -- directions: float / horizontal / tab / vertical
        direction = 'float',
        float_opts = {
          -- borders: single / double / shadow / curved
          border = 'single',
          height = height,
          width = width,
          col = col,
          row = row,
        },
        open_mapping = [[<c-\>]],
        shade_terminals = true,
        size = function(term)
          if term.direction == 'horizontal' then
            return vim.o.lines * 0.51
          elseif term.direction == 'vertical' then
            return math.max(math.ceil(vim.o.columns / 2), 80)
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
      -- Send toggleterm back to float
      u.create_command('QuakeTerm', 'ToggleTerm direction=float', {})
    end,
    keys = '<c-\\>',
    cmd = { 'QuakeTerm', 'TabTerm', 'ToggleTerm' },
  },
  {
    'folke/twilight.nvim',
    cmd = { 'Twilight', 'TwilightEnable' },
  },
  {
    'jiaoshijie/undotree',
    dependencies = 'nvim-lua/plenary.nvim',
    opts = {},
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
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      'kristijanhusak/vim-dadbod-completion',
      'tpope/vim-dadbod',
    },
    cmd = 'DBUI',
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
    'atweiden/vim-fennel',
    ft = 'fennel',
  },
  {
    'fladson/vim-kitty',
    ft = 'kitty',
  },
  {
    'preservim/vim-markdown',
    init = function()
      vim.g.vim_markdown_conceal = false
      vim.g.vim_markdown_folding_disabled = 0
    end,
    ft = 'markdown',
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
    -- enhances netrw
    'tpope/vim-vinegar',
    event = 'BufNew netrw',
  },
  {
    'folke/which-key.nvim',
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {},
  },
  {
    'DreamMaoMao/yazi.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'nvim-lua/plenary.nvim',
    },
    cmd = 'Yazi',
    keys = {
      { '<leader>ya', '<cmd>Yazi<cr>', desc = 'Toggie Yazi' },
    },
  },
}
