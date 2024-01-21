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
    opts = {},
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
