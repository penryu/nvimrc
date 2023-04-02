--
-- Colorschemes
--
return {
   { -- Apprentice -
      'adisen99/apprentice.nvim',
      dependencies = { 'rktjmp/lush.nvim' },
      init = function()
         -- vim.g.apprentice_contrast_dark = 'hard'
         vim.g.apprentice_contrast_dark = 'medium'
         -- vim.g.apprentice_contrast_dark = 'soft'
      end,
      config = function() vim.cmd 'colorscheme apprentice' end,
      priority = 1000,
      lazy = true,
   },
   { -- Apprentice
      'romainl/Apprentice',
      branch = 'fancylines-and-neovim',
      config = function() vim.cmd 'colorscheme apprentice' end,
      enabled = false,
      priority = 1000,
      lazy = true,
   },
   {
      'sainnhe/gruvbox-material',
      config = function() vim.cmd 'colorscheme gruvbox-material' end,
      priority = 1000,
      lazy = true,
   },
   { -- Nord
      'shaunsingh/nord.nvim',
      config = function() vim.cmd 'colorscheme nord' end,
      priority = 1000,
      lazy = true,
   },
   { -- Nordic
      'AlexvZyl/nordic.nvim',
      config = function() require('nordic').load() end,
      priority = 1000,
      lazy = true,
   },
   { -- TokyoNight
      'folke/tokyonight.nvim',
      priority = 1000,
      config = function()
         -- vim.cmd 'colorscheme tokyonight'
         vim.cmd 'colorscheme tokyonight-moon'
         -- vim.cmd 'colorscheme tokyonight-night'
         -- vim.cmd 'colorscheme tokyonight-storm'
      end,
      lazy = true,
   },
   { -- Tender
      'jacoborus/tender.vim',
      config = function() vim.cmd 'colorscheme tender' end,
      priority = 1001,
      lazy = true,
   },
}
