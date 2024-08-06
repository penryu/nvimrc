--
-- git-related plugins
--

vim.env.GIT_EDITOR = 'nvr --remote-tab-wait'

return {
  {
    'junegunn/gv.vim',
    dependencies = 'tpope/vim-fugitive',
    cmd = 'GV',
  },
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      on_attach = function(bufnr)
        local gitsigns = require('gitsigns')

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk('next')
          end
        end)

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk('prev')
          end
        end)

        -- Actions
        map('n', '<leader>hs', gitsigns.stage_hunk)
        map('n', '<leader>hr', gitsigns.reset_hunk)
        map(
          'v',
          '<leader>hs',
          function() gitsigns.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end
        )
        map(
          'v',
          '<leader>hr',
          function() gitsigns.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end
        )
        map('n', '<leader>hS', gitsigns.stage_buffer)
        map('n', '<leader>hu', gitsigns.undo_stage_hunk)
        map('n', '<leader>hR', gitsigns.reset_buffer)
        map('n', '<leader>hp', gitsigns.preview_hunk)
        map(
          'n',
          '<leader>hb',
          function() gitsigns.blame_line { full = true } end
        )
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
        map('n', '<leader>hd', gitsigns.diffthis)
        map('n', '<leader>hD', function() gitsigns.diffthis('~') end)
        map('n', '<leader>td', gitsigns.toggle_deleted)

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
      end,
      auto_attach = true,
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 1000,
        ignore_whitespace = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
      },
      linehl = false,
      numhl = false,
      signcolumn = true,
      signs_staged_enable = true,
      word_diff = false,
    },
    keys = {
      { '<leader>[c', desc = 'previous change' },
      { '<leader>]c', desc = 'next change' },
      { '<leader>hp', desc = 'preview hunk' },
      { '<leader>hr', desc = 'reset hunk' },
      { '<leader>hR', desc = 'reset buffer' },
      { '<leader>hs', desc = 'stage hunk' },
      { '<leader>hS', desc = 'stage buffer' },
      { '<leader>hu', desc = 'undo stage hunk' },
      { '<leader>hr', desc = 'reset hunk', mode = 'v' },
      { '<leader>hs', desc = 'stage hunk', mode = 'v' },
      { 'ih', desc = 'select hunk', mode = { 'o', 'x' } },
    },
  },
  {
    'tpope/vim-fugitive',
    cmd = {
      'G',
      'Git',
      'Gedit',
      'Gsplit',
      'Gdiffsplit',
      'Gvdiffsplit',
      'Gread',
      'Gwrite',
      'Ggrep',
      'Glgrep',
      'GMove',
      'GDelete',
      'GBrowse',
    },
  },
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      'nvim-telescope/telescope.nvim', -- optional
      'sindrets/diffview.nvim', -- optional
      'ibhagwan/fzf-lua', -- optional
    },
    config = true,
    cmd = { 'Neogit' },
    keys = {
      { '<leader>ng', ':Neogit<cr>', 'noremap', desc = 'Open Neogit' },
    },
  },
}
