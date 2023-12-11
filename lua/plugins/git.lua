--
-- git-related plugins
--

return {
   {
      'junegunn/gv.vim',
      cmd = 'GV',
      dependencies = 'tpope/vim-fugitive',
   },
   {
      'lewis6991/gitsigns.nvim',
      lazy = false,
      config = function() require('gitsigns').setup() end,
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
   },
}
