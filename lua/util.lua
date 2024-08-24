-- Utility functions

local default_keymap_opts = { noremap = true, silent = true }

local function keymapset(mode, key, cmd, opts)
  opts = vim.tbl_extend('keep', opts or {}, default_keymap_opts)
  vim.keymap.set(mode, key, cmd, opts)
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
