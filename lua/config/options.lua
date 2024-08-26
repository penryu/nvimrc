--
-- options.lua
--

local o = vim.o

o.breakindent = true
o.cmdheight = 2
o.completeopt = 'menuone,noinsert,noselect'
o.colorcolumn = '+1'
o.concealcursor = ''
o.conceallevel = 2
o.cursorline = true
o.expandtab = true
o.foldenable = false
o.hlsearch = false
o.ignorecase = true
o.linebreak = true
o.number = true
o.relativenumber = false
o.scrolloff = 7
o.shada = "%11,'42,r/Volumes,r/mnt,r/tmp,n"
  .. vim.fn.stdpath('state')
  .. '/shada'
o.shiftwidth = 2
o.shortmess = 'acFostI'
o.sidescrolloff = 21
o.signcolumn = 'yes'
o.smartcase = true
o.softtabstop = 2
o.splitbelow = true
o.splitright = true
o.termguicolors = true
o.textwidth = 100
o.timeoutlen = 300

o.updatetime = 300
o.backup, o.writebackup = false, false

vim.opt.clipboard:append('unnamed')
