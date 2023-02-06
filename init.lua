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

vim.cmd [[
   " Keep code lens and type hints from being distracting
   autocmd ColorScheme * highlight link CocCodeLens Comment
   autocmd ColorScheme * highlight link CocInlayHint CocFadeOut
   " Leaving these obnoxious so I know when I hit them
   "autocmd ColorScheme * highlight! link CocHintFloat CocListYellowMagenta
   "autocmd ColorScheme * highlight! link CocHintSign CocListYellowGreen
   "autocmd ColorScheme * highlight! link CocRustTypeHint CocListYellowCyan
   "autocmd ColorScheme * highlight! link CocRustChainingHint CocListYellowBlue
]]

if vim.g.neovide then
   vim.opt.guifont = { 'SauceCodePro Nerd Font Mono:h14' }
   -- vim.g.neovide_transparency = 1.0
   -- vim.g.transparency = 1.0
   -- vim.g.neovide_floating_blur_amount_x = 2.0
   -- vim.g.neovide_floating_blur_amount_y = 2.0
   vim.g.neovide_scroll_animation_length = 0.9
   -- vim.g.neovide_hide_mouse_when_typing = false
   -- vim.g.neovide_refresh_rate = 60
   vim.g.neovide_refresh_rate_idle = 5
   -- vim.g.neovide_confirm_quit = true
   -- vim.g.neovide_profiler = true
   -- vim.g.neovide_fullscreen = false
   vim.g.neovide_cursor_animation_length = 0.05
   -- vim.g.neovide_cursor_antialiasing = true
   -- vim.g.neovide_cursor_trail_size = 0.8
   vim.g.neovide_cursor_vfx_mode = ''
end
