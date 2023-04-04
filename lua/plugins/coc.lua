--
-- coc plugins and settings
--
return {
   {
      'pangloss/vim-javascript',
      ft = 'javascript',
      init = function()
         vim.g.javascript_plugin_jsdoc = true
         vim.g.javascript_conceal_function = 'ƒ'
         vim.g.javascript_conceal_null = 'ø'
         vim.g.javascript_conceal_this = '@'
         vim.g.javascript_conceal_return = '⇚'
         vim.g.javascript_conceal_undefined = '¿'
         vim.g.javascript_conceal_NaN = 'ℕ'
         vim.g.javascript_conceal_prototype = '¶'
         vim.g.javascript_conceal_static = '•'
         vim.g.javascript_conceal_super = 'Ω'
         vim.g.javascript_conceal_arrow_function = '⇒'
         vim.g.javascript_conceal_noarg_arrow_function = '🞅'
         vim.g.javascript_conceal_underscore_arrow_function = '🞅'
      end,
   },
   { 'leafgarland/typescript-vim', ft = 'typescript' },
   {
      -- coc-based rust support, semi-official?
      'rust-lang/rust.vim',
      dependencies = 'neoclide/coc.nvim',
      init = function() vim.g.rustfmt_autosave = 1 end,
      ft = 'rust',
   },
   {
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
               \ 'coc-db',
               \ 'coc-diagnostic',
               \ 'coc-docker',
               \ 'coc-eslint',
               \ 'coc-go',
               \ 'coc-html',
               \ 'coc-json',
               \ 'coc-lua',
               \ 'coc-prettier',
               \ 'coc-pyright',
               \ 'coc-rust-analyzer',
               \ 'coc-stylua',
               \ 'coc-tsserver',
               \ 'coc-yaml',
               \ ]
         ]]
      end,
      cmd = {
         'CocCommand',
         'CocConfig',
         'CocDiagnostics',
         'CocEnable',
         'CocInstall',
         'CocList',
         'CocOpenLog',
         'CocOutline',
         'CocStart',
         'CocSearch',
         'CocUpdate',
      },
      ft = {
         'bash',
         'c',
         'cpp',
         'css',
         'dockerfile',
         'go',
         'html',
         'javascript',
         'json',
         'lua',
         'markdown',
         'python',
         'sh',
         'typescript',
         'vim',
         'yaml',
         'zsh',
      },
   },
}
