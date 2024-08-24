--
-- git-related plugins
--

local u = require('util')

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

        local function kmap(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          u.keymapset(mode, l, r, opts)
        end
        local nmap = function(...) return kmap('n', ...) end
        local vmap = function(...) return kmap('v', ...) end

        -- Navigation
        nmap(']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk('next')
          end
        end, { desc = 'Git next change' })

        nmap('[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk('prev')
          end
        end, { desc = 'Git previous change' })

        -- Actions
        nmap('<leader>hs', gitsigns.stage_hunk, { desc = 'Git stage hunk' })
        nmap('<leader>hr', gitsigns.reset_hunk, { desc = 'Git reset hunk' })
        vmap(
          '<leader>hs',
          function() gitsigns.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
          { desc = 'Git stage selected hunk' }
        )
        vmap(
          '<leader>hr',
          function() gitsigns.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
          { desc = 'Git reset selected hunk' }
        )
        nmap('<leader>hS', gitsigns.stage_buffer, { desc = 'Git stage buffer' })
        nmap(
          '<leader>hu',
          gitsigns.undo_stage_hunk,
          { desc = 'Git undo stage hunk' }
        )
        nmap('<leader>hR', gitsigns.reset_buffer, { desc = 'Git reset buffer' })
        nmap('<leader>hp', gitsigns.preview_hunk, { desc = 'Git preview hunk' })
        nmap(
          '<leader>hb',
          function() gitsigns.blame_line { full = true } end,
          { desc = 'Git blame line' }
        )
        nmap(
          '<leader>tb',
          gitsigns.toggle_current_line_blame,
          { desc = 'Git toggle blame' }
        )
        nmap('<leader>hd', gitsigns.diffthis, { desc = 'Git diff this' })
        nmap(
          '<leader>hD',
          function() gitsigns.diffthis('~') end,
          { desc = 'Git diff this ~' }
        )
        nmap(
          '<leader>td',
          gitsigns.toggle_deleted,
          { desc = 'Git toggle deleted' }
        )

        -- Text object
        kmap(
          { 'o', 'x' },
          'ih',
          ':<C-U>Gitsigns select_hunk<CR>',
          { desc = 'Git select hunk' }
        )
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
    event = 'VeryLazy',
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
