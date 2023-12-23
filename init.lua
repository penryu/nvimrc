--
-- GENERAL SETTINGS
--

local g, o = vim.g, vim.o
local u = require 'util'

-- Keybindings

-- Buffer selection
u.nmap('<c-n>', ':bnext<cr>')
u.nmap('<c-p>', ':bprevious<cr>')

u.nmap('<c-h>', ':wincmd h<cr>')
u.nmap('<c-j>', ':wincmd j<cr>')
u.nmap('<c-k>', ':wincmd k<cr>')
u.nmap('<c-l>', ':wincmd l<cr>')

-- Remap for dealing with wo rd wrap.
u.nmap('k', "v:count == 0 ? 'gk' : 'k'", { expr = true })
u.nmap('j', "v:count == 0 ? 'gj' : 'j'", { expr = true })

--
-- Auto commands
--

u.create_autocmd('FileType', {
   pattern = 'diff',
   command = 'setlocal colorcolumn= nocursorline nonumber',
})
u.create_autocmd('FileType', {
   pattern = 'gitconfig',
   command = 'setlocal noexpandtab shiftwidth=4 softtabstop=4 tabstop=4',
})
u.create_autocmd('FileType', {
   pattern = 'lua',
   command = 'setlocal shiftwidth=3 softtabstop=3',
})
u.create_autocmd('FileType', {
   pattern = 'markdown',
   command = 'setlocal spell',
})
u.create_autocmd('FileType', {
   pattern = 'tex',
   command = 'setlocal spell spellfile=words.utf-8.add',
})

-- Customize the terminal

-- Go straight to insert mode; toggleterm handles this separately
u.create_autocmd('TermOpen', { pattern = '*', command = 'startinsert' })
-- :Sh opens term in new window
u.create_command('Sh', 'new +terminal', { nargs = '*' })
-- Remove trailing carriage returns from misdetected DOS files
u.create_command('DeWinify', '%s/\r$//', { nargs = 0 })

-- Customize the less.sh plugin
vim.api.nvim_exec(
   [[
   function LessInitFunc()
      set colorcolumn= nocursorline nonumber
   endfunc
]],
   false
)

-- Remap space as leader key. map('<space>', '<nop>')
g.mapleader = ' '
g.maplocalleader = ','

-- prevent runtime providers from loading
g.loaded_perl_provider = 0
g.loaded_python_provider = 0
-- g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0
-- g.loaded_node_provider = 0

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

o.updatetime = 300
o.backup, o.writebackup = false, false

vim.opt.clipboard:append 'unnamed'

--
-- Neovide settings
--

if g.neovide then
   vim.o.guifont = 'MonaspaceArgonVar:h12.5'
   vim.o.guifontwide = 'Symbols Nerd Font Mono'
   vim.g.transparency = 0.5
   vim.g.neovide_transparency = 0.0
   vim.g.neovide_scroll_animation_length = 0.8
   vim.g.neovide_refresh_rate_idle = 5
   vim.g.neovide_remember_window_size = true
   vim.g.neovide_fullscreen = false
   vim.g.neovide_cursor_animation_length = 0.05
   vim.g.neovide_cursor_vfx_mode = 'railgun'
end
