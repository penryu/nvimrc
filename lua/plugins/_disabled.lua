local disabled_plugins = {
  {
    'simrat39/symbols-outline.nvim',
    config = function() require('symbols-outline').setup {} end,
    event = 'LspAttach',
  },
}

return {}
