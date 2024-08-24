--
-- filetype-specific plugins
--

local u = require('util')

return {
  -- markdown
  {
    'jakewvincent/mkdnflow.nvim',
    dependencies = {
      'ellisonleao/glow.nvim',
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('mkdnflow').setup {
        perspective = {
          priority = 'root',
          root_tell = 'index.md',
        },
      }
      u.create_command('Notes', 'Files ~/Dropbox/Notes', {})
    end,
    cmd = 'Notes',
    ft = 'markdown',
  },
  {
    'preservim/vim-markdown',
    init = function()
      vim.g.vim_markdown_conceal = false
      vim.g.vim_markdown_folding_disabled = 0
    end,
    ft = 'markdown',
  },
  -- kitty
  {
    'fladson/vim-kitty',
    ft = 'kitty',
  },
  -- lisp
  {
    'kovisoft/paredit',
    ft = { 'clojure', 'fennel', 'lisp' },
  },
  {
    'atweiden/vim-fennel',
    ft = 'fennel',
  },
}
