-- Bootstrap packer from the internet if it's not here already!
local install_path = vim.fn.stdpath 'data'
   .. '/site/pack/packer/start/packer.nvim'

local packer_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
   packer_bootstrap = vim.fn.execute(
      '!git clone --depth 1 git@github.com:wbthomason/packer.nvim '
         .. install_path
   )
end

-- Automatically recompile this file after writing it.
vim.api.nvim_create_autocmd('BufWritePost', {
   pattern = 'plugins.lua',
   command = 'source <afile> | PackerCompile',
   group = vim.api.nvim_create_augroup('PackerUserConfig', {}),
})

vim.cmd [[packadd packer.nvim]]

return require('packer').startup {
   function(use)
      use 'wbthomason/packer.nvim'

      -- Alternative to coc. See if we can move stuff to coc or built-in LSP
      use {
         'dense-analysis/ale',
         cmd = 'ALEEnable',
         config = function()
            vim.cmd [[ALEEnable]]
         end,
         ft = { 'bash', 'clojure', 'sh', 'vim', 'zsh' },
      }

      -- Updated apprentice colorscheme
      use {
         'adisen99/apprentice.nvim',
         requires = { 'rktjmp/lush.nvim' },
         config = function()
            vim.cmd 'colorscheme apprentice'
         end,
      }

      -- Automatically restores sessions if no arguments given
      use {
         'rmagatti/auto-session',
         config = function()
            require('auto-session').setup {
               log_level = 'warn',
               auto_session_suppress_dirs = { '~/', '~/Downloads', '/' },
            }
         end,
      }

      -- Still the quickest way to clean up buffers
      use {
         'jeetsukumaran/vim-buffergator',
         config = function()
            vim.cmd [[
            let g:buffergator_autodismiss_on_select = 0
            let g:buffergator_autoupdate = 1
            let g:buffergator_display_regime = 'parentdir'
            let g:buffergator_hsplit_size = 7
            let g:buffergator_show_full_directory_path = 0
            let g:buffergator_viewport_split_policy = 'B'
            let g:buffergator_vsplit_size = 42
         ]]
         end,
      }

      use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }

      -- Better viz of git line diffs
      use {
         'lewis6991/gitsigns.nvim',
         config = function()
            require('gitsigns').setup()
         end,
      }

      use {
         'fidian/hexmode',
         config = function()
            vim.g.hexmode_patterns = '*.bin,*.exe,*.dat,*.wasm'
         end,
      }

      use {
         'nvim-neo-tree/neo-tree.nvim',
         branch = 'v2.x',
         requires = {
            'nvim-lua/plenary.nvim',
            'kyazdani42/nvim-web-devicons', -- not strictly required, but recommended
            'MunifTanjim/nui.nvim',
            {
               -- only needed if you want to use the commands with "_with_window_picker" suffix
               's1n7ax/nvim-window-picker',
               tag = '1.*',
               config = function()
                  require('window-picker').setup {
                     autoselect_one = true,
                     include_current = false,
                     filter_rules = {
                        -- filter using buffer options
                        bo = {
                           -- if the file type is one of following, the window will be ignored
                           filetype = {
                              'neo-tree',
                              'neo-tree-popup',
                              'notify',
                              'quickfix',
                           },

                           -- if the buffer type is one of following, the window will be ignored
                           buftype = { 'terminal' },
                        },
                     },
                     other_win_hl_color = '#e35e4f',
                  }
               end,
            },
         },
         config = function()
            -- Unless you are still migrating, remove the deprecated commands from v1.x
            vim.cmd [[ let g:neo_tree_remove_legacy_commands = 1 ]]

            -- If you want icons for diagnostic errors, you'll need to define them somewhere:
            vim.fn.sign_define(
               'DiagnosticSignError',
               { text = ' ', texthl = 'DiagnosticSignError' }
            )
            vim.fn.sign_define(
               'DiagnosticSignWarn',
               { text = ' ', texthl = 'DiagnosticSignWarn' }
            )
            vim.fn.sign_define(
               'DiagnosticSignInfo',
               { text = ' ', texthl = 'DiagnosticSignInfo' }
            )
            vim.fn.sign_define(
               'DiagnosticSignHint',
               { text = '', texthl = 'DiagnosticSignHint' }
            )
            -- NOTE: this is changed from v1.x, which used the old style of highlight groups
            -- in the form "LspDiagnosticsSignWarning"

            require('neo-tree').setup {
               close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
               popup_border_style = 'rounded',
               enable_git_status = true,
               enable_diagnostics = true,
               default_component_configs = {
                  container = {
                     enable_character_fade = true,
                  },
                  indent = {
                     indent_size = 2,
                     padding = 1, -- extra padding on left hand side
                     -- indent guides
                     with_markers = true,
                     indent_marker = '│',
                     last_indent_marker = '└',
                     highlight = 'NeoTreeIndentMarker',
                     -- expander config, needed for nesting files
                     with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
                     expander_collapsed = '',
                     expander_expanded = '',
                     expander_highlight = 'NeoTreeExpander',
                  },
                  icon = {
                     folder_closed = '',
                     folder_open = '',
                     folder_empty = 'ﰊ',
                     -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
                     -- then these will never be used.
                     default = '*',
                     highlight = 'NeoTreeFileIcon',
                  },
                  modified = {
                     symbol = '[+]',
                     highlight = 'NeoTreeModified',
                  },
                  name = {
                     trailing_slash = false,
                     use_git_status_colors = true,
                     highlight = 'NeoTreeFileName',
                  },
                  git_status = {
                     symbols = {
                        -- Change type
                        added = '✚', -- or "✚", but this is redundant info if you use git_status_colors on the name
                        modified = '', -- or "", but this is redundant info if you use git_status_colors on the name
                        deleted = '✖', -- this can only be used in the git_status source
                        renamed = '', -- this can only be used in the git_status source
                        -- Status type
                        untracked = '',
                        ignored = '',
                        unstaged = '',
                        staged = '',
                        conflict = '',
                     },
                  },
               },
               window = {
                  position = 'left',
                  width = 40,
                  mapping_options = {
                     noremap = true,
                     nowait = true,
                  },
                  mappings = {
                     ['<space>'] = {
                        'toggle_node',
                        nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use.
                     },
                     ['<2-LeftMouse>'] = 'open',
                     ['<cr>'] = 'open',
                     ['S'] = 'open_split',
                     ['s'] = 'open_vsplit',
                     -- ["S"] = "split_with_window_picker",
                     -- ["s"] = "vsplit_with_window_picker",
                     ['t'] = 'open_tabnew',
                     ['w'] = 'open_with_window_picker',
                     ['C'] = 'close_node',
                     ['a'] = {
                        'add',
                        -- some commands may take optional config options, see `:h neo-tree-mappings` for details
                        config = {
                           show_path = 'none', -- "none", "relative", "absolute"
                        },
                     },
                     ['A'] = 'add_directory', -- also accepts the config.show_path option.
                     ['d'] = 'delete',
                     ['r'] = 'rename',
                     ['y'] = 'copy_to_clipboard',
                     ['x'] = 'cut_to_clipboard',
                     ['p'] = 'paste_from_clipboard',
                     ['c'] = 'copy', -- takes text input for destination
                     ['m'] = 'move', -- takes text input for destination
                     ['q'] = 'close_window',
                     ['R'] = 'refresh',
                     ['?'] = 'show_help',
                  },
               },
               nesting_rules = {},
               filesystem = {
                  filtered_items = {
                     visible = false, -- when true, they will just be displayed differently than normal items
                     hide_dotfiles = true,
                     hide_gitignored = true,
                     hide_hidden = true, -- only works on Windows for hidden files/directories
                     hide_by_name = {
                        '.DS_Store',
                        'thumbs.db',
                        --"node_modules"
                     },
                     hide_by_pattern = { -- uses glob style patterns
                        --"*.meta"
                     },
                     never_show = { -- remains hidden even if visible is toggled to true
                        --".DS_Store",
                        --"thumbs.db"
                     },
                  },
                  follow_current_file = true, -- This will find and focus the file in the active buffer every
                  -- time the current file is changed while the tree is open.
                  hijack_netrw_behavior = 'open_default', -- netrw disabled, opening a directory opens neo-tree
                  -- in whatever position is specified in window.position
                  -- "open_current",   -- netrw disabled, opening a directory opens within the
                  -- window like netrw would, regardless of window.position
                  -- "disabled",      -- netrw left alone, neo-tree does not handle opening dirs
                  use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
                  -- instead of relying on nvim autocmd events.
                  window = {
                     mappings = {
                        ['<bs>'] = 'navigate_up',
                        ['.'] = 'set_root',
                        ['H'] = 'toggle_hidden',
                        ['/'] = 'fuzzy_finder',
                        ['f'] = 'filter_on_submit',
                        ['<c-x>'] = 'clear_filter',
                     },
                  },
               },
               buffers = {
                  show_unloaded = true,
                  window = {
                     mappings = {
                        ['bd'] = 'buffer_delete',
                        ['<bs>'] = 'navigate_up',
                        ['.'] = 'set_root',
                     },
                  },
               },
               git_status = {
                  window = {
                     position = 'float',
                     mappings = {
                        ['A'] = 'git_add_all',
                        ['gu'] = 'git_unstage_file',
                        ['ga'] = 'git_add_file',
                        ['gr'] = 'git_revert_file',
                        ['gc'] = 'git_commit',
                        ['gp'] = 'git_push',
                        ['gg'] = 'git_commit_and_push',
                     },
                  },
               },
            }

            vim.cmd [[nnoremap \ :Neotree toggle<cr>]]
            -- see `:help bar` if you're curious
            vim.cmd [[nnoremap <bar> :Neotree git_status<cr>]]
         end,
      }
      use 'kovisoft/paredit'
      use {
         'preservim/tagbar',
         config = function()
            local nmap = require('keys').nmap
            nmap('<Leader>ta', ':TagbarToggle<cr>')
            vim.g.tagbar_width = 32
         end,
      }
      use 'ntpeters/vim-better-whitespace'
      use 'tpope/vim-commentary'
      use { 'tpope/vim-dispatch', requires = 'radenling/vim-dispatch-neovim' }
      use 'tpope/vim-fugitive'
      use 'sheerun/vim-polyglot'
      use 'machakann/vim-sandwich'
      use 'tpope/vim-vinegar'
      use {
         'liuchengxu/vista.vim',
         config = function()
            local nmap = require('keys').nmap
            vim.g.vista_default_executive = 'coc'
            nmap('<Leader>tv', ':Vista!!<cr>')
         end,
      }

      use {
         -- original fzf
         -- 'junegunn/fzf.vim', requires = 'junegunn/fzf',
         -- drop-in replacement (same config) for fzf using skim (sk)
         'lotabout/skim.vim',
         requires = 'lotabout/skim',
         config = function()
            -- vim.g.fzf_command_prefix = 'Sk'
         end,
      }

      use {
         'jakewvincent/mkdnflow.nvim',
         requires = 'ellisonleao/glow.nvim',
         config = function()
            require('mkdnflow').setup {
               perspective = {
                  priority = 'root',
                  root_tell = 'index.md',
               },
            }
         end,
      }

      use {
         'neoclide/coc.nvim',
         branch = 'release',
         config = function()
            vim.cmd [[
            "
            " Helper functions
            "
            function! CheckBackspace() abort
               let col = col('.') - 1
               return !col || getline('.')[col - 1] =~# '\s'
            endfunction
            function! ShowDocumentation()
               if CocAction('hasProvider', 'hover')
                  call CocActionAsync('doHover')
               else
                  call feedkeys('K', 'in')
               endif
            endfunction

            " Tab to trigger completion with characters ahead and navigate.
            inoremap <silent><expr> <Tab>
               \ coc#pum#visible() ? coc#pum#next(1):
               \ CheckBackspace() ? "\<Tab>" :
               \ coc#refresh()

            inoremap <expr><S-Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

            " Use <c-space> to trigger completion.
            inoremap <silent><expr> <C-Space> coc#refresh()

            " Make <CR> to accept selected completion item or notify coc.nvim to format
            " <C-g>u breaks current undo, please make your own choice.
            inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
               \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

            " Use `[g` and `]g` to navigate diagnostics
            nmap <silent> [g <Plug>(coc-diagnostic-prev)
            nmap <silent> ]g <Plug>(coc-diagnostic-next)

            " Remap keys for gotos
            nmap <silent> gd <Plug>(coc-definition)
            nmap <silent> gi <Plug>(coc-implementation)
            nmap <silent> gr <Plug>(coc-references)
            nmap <silent> gy <Plug>(coc-type-definition)
            nmap <silent> gD :call CocAction('jumpDefinition', 'split')<CR>
            nmap <silent> gV :call CocAction('jumpDefinition', 'vsplit')<CR>
            nmap <silent> gnt :call CocAction('jumpDefinition', 'tabe')<CR>

            " Use K to show documentation in preview window
            nnoremap <silent> K :call ShowDocumentation()<CR>

            " Highlight the symbol and its references when holding the cursor.
            autocmd CursorHold * silent call CocActionAsync('highlight')

            " Symbol renaming.
            nmap <leader>rn <Plug>(coc-rename)

            " Formatting selected code.
            xmap <leader>f  <Plug>(coc-format-selected)
            nmap <leader>f  <Plug>(coc-format-selected)

            augroup mygroup
               autocmd!
               " Setup formatexpr specified filetype(s).
               autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
               " Update signature help on jump placeholder.
               autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
            augroup end

            " Applying codeAction to the selected region.
            " Example: `<leader>aap` for current paragraph
            xmap <leader>a  <Plug>(coc-codeaction-selected)
            nmap <leader>a  <Plug>(coc-codeaction-selected)

            " Remap for applying codeAction to the current buffer.
            nmap <leader>ac <Plug>(coc-codeaction)

            " Perform code lens action on current line
            nmap <leader>cl <Plug>(coc-codelens-action)

            " Apply Autofix to problem on the current line.
            nmap <leader>qf  <Plug>(coc-fix-current)

            " Map function and class text objects
            " NOTE: Requires 'textDocument.documentSymbol' support from language server
            xmap if <Plug>(coc-funcobj-i)
            omap if <Plug>(coc-funcobj-i)
            xmap af <Plug>(coc-funcobj-a)
            omap af <Plug>(coc-funcobj-a)
            xmap ic <Plug>(coc-classobj-i)
            omap ic <Plug>(coc-classobj-i)
            xmap ac <Plug>(coc-classobj-a)
            omap ac <Plug>(coc-classobj-a)

            " Remap <C-f> and <C-b> for scroll float windows/popups.
            nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
            nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
            inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
            inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
            vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
            vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

            " Use CTRL-S for selection ranges.
            " Requires 'textDocument/selectionRange' support of language server.
            " Example: coc-tsserver, coc-python
            nmap <silent> <C-s> <Plug>(coc-range-select)
            xmap <silent> <C-s> <Plug>(coc-range-select)

            " Add `:Format` to format current buffer
            command! -nargs=0 Format :call CocActionAsync('format')

            " Use `:Fold` to fold current buffer
            command! -nargs=? Fold :call CocAction('fold', <f-args>)

            " Add `:OR` command to organize import of current buffer.
            command! -nargs=0 OR :call CocActionAsync('runCommand', 'editor.action.organizeImport')

            " Add native (Neo)Vim status line support.
            " See `:h coc-status` for integration with plugins with custom statusline:
            set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

            " Mappings for CocList
            " Show all diagnostics.
            nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
            " Manage extensions.
            nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
            " Show commands.
            nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
            " Find symbol of current document.
            nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
            " Search workspace symbols.
            nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
            " Do default action for next item.
            nnoremap <silent> <space>j  :<C-u>CocNext<CR>
            " Do default action for previous item.
            nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
            " Resume latest coc list.
            nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

            " Bootstrap coc extensions
            let g:coc_global_extensions = [
               \ 'coc-clangd',
               \ 'coc-css',
               \ 'coc-docker',
               \ 'coc-eslint',
               \ 'coc-html',
               \ 'coc-json',
               \ 'coc-lua',
               \ 'coc-prettier',
               \ 'coc-pyright',
               \ 'coc-stylua',
               \ 'coc-tsserver',
               \ 'coc-yaml',
               \ ]
       ]]
         end,
      }

      -- JavaScript/TypeScript
      use {
         'elzr/vim-json',
         config = function()
            vim.g.vim_json_syntax_conceal = true
         end,
      }
      use {
         'pangloss/vim-javascript',
         config = function()
            vim.g.javascript_plugin_jsdoc = true
         end,
      }
      use 'leafgarland/typescript-vim'
      use 'ianks/vim-tsx'

      -- Rust
      use {
         'rust-lang/rust.vim',
         after = 'coc.nvim',
         config = function()
            vim.g.rustfmt_autosave = 1
         end,
      }

      -- incremental parsing for syntax highlighting among others
      use {
         'nvim-treesitter/nvim-treesitter',
         requires = {
            -- Additional textobjects for treesitter.
            'nvim-treesitter/nvim-treesitter-textobjects',
         },
      }

      use {
         'nvim-lualine/lualine.nvim',
         config = function()
            require('lualine').setup {
               extensions = {
                  'fugitive',
                  'fzf',
                  'man',
                  'neo-tree',
               },
               options = {
                  globalstatus = true,
                  icons_enabled = false,
                  -- theme = 'everforest',
                  -- theme = 'gruvbox',
                  theme = 'wombat',
               },
               sections = {
                  lualine_b = {
                     'branch',
                     'diff',
                     {
                        'diagnostics',
                        symbols = {
                           error = 'E:',
                           warn = 'W:',
                           info = 'I:',
                           hint = 'H:',
                        },
                     },
                  },
                  lualine_c = { { 'filename', path = 1 } },
                  lualine_x = {
                     'encoding',
                     {
                        'fileformat',
                        symbols = { dos = 'dos', mac = 'mac', unix = '' },
                     },
                     'filetype',
                  },
               },
               tabline = {
                  lualine_a = { 'buffers' },
                  lualine_b = {},
                  lualine_c = {},
                  lualine_x = {},
                  lualine_y = { 'tabs' },
                  lualine_z = { 'branch' },
               },
            }
         end,
      }

      if packer_bootstrap then
         require('packer').sync()
      end
   end,
   config = {
      display = {
         open_fn = require('packer.util').float,
      },
   },
}
