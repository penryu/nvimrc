--
-- init.lua
--

-- set to 0 to prevent runtime providers from loading; must be 0, not false
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python3_provider = 0

-- must be done before loading lazy.nvim
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

-- set global variables for my own config
vim.g.fancy_number = false

-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end

vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require('lazy').setup('plugins', {
  install = { colorscheme = { 'apprentice' } },
  ui = {
    border = 'rounded',
    size = { height = 0.8, width = 0.9 },
    wrap = false,
  },
})

-- Customize the less.sh plugin
vim.api.nvim_exec(
  [[
      function LessInitFunc()
         set colorcolumn= nocursorline nonumber
      endfunc
   ]],
  false
)

require('config.options')
require('config.keymaps')
require('config.commands')
require('config.autocmds')
