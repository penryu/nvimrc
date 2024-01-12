--
-- Colorschemes
--

local g = vim.g

return {
  {
    'adisen99/apprentice.nvim',
    dependencies = { 'rktjmp/lush.nvim' },
    init = function()
      -- g.apprentice_contrast_dark = 'soft'
      g.apprentice_contrast_dark = 'medium'
      -- g.apprentice_contrast_dark = 'hard'
    end,
    config = function()
      -- vim.cmd 'colorscheme apprentice'
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
    'ntk148v/habamax.nvim',
    dependencies = { 'rktjmp/lush.nvim' },
    config = function() vim.cmd('colorscheme habamax') end,
    priority = 1000,
    lazy = true,
  },
  {
    'Shatur/neovim-ayu',
    config = function()
      local ayu = require('ayu')
      ayu.setup {
        mirage = false,
      }
      ayu.colorscheme()
    end,
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
    'rakr/vim-one',
    init = function() g.one_allow_italics = 1 end,
    config = function()
      g.one_allow_italics = true
      vim.cmd('colorscheme one')
    end,
    priority = 1000,
    lazy = true,
  },
}
