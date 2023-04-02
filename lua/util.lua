-- Utility functions

local keymapset = function(mode, key, cmd, opts)
   if type(opts) == 'number' then opts = { buffer = opts } end
   vim.keymap.set(mode, key, cmd, opts or { noremap = true, silent = true })
end

return {
   buf_set_option = vim.api.nvim_buf_set_option,
   create_augroup = vim.api.nvim_create_augroup,
   create_autocmd = vim.api.nvim_create_autocmd,
   create_command = vim.api.nvim_create_user_command,
   keymapset = keymapset,
   map = function(...) return keymapset('', ...) end,
   nmap = function(...) return keymapset('n', ...) end,
   vmap = function(...) return keymapset('v', ...) end,
   smap = function(...) return keymapset('s', ...) end,
   xmap = function(...) return keymapset('x', ...) end,
   omap = function(...) return keymapset('o', ...) end,
   imap = function(...) return keymapset('i', ...) end,
   lmap = function(...) return keymapset('l', ...) end,
   cmap = function(...) return keymapset('c', ...) end,
   tmap = function(...) return keymapset('t', ...) end,
}
