--
-- Colorschemes
--

return {
  {
    'adisen99/apprentice.nvim',
    dependencies = { 'rktjmp/lush.nvim' },
    config = function()
      -- vim.g.apprentice_contrast_dark = 'soft'
      vim.g.apprentice_contrast_dark = 'medium'
      -- vim.g.apprentice_contrast_dark = 'hard'
      require('lush')(require('apprentice').setup {
        plugins = {
          -- 'buftabline',
          -- 'coc',
          'cmp', -- nvim-cmp
          'fzf',
          'gitgutter',
          'gitsigns',
          'lsp',
          'lspsaga',
          -- 'nerdtree',
          'netrw',
          -- 'nvimtree',
          'neogit',
          -- 'packer',
          -- 'signify',
          'startify',
          -- 'syntastic',
          'telescope',
          'treesitter',
        },
      })
    end,
    priority = 2000,
    lazy = false,
  },
  {
    'romainl/Apprentice',
    branch = 'fancylines-and-neovim',
    config = function() vim.cmd('colorscheme apprentice') end,
    priority = 1000,
    lazy = true,
  },
  {
    'shaunsingh/nord.nvim',
    config = function() vim.cmd('colorscheme nord') end,
    priority = 1000,
    lazy = true,
  },
  {
    'AlexvZyl/nordic.nvim',
    config = function() require('nordic').load() end,
    priority = 1000,
    lazy = true,
  },
  {
    'habamax/vim-alchemist',
    priority = 1000,
    lazy = true,
  },
  {
    'habamax/vim-gruvbit',
    priority = 1000,
    lazy = true,
  },
  {
    'habamax/vim-saturnite',
    priority = 1000,
    lazy = true,
  },
}
