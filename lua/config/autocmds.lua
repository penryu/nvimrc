--
-- autocmds.lua
--

local u = require('util')

if vim.g.fancy_number then
  u.create_autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave', 'WinEnter' }, {
    callback = function()
      if vim.o.number and vim.api.nvim_get_mode()['mode'] ~= 'i' then
        vim.o.relativenumber = true
      end
    end,
  })

  u.create_autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter', 'WinLeave' }, {
    callback = function()
      if vim.o.number then vim.o.relativenumber = false end
    end,
  })
end

u.create_autocmd('FileType', {
  pattern = { 'diff', 'help', 'man' },
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
  pattern = { 'json', 'javascript', 'typescript' },
  command = 'setlocal foldmethod=syntax',
})

u.create_autocmd('FileType', {
  pattern = 'lua',
  command = 'setlocal foldmethod=indent shiftwidth=2 softtabstop=2',
})

u.create_autocmd('FileType', {
  pattern = 'markdown',
  command = 'setlocal spell',
})

u.create_autocmd('FileType', {
  pattern = 'python',
  command = 'setlocal foldmethod=indent textwidth=88',
})

u.create_autocmd('FileType', {
  pattern = 'rust',
  command = 'setlocal foldmethod=syntax',
})

u.create_autocmd('FileType', {
  pattern = 'tex',
  command = 'setlocal spell spellfile=words.utf-8.add',
})
