local _disabled_plugins = {
  {
    'simrat39/symbols-outline.nvim',
    config = function() require('symbols-outline').setup {} end,
    event = 'LspAttach',
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
}

return {}
