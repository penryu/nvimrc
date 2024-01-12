--
-- keymaps.lua
--

local u = require('util')

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
