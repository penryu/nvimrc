-- Keybindings

local keymapset = function(mode, key, cmd, opts)
   if type(opts) == 'number' then
      opts = {buffer=opts}
   end
   vim.keymap.set(mode, key, cmd, opts or {noremap=true, silent=true})
end

local map  = function(...) return keymapset('', ...) end
local nmap = function(...) return keymapset('n', ...) end
local vmap = function(...) return keymapset('v', ...) end
local smap = function(...) return keymapset('s', ...) end
local xmap = function(...) return keymapset('x', ...) end
local omap = function(...) return keymapset('o', ...) end
local imap = function(...) return keymapset('i', ...) end
local lmap = function(...) return keymapset('l', ...) end
local cmap = function(...) return keymapset('c', ...) end
local tmap = function(...) return keymapset('t', ...) end

-- Remap space as leader key. map('<space>', '<nop>')
vim.g.mapleader = ' '
vim.g.maplocalleader = ','


-- Terminal commands
tmap('<esc>', [[<c-\><c-n>:let b:insertMode = 'no'<cr>]])
keymapset({'n', 't'}, '<a-t>', [[<c-\><c-n>:tabe<cr>:term<cr>]])

-- Buffer selection
keymapset('n', '<c-n>', ':bnext<cr>')
keymapset('n', '<c-p>', ':bprevious<cr>')

-- Window selection
keymapset({'n', 't'}, '<c-h>',  '<c-\\><c-n>:wincmd h<cr>')
keymapset({'n', 't'}, '<c-j>',  '<c-\\><c-n>:wincmd j<cr>')
keymapset({'n', 't'}, '<c-k>',    '<c-\\><c-n>:wincmd k<cr>')
keymapset({'n', 't'}, '<c-l>', '<c-\\><c-n>:wincmd l<cr>')

-- Remap for dealing with wo rd wrap.
nmap('k', "v:count == 0 ? 'gk' : 'k'", {
   noremap = true, expr = true, silent = true
})
nmap('j', "v:count == 0 ? 'gj' : 'j'", {
   noremap = true, expr = true, silent = true
})

return {
   keymapset= keymapset,
   map = map,
   nmap = nmap,
   vmap = vmap,
   smap = smap,
   xmap = xmap,
   omap = omap,
   imap = imap,
   lmap = lmap,
   cmap = cmap,
   tmap = tmap,
}
