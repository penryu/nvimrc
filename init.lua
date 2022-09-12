-- GENERAL SETTINGS

local create_autocmd = vim.api.nvim_create_autocmd
local create_augroup = vim.api.nvim_create_augroup
local create_command = vim.api.nvim_create_user_command
local buf_set_option = vim.api.nvim_buf_set_option

local g, o = vim.g, vim.o

g.do_filetype_lua = 1
g.did_load_filetypes = 0

--require 'impatient'

require 'plugins'
require 'keys'

g.lazyredraw = true

o.breakindent = true
o.cmdheight = 2
o.colorcolumn = '+1'
o.cursorline = true
o.expandtab = true
o.hlsearch = false
o.ignorecase = true
o.linebreak = true
o.number = true
o.scrolloff = 7
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

create_command('Notes', 'Files ~/Dropbox/Notes', {})

-- Customize the terminal

-- :sh opens term in new window
create_command('Sh', 'new +terminal', { nargs = '*' })
-- Go straight to insert mode
create_autocmd('TermOpen', {
   pattern = '*',
   callback = function()
      vim.cmd 'startinsert'
   end,
})
