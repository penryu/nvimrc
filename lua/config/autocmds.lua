--
-- autocmds.lua
--

local u = require('util')

u.create_autocmd('FileType', {
  pattern = 'diff',
  command = 'setlocal colorcolumn= nocursorline nonumber',
})
u.create_autocmd('FileType', {
  pattern = 'gitconfig',
  command = 'setlocal noexpandtab shiftwidth=4 softtabstop=4 tabstop=4',
})
u.create_autocmd('FileType', {
  pattern = { 'gitcommit', 'gitrebase', 'gitconfig' },
  command = 'setlocal bufhidden=delete',
})
u.create_autocmd('FileType', {
  pattern = 'lua',
  command = 'setlocal shiftwidth=2 softtabstop=2',
})
u.create_autocmd('FileType', {
  pattern = 'markdown',
  command = 'setlocal spell',
})
u.create_autocmd('FileType', {
  pattern = 'tex',
  command = 'setlocal spell spellfile=words.utf-8.add',
})
