--
-- Colorschemes
--
return {
   -- Apprentice
   {
      'adisen99/apprentice.nvim',
      dependencies = { 'rktjmp/lush.nvim' },
      config = function() vim.cmd 'colorscheme apprentice' end,
      priority = 1000,
      lazy = false,
   },
   -- Nemo
   {
      'rmdashrfv/nemo',
      config = function() vim.cmd 'colorscheme nemo-dark' end,
      priority = 1000,
      lazy = true,
   },
   -- TokyoNight
   {
      'folke/tokyonight.nvim',
      priority = 1000,
      opts = { style = 'night' },
      lazy = true,
   },
}
