-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/Users/penryu/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/Users/penryu/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/Users/penryu/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/Users/penryu/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/Users/penryu/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ale = {
    commands = { "ALEEnable" },
    config = { "\27LJ\2\n-\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0\14ALEEnable\bcmd\bvim\0" },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/Users/penryu/.local/share/nvim/site/pack/packer/opt/ale",
    url = "https://github.com/dense-analysis/ale"
  },
  ["apprentice.nvim"] = {
    config = { "\27LJ\2\n:\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0\27colorscheme apprentice\bcmd\bvim\0" },
    loaded = true,
    path = "/Users/penryu/.local/share/nvim/site/pack/packer/start/apprentice.nvim",
    url = "https://github.com/adisen99/apprentice.nvim"
  },
  ["auto-session"] = {
    config = { "\27LJ\2\n�\1\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\2B\0\2\1K\0\1\0\31auto_session_suppress_dirs\1\4\0\0\a~/\16~/Downloads\6/\1\0\1\14log_level\twarn\nsetup\17auto-session\frequire\0" },
    loaded = true,
    path = "/Users/penryu/.local/share/nvim/site/pack/packer/start/auto-session",
    url = "https://github.com/rmagatti/auto-session"
  },
  ["coc.nvim"] = {
    after = { "rust.vim" },
    config = { "\27LJ\2\n�4\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0�4            \"\n            \" Helper functions\n            \"\n            function! CheckBackspace() abort\n               let col = col('.') - 1\n               return !col || getline('.')[col - 1] =~# '\\s'\n            endfunction\n            function! ShowDocumentation()\n               if CocAction('hasProvider', 'hover')\n                  call CocActionAsync('doHover')\n               else\n                  call feedkeys('K', 'in')\n               endif\n            endfunction\n\n            \" Tab to trigger completion with characters ahead and navigate.\n            inoremap <silent><expr> <Tab>\n               \\ coc#pum#visible() ? coc#pum#next(1):\n               \\ CheckBackspace() ? \"\\<Tab>\" :\n               \\ coc#refresh()\n\n            inoremap <expr><S-Tab> coc#pum#visible() ? coc#pum#prev(1) : \"\\<C-h>\"\n\n            \" Use <c-space> to trigger completion.\n            inoremap <silent><expr> <C-Space> coc#refresh()\n\n            \" Make <CR> to accept selected completion item or notify coc.nvim to format\n            \" <C-g>u breaks current undo, please make your own choice.\n            inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()\n               \\: \"\\<C-g>u\\<CR>\\<c-r>=coc#on_enter()\\<CR>\"\n\n            \" Use `[g` and `]g` to navigate diagnostics\n            nmap <silent> [g <Plug>(coc-diagnostic-prev)\n            nmap <silent> ]g <Plug>(coc-diagnostic-next)\n\n            \" Remap keys for gotos\n            nmap <silent> gd <Plug>(coc-definition)\n            nmap <silent> gi <Plug>(coc-implementation)\n            nmap <silent> gr <Plug>(coc-references)\n            nmap <silent> gy <Plug>(coc-type-definition)\n            nmap <silent> gD :call CocAction('jumpDefinition', 'split')<CR>\n            nmap <silent> gV :call CocAction('jumpDefinition', 'vsplit')<CR>\n            nmap <silent> gnt :call CocAction('jumpDefinition', 'tabe')<CR>\n\n            \" Use K to show documentation in preview window\n            nnoremap <silent> K :call ShowDocumentation()<CR>\n\n            \" Highlight the symbol and its references when holding the cursor.\n            autocmd CursorHold * silent call CocActionAsync('highlight')\n\n            \" Symbol renaming.\n            nmap <leader>rn <Plug>(coc-rename)\n\n            \" Formatting selected code.\n            xmap <leader>f  <Plug>(coc-format-selected)\n            nmap <leader>f  <Plug>(coc-format-selected)\n\n            augroup mygroup\n               autocmd!\n               \" Setup formatexpr specified filetype(s).\n               autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')\n               \" Update signature help on jump placeholder.\n               autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')\n            augroup end\n\n            \" Applying codeAction to the selected region.\n            \" Example: `<leader>aap` for current paragraph\n            xmap <leader>a  <Plug>(coc-codeaction-selected)\n            nmap <leader>a  <Plug>(coc-codeaction-selected)\n\n            \" Remap for applying codeAction to the current buffer.\n            nmap <leader>ac <Plug>(coc-codeaction)\n\n            \" Perform code lens action on current line\n            nmap <leader>cl <Plug>(coc-codelens-action)\n\n            \" Apply Autofix to problem on the current line.\n            nmap <leader>qf  <Plug>(coc-fix-current)\n\n            \" Map function and class text objects\n            \" NOTE: Requires 'textDocument.documentSymbol' support from language server\n            xmap if <Plug>(coc-funcobj-i)\n            omap if <Plug>(coc-funcobj-i)\n            xmap af <Plug>(coc-funcobj-a)\n            omap af <Plug>(coc-funcobj-a)\n            xmap ic <Plug>(coc-classobj-i)\n            omap ic <Plug>(coc-classobj-i)\n            xmap ac <Plug>(coc-classobj-a)\n            omap ac <Plug>(coc-classobj-a)\n\n            \" Remap <C-f> and <C-b> for scroll float windows/popups.\n            nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : \"\\<C-f>\"\n            nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : \"\\<C-b>\"\n            inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? \"\\<c-r>=coc#float#scroll(1)\\<cr>\" : \"\\<Right>\"\n            inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? \"\\<c-r>=coc#float#scroll(0)\\<cr>\" : \"\\<Left>\"\n            vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : \"\\<C-f>\"\n            vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : \"\\<C-b>\"\n\n            \" Use CTRL-S for selection ranges.\n            \" Requires 'textDocument/selectionRange' support of language server.\n            \" Example: coc-tsserver, coc-python\n            nmap <silent> <C-s> <Plug>(coc-range-select)\n            xmap <silent> <C-s> <Plug>(coc-range-select)\n\n            \" Add `:Format` to format current buffer\n            command! -nargs=0 Format :call CocActionAsync('format')\n\n            \" Use `:Fold` to fold current buffer\n            command! -nargs=? Fold :call CocAction('fold', <f-args>)\n\n            \" Add `:OR` command to organize import of current buffer.\n            command! -nargs=0 OR :call CocActionAsync('runCommand', 'editor.action.organizeImport')\n\n            \" Add native (Neo)Vim status line support.\n            \" See `:h coc-status` for integration with plugins with custom statusline:\n            set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}\n\n            \" Mappings for CocList\n            \" Show all diagnostics.\n            nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>\n            \" Manage extensions.\n            nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>\n            \" Show commands.\n            nnoremap <silent> <space>c  :<C-u>CocList commands<cr>\n            \" Find symbol of current document.\n            nnoremap <silent> <space>o  :<C-u>CocList outline<cr>\n            \" Search workspace symbols.\n            nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>\n            \" Do default action for next item.\n            nnoremap <silent> <space>j  :<C-u>CocNext<CR>\n            \" Do default action for previous item.\n            nnoremap <silent> <space>k  :<C-u>CocPrev<CR>\n            \" Resume latest coc list.\n            nnoremap <silent> <space>p  :<C-u>CocListResume<CR>\n\n            \" Bootstrap coc extensions\n            let g:coc_global_extensions = [\n               \\ 'coc-css',\n               \\ 'coc-eslint',\n               \\ 'coc-html',\n               \\ 'coc-json',\n               \\ 'coc-prettier',\n               \\ 'coc-pyright',\n               \\ 'coc-tsserver',\n               \\ 'coc-yaml',\n               \\ ]\n       \bcmd\bvim\0" },
    loaded = true,
    only_config = true,
    path = "/Users/penryu/.local/share/nvim/site/pack/packer/start/coc.nvim",
    url = "https://github.com/neoclide/coc.nvim"
  },
  fzf = {
    loaded = true,
    path = "/Users/penryu/.local/share/nvim/site/pack/packer/start/fzf",
    url = "https://github.com/junegunn/fzf"
  },
  ["fzf.vim"] = {
    loaded = true,
    path = "/Users/penryu/.local/share/nvim/site/pack/packer/start/fzf.vim",
    url = "https://github.com/junegunn/fzf.vim"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\2\n6\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\rgitsigns\frequire\0" },
    loaded = true,
    path = "/Users/penryu/.local/share/nvim/site/pack/packer/start/gitsigns.nvim",
    url = "https://github.com/lewis6991/gitsigns.nvim"
  },
  ["glow.nvim"] = {
    loaded = true,
    path = "/Users/penryu/.local/share/nvim/site/pack/packer/start/glow.nvim",
    url = "https://github.com/ellisonleao/glow.nvim"
  },
  hexmode = {
    config = { "\27LJ\2\nK\0\0\2\0\4\0\0056\0\0\0009\0\1\0'\1\3\0=\1\2\0K\0\1\0\29*.bin,*.exe,*.dat,*.wasm\21hexmode_patterns\6g\bvim\0" },
    loaded = true,
    path = "/Users/penryu/.local/share/nvim/site/pack/packer/start/hexmode",
    url = "https://github.com/fidian/hexmode"
  },
  ["lualine.nvim"] = {
    config = { "\27LJ\2\n�\4\0\0\a\0\29\0+6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0025\3\6\0=\3\a\0025\3\f\0005\4\b\0005\5\t\0005\6\n\0=\6\v\5>\5\3\4=\4\r\0034\4\3\0005\5\14\0>\5\1\4=\4\15\0035\4\16\0005\5\17\0005\6\18\0=\6\v\5>\5\2\4=\4\19\3=\3\20\0025\3\22\0005\4\21\0=\4\23\0034\4\0\0=\4\r\0034\4\0\0=\4\15\0034\4\0\0=\4\19\0035\4\24\0=\4\25\0035\4\26\0=\4\27\3=\3\28\2B\0\2\1K\0\1\0\ftabline\14lualine_z\1\2\0\0\vbranch\14lualine_y\1\2\0\0\ttabs\14lualine_a\1\0\0\1\2\0\0\fbuffers\rsections\14lualine_x\1\0\3\tunix\5\bmac\bmac\bdos\bdos\1\2\0\0\15fileformat\1\4\0\0\rencoding\0\rfiletype\14lualine_c\1\2\1\0\rfilename\tpath\3\1\14lualine_b\1\0\0\fsymbols\1\0\4\twarn\aW:\tinfo\aI:\nerror\aE:\thint\aH:\1\2\0\0\16diagnostics\1\3\0\0\vbranch\tdiff\foptions\1\0\2\17globalstatus\2\ntheme\vwombat\15extensions\1\0\0\1\5\0\0\rfugitive\bfzf\bman\rneo-tree\nsetup\flualine\frequire\0" },
    loaded = true,
    path = "/Users/penryu/.local/share/nvim/site/pack/packer/start/lualine.nvim",
    url = "https://github.com/nvim-lualine/lualine.nvim"
  },
  ["lush.nvim"] = {
    loaded = true,
    path = "/Users/penryu/.local/share/nvim/site/pack/packer/start/lush.nvim",
    url = "https://github.com/rktjmp/lush.nvim"
  },
  ["mkdnflow.nvim"] = {
    config = { "\27LJ\2\nu\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\16perspective\1\0\0\1\0\2\14root_tell\rindex.md\rpriority\troot\nsetup\rmkdnflow\frequire\0" },
    loaded = true,
    path = "/Users/penryu/.local/share/nvim/site/pack/packer/start/mkdnflow.nvim",
    url = "https://github.com/jakewvincent/mkdnflow.nvim"
  },
  ["neo-tree.nvim"] = {
    config = { "\27LJ\2\n�\18\0\0\a\0@\0_6\0\0\0009\0\1\0'\2\2\0B\0\2\0016\0\0\0009\0\3\0009\0\4\0'\2\5\0005\3\6\0B\0\3\0016\0\0\0009\0\3\0009\0\4\0'\2\a\0005\3\b\0B\0\3\0016\0\0\0009\0\3\0009\0\4\0'\2\t\0005\3\n\0B\0\3\0016\0\0\0009\0\3\0009\0\4\0'\2\v\0005\3\f\0B\0\3\0016\0\r\0'\2\14\0B\0\2\0029\0\15\0005\2\16\0005\3\18\0005\4\17\0=\4\19\0035\4\20\0=\4\21\0035\4\22\0=\4\23\0035\4\24\0=\4\25\0035\4\26\0=\4\27\0035\4\29\0005\5\28\0=\5\30\4=\4\31\3=\3 \0025\3!\0005\4\"\0=\4#\0035\4%\0005\5$\0=\5&\0045\5'\0005\6(\0=\6)\5=\5*\4=\4+\3=\3,\0024\3\0\0=\3-\0025\0033\0005\4.\0005\5/\0=\0050\0044\5\0\0=\0051\0044\5\0\0=\0052\4=\0044\0035\0046\0005\0055\0=\5+\4=\4,\3=\0037\0025\0038\0005\4:\0005\0059\0=\5+\4=\4,\3=\3;\0025\3>\0005\4<\0005\5=\0=\5+\4=\4,\3=\3\31\2B\0\2\0016\0\0\0009\0\1\0'\2?\0B\0\2\1K\0\1\0#nnoremap \\ :Neotree toggle<cr>\1\0\0\1\0\a\agg\24git_commit_and_push\agu\21git_unstage_file\agp\rgit_push\6A\16git_add_all\agc\15git_commit\agr\20git_revert_file\aga\17git_add_file\1\0\1\rposition\nfloat\fbuffers\1\0\0\1\0\3\abd\18buffer_delete\6.\rset_root\t<bs>\16navigate_up\1\0\1\18show_unloaded\2\15filesystem\1\0\0\1\0\6\n<c-x>\17clear_filter\6/\17fuzzy_finder\6.\rset_root\6f\21filter_on_submit\6H\18toggle_hidden\t<bs>\16navigate_up\19filtered_items\1\0\3\27use_libuv_file_watcher\1\26hijack_netrw_behavior\17open_default\24follow_current_file\2\15never_show\20hide_by_pattern\17hide_by_name\1\3\0\0\14.DS_Store\14thumbs.db\1\0\4\16hide_hidden\2\20hide_gitignored\2\18hide_dotfiles\2\fvisible\1\18nesting_rules\vwindow\rmappings\6a\vconfig\1\0\1\14show_path\tnone\1\2\0\0\badd\f<space>\1\0\18\6c\tcopy\6d\vdelete\6w\28open_with_window_picker\6A\18add_directory\6?\14show_help\6C\15close_node\6S\15open_split\t<cr>\topen\18<2-LeftMouse>\topen\6t\16open_tabnew\6R\frefresh\6s\16open_vsplit\6q\17close_window\6m\tmove\6p\25paste_from_clipboard\6x\21cut_to_clipboard\6y\22copy_to_clipboard\6r\vrename\1\2\1\0\16toggle_node\vnowait\1\20mapping_options\1\0\2\vnowait\2\fnoremap\2\1\0\2\rposition\tleft\nwidth\3(\30default_component_configs\15git_status\fsymbols\1\0\0\1\0\t\runstaged\b\fignored\b\14untracked\b\frenamed\b\fdeleted\b✖\nadded\5\rconflict\b\vstaged\b\rmodified\5\tname\1\0\3\26use_git_status_colors\2\19trailing_slash\1\14highlight\20NeoTreeFileName\rmodified\1\0\2\vsymbol\b[+]\14highlight\20NeoTreeModified\ticon\1\0\5\18folder_closed\b\14highlight\20NeoTreeFileIcon\17folder_empty\bﰊ\16folder_open\b\fdefault\6*\vindent\1\0\t\14highlight\24NeoTreeIndentMarker\23last_indent_marker\b└\18indent_marker\b│\17with_markers\2\fpadding\3\1\16indent_size\3\2\23expander_highlight\20NeoTreeExpander\22expander_expanded\b\23expander_collapsed\b\14container\1\0\0\1\0\1\26enable_character_fade\2\1\0\4\25close_if_last_window\1\23enable_diagnostics\2\22enable_git_status\2\23popup_border_style\frounded\nsetup\rneo-tree\frequire\1\0\2\vtexthl\23DiagnosticSignHint\ttext\b\23DiagnosticSignHint\1\0\2\vtexthl\23DiagnosticSignInfo\ttext\t \23DiagnosticSignInfo\1\0\2\vtexthl\23DiagnosticSignWarn\ttext\t \23DiagnosticSignWarn\1\0\2\vtexthl\24DiagnosticSignError\ttext\t \24DiagnosticSignError\16sign_define\afn0 let g:neo_tree_remove_legacy_commands = 1 \bcmd\bvim\0" },
    loaded = true,
    path = "/Users/penryu/.local/share/nvim/site/pack/packer/start/neo-tree.nvim",
    url = "https://github.com/nvim-neo-tree/neo-tree.nvim"
  },
  ["nui.nvim"] = {
    loaded = true,
    path = "/Users/penryu/.local/share/nvim/site/pack/packer/start/nui.nvim",
    url = "https://github.com/MunifTanjim/nui.nvim"
  },
  ["nvim-treesitter"] = {
    loaded = true,
    path = "/Users/penryu/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-treesitter-textobjects"] = {
    loaded = true,
    path = "/Users/penryu/.local/share/nvim/site/pack/packer/start/nvim-treesitter-textobjects",
    url = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/Users/penryu/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/kyazdani42/nvim-web-devicons"
  },
  ["nvim-window-picker"] = {
    config = { "\27LJ\2\n�\1\0\0\6\0\f\0\0156\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\t\0005\4\5\0005\5\4\0=\5\6\0045\5\a\0=\5\b\4=\4\n\3=\3\v\2B\0\2\1K\0\1\0\17filter_rules\abo\1\0\0\fbuftype\1\2\0\0\rterminal\rfiletype\1\0\0\1\5\0\0\rneo-tree\19neo-tree-popup\vnotify\rquickfix\1\0\3\20include_current\1\19autoselect_one\2\23other_win_hl_color\f#e35e4f\nsetup\18window-picker\frequire\0" },
    loaded = true,
    path = "/Users/penryu/.local/share/nvim/site/pack/packer/start/nvim-window-picker",
    url = "https://github.com/s1n7ax/nvim-window-picker"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/Users/penryu/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  paredit = {
    loaded = true,
    path = "/Users/penryu/.local/share/nvim/site/pack/packer/start/paredit",
    url = "https://github.com/kovisoft/paredit"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/Users/penryu/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["rust.vim"] = {
    config = { "\27LJ\2\n2\0\0\2\0\3\0\0056\0\0\0009\0\1\0)\1\1\0=\1\2\0K\0\1\0\21rustfmt_autosave\6g\bvim\0" },
    load_after = {},
    loaded = true,
    needs_bufread = true,
    path = "/Users/penryu/.local/share/nvim/site/pack/packer/opt/rust.vim",
    url = "https://github.com/rust-lang/rust.vim"
  },
  tagbar = {
    config = { "\27LJ\2\n|\0\0\5\0\b\0\r6\0\0\0'\2\1\0B\0\2\0029\0\2\0\18\1\0\0'\3\3\0'\4\4\0B\1\3\0016\1\5\0009\1\6\1)\2 \0=\2\a\1K\0\1\0\17tagbar_width\6g\bvim\22:TagbarToggle<cr>\14<Leader>t\tnmap\tkeys\frequire\0" },
    loaded = true,
    path = "/Users/penryu/.local/share/nvim/site/pack/packer/start/tagbar",
    url = "https://github.com/preservim/tagbar"
  },
  ["typescript-vim"] = {
    loaded = true,
    path = "/Users/penryu/.local/share/nvim/site/pack/packer/start/typescript-vim",
    url = "https://github.com/leafgarland/typescript-vim"
  },
  ["vim-better-whitespace"] = {
    loaded = true,
    path = "/Users/penryu/.local/share/nvim/site/pack/packer/start/vim-better-whitespace",
    url = "https://github.com/ntpeters/vim-better-whitespace"
  },
  ["vim-commentary"] = {
    loaded = true,
    path = "/Users/penryu/.local/share/nvim/site/pack/packer/start/vim-commentary",
    url = "https://github.com/tpope/vim-commentary"
  },
  ["vim-dispatch"] = {
    loaded = true,
    path = "/Users/penryu/.local/share/nvim/site/pack/packer/start/vim-dispatch",
    url = "https://github.com/tpope/vim-dispatch"
  },
  ["vim-dispatch-neovim"] = {
    loaded = true,
    path = "/Users/penryu/.local/share/nvim/site/pack/packer/start/vim-dispatch-neovim",
    url = "https://github.com/radenling/vim-dispatch-neovim"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/Users/penryu/.local/share/nvim/site/pack/packer/start/vim-fugitive",
    url = "https://github.com/tpope/vim-fugitive"
  },
  ["vim-javascript"] = {
    config = { "\27LJ\2\n9\0\0\2\0\3\0\0056\0\0\0009\0\1\0+\1\2\0=\1\2\0K\0\1\0\28javascript_plugin_jsdoc\6g\bvim\0" },
    loaded = true,
    path = "/Users/penryu/.local/share/nvim/site/pack/packer/start/vim-javascript",
    url = "https://github.com/pangloss/vim-javascript"
  },
  ["vim-json"] = {
    config = { "\27LJ\2\n9\0\0\2\0\3\0\0056\0\0\0009\0\1\0+\1\2\0=\1\2\0K\0\1\0\28vim_json_syntax_conceal\6g\bvim\0" },
    loaded = true,
    path = "/Users/penryu/.local/share/nvim/site/pack/packer/start/vim-json",
    url = "https://github.com/elzr/vim-json"
  },
  ["vim-polyglot"] = {
    loaded = true,
    path = "/Users/penryu/.local/share/nvim/site/pack/packer/start/vim-polyglot",
    url = "https://github.com/sheerun/vim-polyglot"
  },
  ["vim-sandwich"] = {
    loaded = true,
    path = "/Users/penryu/.local/share/nvim/site/pack/packer/start/vim-sandwich",
    url = "https://github.com/machakann/vim-sandwich"
  },
  ["vim-tsx"] = {
    loaded = true,
    path = "/Users/penryu/.local/share/nvim/site/pack/packer/start/vim-tsx",
    url = "https://github.com/ianks/vim-tsx"
  },
  ["vim-vinegar"] = {
    loaded = true,
    path = "/Users/penryu/.local/share/nvim/site/pack/packer/start/vim-vinegar",
    url = "https://github.com/tpope/vim-vinegar"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: auto-session
time([[Config for auto-session]], true)
try_loadstring("\27LJ\2\n�\1\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\2B\0\2\1K\0\1\0\31auto_session_suppress_dirs\1\4\0\0\a~/\16~/Downloads\6/\1\0\1\14log_level\twarn\nsetup\17auto-session\frequire\0", "config", "auto-session")
time([[Config for auto-session]], false)
-- Config for: lualine.nvim
time([[Config for lualine.nvim]], true)
try_loadstring("\27LJ\2\n�\4\0\0\a\0\29\0+6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0025\3\6\0=\3\a\0025\3\f\0005\4\b\0005\5\t\0005\6\n\0=\6\v\5>\5\3\4=\4\r\0034\4\3\0005\5\14\0>\5\1\4=\4\15\0035\4\16\0005\5\17\0005\6\18\0=\6\v\5>\5\2\4=\4\19\3=\3\20\0025\3\22\0005\4\21\0=\4\23\0034\4\0\0=\4\r\0034\4\0\0=\4\15\0034\4\0\0=\4\19\0035\4\24\0=\4\25\0035\4\26\0=\4\27\3=\3\28\2B\0\2\1K\0\1\0\ftabline\14lualine_z\1\2\0\0\vbranch\14lualine_y\1\2\0\0\ttabs\14lualine_a\1\0\0\1\2\0\0\fbuffers\rsections\14lualine_x\1\0\3\tunix\5\bmac\bmac\bdos\bdos\1\2\0\0\15fileformat\1\4\0\0\rencoding\0\rfiletype\14lualine_c\1\2\1\0\rfilename\tpath\3\1\14lualine_b\1\0\0\fsymbols\1\0\4\twarn\aW:\tinfo\aI:\nerror\aE:\thint\aH:\1\2\0\0\16diagnostics\1\3\0\0\vbranch\tdiff\foptions\1\0\2\17globalstatus\2\ntheme\vwombat\15extensions\1\0\0\1\5\0\0\rfugitive\bfzf\bman\rneo-tree\nsetup\flualine\frequire\0", "config", "lualine.nvim")
time([[Config for lualine.nvim]], false)
-- Config for: vim-json
time([[Config for vim-json]], true)
try_loadstring("\27LJ\2\n9\0\0\2\0\3\0\0056\0\0\0009\0\1\0+\1\2\0=\1\2\0K\0\1\0\28vim_json_syntax_conceal\6g\bvim\0", "config", "vim-json")
time([[Config for vim-json]], false)
-- Config for: coc.nvim
time([[Config for coc.nvim]], true)
try_loadstring("\27LJ\2\n�4\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0�4            \"\n            \" Helper functions\n            \"\n            function! CheckBackspace() abort\n               let col = col('.') - 1\n               return !col || getline('.')[col - 1] =~# '\\s'\n            endfunction\n            function! ShowDocumentation()\n               if CocAction('hasProvider', 'hover')\n                  call CocActionAsync('doHover')\n               else\n                  call feedkeys('K', 'in')\n               endif\n            endfunction\n\n            \" Tab to trigger completion with characters ahead and navigate.\n            inoremap <silent><expr> <Tab>\n               \\ coc#pum#visible() ? coc#pum#next(1):\n               \\ CheckBackspace() ? \"\\<Tab>\" :\n               \\ coc#refresh()\n\n            inoremap <expr><S-Tab> coc#pum#visible() ? coc#pum#prev(1) : \"\\<C-h>\"\n\n            \" Use <c-space> to trigger completion.\n            inoremap <silent><expr> <C-Space> coc#refresh()\n\n            \" Make <CR> to accept selected completion item or notify coc.nvim to format\n            \" <C-g>u breaks current undo, please make your own choice.\n            inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()\n               \\: \"\\<C-g>u\\<CR>\\<c-r>=coc#on_enter()\\<CR>\"\n\n            \" Use `[g` and `]g` to navigate diagnostics\n            nmap <silent> [g <Plug>(coc-diagnostic-prev)\n            nmap <silent> ]g <Plug>(coc-diagnostic-next)\n\n            \" Remap keys for gotos\n            nmap <silent> gd <Plug>(coc-definition)\n            nmap <silent> gi <Plug>(coc-implementation)\n            nmap <silent> gr <Plug>(coc-references)\n            nmap <silent> gy <Plug>(coc-type-definition)\n            nmap <silent> gD :call CocAction('jumpDefinition', 'split')<CR>\n            nmap <silent> gV :call CocAction('jumpDefinition', 'vsplit')<CR>\n            nmap <silent> gnt :call CocAction('jumpDefinition', 'tabe')<CR>\n\n            \" Use K to show documentation in preview window\n            nnoremap <silent> K :call ShowDocumentation()<CR>\n\n            \" Highlight the symbol and its references when holding the cursor.\n            autocmd CursorHold * silent call CocActionAsync('highlight')\n\n            \" Symbol renaming.\n            nmap <leader>rn <Plug>(coc-rename)\n\n            \" Formatting selected code.\n            xmap <leader>f  <Plug>(coc-format-selected)\n            nmap <leader>f  <Plug>(coc-format-selected)\n\n            augroup mygroup\n               autocmd!\n               \" Setup formatexpr specified filetype(s).\n               autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')\n               \" Update signature help on jump placeholder.\n               autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')\n            augroup end\n\n            \" Applying codeAction to the selected region.\n            \" Example: `<leader>aap` for current paragraph\n            xmap <leader>a  <Plug>(coc-codeaction-selected)\n            nmap <leader>a  <Plug>(coc-codeaction-selected)\n\n            \" Remap for applying codeAction to the current buffer.\n            nmap <leader>ac <Plug>(coc-codeaction)\n\n            \" Perform code lens action on current line\n            nmap <leader>cl <Plug>(coc-codelens-action)\n\n            \" Apply Autofix to problem on the current line.\n            nmap <leader>qf  <Plug>(coc-fix-current)\n\n            \" Map function and class text objects\n            \" NOTE: Requires 'textDocument.documentSymbol' support from language server\n            xmap if <Plug>(coc-funcobj-i)\n            omap if <Plug>(coc-funcobj-i)\n            xmap af <Plug>(coc-funcobj-a)\n            omap af <Plug>(coc-funcobj-a)\n            xmap ic <Plug>(coc-classobj-i)\n            omap ic <Plug>(coc-classobj-i)\n            xmap ac <Plug>(coc-classobj-a)\n            omap ac <Plug>(coc-classobj-a)\n\n            \" Remap <C-f> and <C-b> for scroll float windows/popups.\n            nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : \"\\<C-f>\"\n            nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : \"\\<C-b>\"\n            inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? \"\\<c-r>=coc#float#scroll(1)\\<cr>\" : \"\\<Right>\"\n            inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? \"\\<c-r>=coc#float#scroll(0)\\<cr>\" : \"\\<Left>\"\n            vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : \"\\<C-f>\"\n            vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : \"\\<C-b>\"\n\n            \" Use CTRL-S for selection ranges.\n            \" Requires 'textDocument/selectionRange' support of language server.\n            \" Example: coc-tsserver, coc-python\n            nmap <silent> <C-s> <Plug>(coc-range-select)\n            xmap <silent> <C-s> <Plug>(coc-range-select)\n\n            \" Add `:Format` to format current buffer\n            command! -nargs=0 Format :call CocActionAsync('format')\n\n            \" Use `:Fold` to fold current buffer\n            command! -nargs=? Fold :call CocAction('fold', <f-args>)\n\n            \" Add `:OR` command to organize import of current buffer.\n            command! -nargs=0 OR :call CocActionAsync('runCommand', 'editor.action.organizeImport')\n\n            \" Add native (Neo)Vim status line support.\n            \" See `:h coc-status` for integration with plugins with custom statusline:\n            set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}\n\n            \" Mappings for CocList\n            \" Show all diagnostics.\n            nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>\n            \" Manage extensions.\n            nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>\n            \" Show commands.\n            nnoremap <silent> <space>c  :<C-u>CocList commands<cr>\n            \" Find symbol of current document.\n            nnoremap <silent> <space>o  :<C-u>CocList outline<cr>\n            \" Search workspace symbols.\n            nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>\n            \" Do default action for next item.\n            nnoremap <silent> <space>j  :<C-u>CocNext<CR>\n            \" Do default action for previous item.\n            nnoremap <silent> <space>k  :<C-u>CocPrev<CR>\n            \" Resume latest coc list.\n            nnoremap <silent> <space>p  :<C-u>CocListResume<CR>\n\n            \" Bootstrap coc extensions\n            let g:coc_global_extensions = [\n               \\ 'coc-css',\n               \\ 'coc-eslint',\n               \\ 'coc-html',\n               \\ 'coc-json',\n               \\ 'coc-prettier',\n               \\ 'coc-pyright',\n               \\ 'coc-tsserver',\n               \\ 'coc-yaml',\n               \\ ]\n       \bcmd\bvim\0", "config", "coc.nvim")
time([[Config for coc.nvim]], false)
-- Config for: mkdnflow.nvim
time([[Config for mkdnflow.nvim]], true)
try_loadstring("\27LJ\2\nu\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\16perspective\1\0\0\1\0\2\14root_tell\rindex.md\rpriority\troot\nsetup\rmkdnflow\frequire\0", "config", "mkdnflow.nvim")
time([[Config for mkdnflow.nvim]], false)
-- Config for: apprentice.nvim
time([[Config for apprentice.nvim]], true)
try_loadstring("\27LJ\2\n:\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0\27colorscheme apprentice\bcmd\bvim\0", "config", "apprentice.nvim")
time([[Config for apprentice.nvim]], false)
-- Config for: vim-javascript
time([[Config for vim-javascript]], true)
try_loadstring("\27LJ\2\n9\0\0\2\0\3\0\0056\0\0\0009\0\1\0+\1\2\0=\1\2\0K\0\1\0\28javascript_plugin_jsdoc\6g\bvim\0", "config", "vim-javascript")
time([[Config for vim-javascript]], false)
-- Config for: tagbar
time([[Config for tagbar]], true)
try_loadstring("\27LJ\2\n|\0\0\5\0\b\0\r6\0\0\0'\2\1\0B\0\2\0029\0\2\0\18\1\0\0'\3\3\0'\4\4\0B\1\3\0016\1\5\0009\1\6\1)\2 \0=\2\a\1K\0\1\0\17tagbar_width\6g\bvim\22:TagbarToggle<cr>\14<Leader>t\tnmap\tkeys\frequire\0", "config", "tagbar")
time([[Config for tagbar]], false)
-- Config for: nvim-window-picker
time([[Config for nvim-window-picker]], true)
try_loadstring("\27LJ\2\n�\1\0\0\6\0\f\0\0156\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\t\0005\4\5\0005\5\4\0=\5\6\0045\5\a\0=\5\b\4=\4\n\3=\3\v\2B\0\2\1K\0\1\0\17filter_rules\abo\1\0\0\fbuftype\1\2\0\0\rterminal\rfiletype\1\0\0\1\5\0\0\rneo-tree\19neo-tree-popup\vnotify\rquickfix\1\0\3\20include_current\1\19autoselect_one\2\23other_win_hl_color\f#e35e4f\nsetup\18window-picker\frequire\0", "config", "nvim-window-picker")
time([[Config for nvim-window-picker]], false)
-- Config for: hexmode
time([[Config for hexmode]], true)
try_loadstring("\27LJ\2\nK\0\0\2\0\4\0\0056\0\0\0009\0\1\0'\1\3\0=\1\2\0K\0\1\0\29*.bin,*.exe,*.dat,*.wasm\21hexmode_patterns\6g\bvim\0", "config", "hexmode")
time([[Config for hexmode]], false)
-- Config for: neo-tree.nvim
time([[Config for neo-tree.nvim]], true)
try_loadstring("\27LJ\2\n�\18\0\0\a\0@\0_6\0\0\0009\0\1\0'\2\2\0B\0\2\0016\0\0\0009\0\3\0009\0\4\0'\2\5\0005\3\6\0B\0\3\0016\0\0\0009\0\3\0009\0\4\0'\2\a\0005\3\b\0B\0\3\0016\0\0\0009\0\3\0009\0\4\0'\2\t\0005\3\n\0B\0\3\0016\0\0\0009\0\3\0009\0\4\0'\2\v\0005\3\f\0B\0\3\0016\0\r\0'\2\14\0B\0\2\0029\0\15\0005\2\16\0005\3\18\0005\4\17\0=\4\19\0035\4\20\0=\4\21\0035\4\22\0=\4\23\0035\4\24\0=\4\25\0035\4\26\0=\4\27\0035\4\29\0005\5\28\0=\5\30\4=\4\31\3=\3 \0025\3!\0005\4\"\0=\4#\0035\4%\0005\5$\0=\5&\0045\5'\0005\6(\0=\6)\5=\5*\4=\4+\3=\3,\0024\3\0\0=\3-\0025\0033\0005\4.\0005\5/\0=\0050\0044\5\0\0=\0051\0044\5\0\0=\0052\4=\0044\0035\0046\0005\0055\0=\5+\4=\4,\3=\0037\0025\0038\0005\4:\0005\0059\0=\5+\4=\4,\3=\3;\0025\3>\0005\4<\0005\5=\0=\5+\4=\4,\3=\3\31\2B\0\2\0016\0\0\0009\0\1\0'\2?\0B\0\2\1K\0\1\0#nnoremap \\ :Neotree toggle<cr>\1\0\0\1\0\a\agg\24git_commit_and_push\agu\21git_unstage_file\agp\rgit_push\6A\16git_add_all\agc\15git_commit\agr\20git_revert_file\aga\17git_add_file\1\0\1\rposition\nfloat\fbuffers\1\0\0\1\0\3\abd\18buffer_delete\6.\rset_root\t<bs>\16navigate_up\1\0\1\18show_unloaded\2\15filesystem\1\0\0\1\0\6\n<c-x>\17clear_filter\6/\17fuzzy_finder\6.\rset_root\6f\21filter_on_submit\6H\18toggle_hidden\t<bs>\16navigate_up\19filtered_items\1\0\3\27use_libuv_file_watcher\1\26hijack_netrw_behavior\17open_default\24follow_current_file\2\15never_show\20hide_by_pattern\17hide_by_name\1\3\0\0\14.DS_Store\14thumbs.db\1\0\4\16hide_hidden\2\20hide_gitignored\2\18hide_dotfiles\2\fvisible\1\18nesting_rules\vwindow\rmappings\6a\vconfig\1\0\1\14show_path\tnone\1\2\0\0\badd\f<space>\1\0\18\6c\tcopy\6d\vdelete\6w\28open_with_window_picker\6A\18add_directory\6?\14show_help\6C\15close_node\6S\15open_split\t<cr>\topen\18<2-LeftMouse>\topen\6t\16open_tabnew\6R\frefresh\6s\16open_vsplit\6q\17close_window\6m\tmove\6p\25paste_from_clipboard\6x\21cut_to_clipboard\6y\22copy_to_clipboard\6r\vrename\1\2\1\0\16toggle_node\vnowait\1\20mapping_options\1\0\2\vnowait\2\fnoremap\2\1\0\2\rposition\tleft\nwidth\3(\30default_component_configs\15git_status\fsymbols\1\0\0\1\0\t\runstaged\b\fignored\b\14untracked\b\frenamed\b\fdeleted\b✖\nadded\5\rconflict\b\vstaged\b\rmodified\5\tname\1\0\3\26use_git_status_colors\2\19trailing_slash\1\14highlight\20NeoTreeFileName\rmodified\1\0\2\vsymbol\b[+]\14highlight\20NeoTreeModified\ticon\1\0\5\18folder_closed\b\14highlight\20NeoTreeFileIcon\17folder_empty\bﰊ\16folder_open\b\fdefault\6*\vindent\1\0\t\14highlight\24NeoTreeIndentMarker\23last_indent_marker\b└\18indent_marker\b│\17with_markers\2\fpadding\3\1\16indent_size\3\2\23expander_highlight\20NeoTreeExpander\22expander_expanded\b\23expander_collapsed\b\14container\1\0\0\1\0\1\26enable_character_fade\2\1\0\4\25close_if_last_window\1\23enable_diagnostics\2\22enable_git_status\2\23popup_border_style\frounded\nsetup\rneo-tree\frequire\1\0\2\vtexthl\23DiagnosticSignHint\ttext\b\23DiagnosticSignHint\1\0\2\vtexthl\23DiagnosticSignInfo\ttext\t \23DiagnosticSignInfo\1\0\2\vtexthl\23DiagnosticSignWarn\ttext\t \23DiagnosticSignWarn\1\0\2\vtexthl\24DiagnosticSignError\ttext\t \24DiagnosticSignError\16sign_define\afn0 let g:neo_tree_remove_legacy_commands = 1 \bcmd\bvim\0", "config", "neo-tree.nvim")
time([[Config for neo-tree.nvim]], false)
-- Config for: gitsigns.nvim
time([[Config for gitsigns.nvim]], true)
try_loadstring("\27LJ\2\n6\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\rgitsigns\frequire\0", "config", "gitsigns.nvim")
time([[Config for gitsigns.nvim]], false)
-- Load plugins in order defined by `after`
time([[Sequenced loading]], true)
vim.cmd [[ packadd rust.vim ]]

-- Config for: rust.vim
try_loadstring("\27LJ\2\n2\0\0\2\0\3\0\0056\0\0\0009\0\1\0)\1\1\0=\1\2\0K\0\1\0\21rustfmt_autosave\6g\bvim\0", "config", "rust.vim")

time([[Sequenced loading]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file ALEEnable lua require("packer.load")({'ale'}, { cmd = "ALEEnable", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
time([[Defining lazy-load commands]], false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType bash ++once lua require("packer.load")({'ale'}, { ft = "bash" }, _G.packer_plugins)]]
vim.cmd [[au FileType clojure ++once lua require("packer.load")({'ale'}, { ft = "clojure" }, _G.packer_plugins)]]
vim.cmd [[au FileType vim ++once lua require("packer.load")({'ale'}, { ft = "vim" }, _G.packer_plugins)]]
vim.cmd [[au FileType zsh ++once lua require("packer.load")({'ale'}, { ft = "zsh" }, _G.packer_plugins)]]
vim.cmd [[au FileType sh ++once lua require("packer.load")({'ale'}, { ft = "sh" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
vim.cmd("augroup END")
if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
