-- GENERAL SETTINGS

local create_autocmd = vim.api.nvim_create_autocmd
local create_augroup = vim.api.nvim_create_augroup
local create_command = vim.api.nvim_create_user_command
local buf_set_option = vim.api.nvim_buf_set_option

local g, o = vim.g, vim.o

-- prevent runtime providers from loading
g.loaded_perl_provider = 0
g.loaded_python_provider = 0
-- g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0
-- g.loaded_node_provider = 0

require 'keys'

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
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
vim.opt.rtp:prepend(lazypath)

require('lazy').setup('plugins', {
   ui = {
      border = 'rounded',
      size = { height = 0.8, width = 0.9 },
      wrap = false,
   },
})

o.breakindent = true
o.cmdheight = 2
o.colorcolumn = '+1'
o.conceallevel = 0
o.cursorline = true
o.expandtab = true
o.foldenable = false
o.hlsearch = false
o.ignorecase = true
o.linebreak = true
o.number = true
o.scrolloff = 7
o.sessionoptions = 'buffers,curdir,globals,help,tabpages,terminal'
o.shada = "'7,r/Volumes,r/media,r/mnt,r/tmp"
o.shiftwidth = 2
o.shortmess = 'acostI'
o.sidescrolloff = 21
o.signcolumn = 'yes'
o.smartcase = true
o.softtabstop = 2
o.splitbelow = true
o.splitright = true
o.termguicolors = true
o.textwidth = 80
o.timeoutlen = 300
o.ttimeout = false

-- coc settings
o.updatetime = 300
o.backup, o.writebackup = false, false

vim.opt.clipboard:append 'unnamed'

create_autocmd('FileType', {
   pattern = 'lua',
   callback = function()
      buf_set_option(0, 'shiftwidth', 3)
      buf_set_option(0, 'softtabstop', 3)
   end,
   group = create_augroup('LuaIndent', {}),
})
