local _disabled_plugins = {
  {
    'simrat39/symbols-outline.nvim',
    config = function() require('symbols-outline').setup {} end,
    event = 'LspAttach',
  },
}

return {
  {
    'DreamMaoMao/yazi.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'nvim-lua/plenary.nvim',
    },
    cmd = 'Yazi',
    keys = {
      { '<leader>gy', '<cmd>Yazi<cr>', desc = 'Toggie Yazi' },
    },
  },
  {
    'penryu/rp.nvim',
    opts = {
      bin = 'hpnc',
    },
    cmd = 'Rp',
    keys = {
      { '<leader>rp', '<cmd>Rp<cr>', desc = 'Launch RPN calculator' },
    },
  },
}
