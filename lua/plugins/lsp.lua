--
-- rust plugins and settings
--
-- Most settings from https://sharksforarms.dev/posts/neovim-rust/

local u = require('util')

-- local diag_float_grp = vim.api.nvim_create_augroup("DiagnosticFloat", { clear = true })

-- vim.api.nvim_create_autocmd("CursorHold", {
--    callback = function()
--       vim.diagnostic.open_float(nil, { focusable = false })
--    end,
--    group = diag_float_grp,
-- })

local lsp_callbacks

local has_ts, ts_builtin = pcall(function() require('telescope.builtin') end)
if has_ts and ts_builtin then
  lsp_callbacks = {
    definitions = ts_builtin.lsp_definitions,
    document_symbols = ts_builtin.lsp_document_symbols,
    implementations = ts_builtin.lsp_implementations,
    references = ts_builtin.lsp_references,
    type_definitions = ts_builtin.lsp_type_definitions,
    workspace_symbols = ts_builtin.lsp_workspace_symbols,
  }
else
  lsp_callbacks = {
    definitions = vim.lsp.buf.definition,
    document_symbols = vim.lsp.buf.document_symbol,
    implementations = vim.lsp.buf.implementation,
    references = vim.lsp.buf.references,
    type_definitions = vim.lsp.buf.type_definition,
    workspace_symbols = vim.lsp.buf.workspace_symbol,
  }
end

local function lsp_on_attach(client, bufnr)
  -- This callback is called when the LSP is atttached/enabled for this buffer
  -- we could set keymaps related to LSP, etc here.
  local key_opts = {
    buffer = bufnr,
    noremap = true,
    silent = true,
  }
  local keyset = vim.keymap.set

  require('lsp-inlayhints').on_attach(client, bufnr)

  -- Code navigation and shortcuts
  keyset('n', 'K', vim.lsp.buf.hover, key_opts)
  keyset('n', '<c-]>', vim.lsp.buf.definition, key_opts)
  keyset('n', 'gd', lsp_callbacks.definitions, key_opts)
  keyset('n', 'gD', vim.lsp.buf.declaration, key_opts)
  keyset('n', 'gi', lsp_callbacks.implementations, key_opts)
  keyset('i', '<c-k>', vim.lsp.buf.signature_help, key_opts)
  keyset('n', 'g0', lsp_callbacks.document_symbols, key_opts)
  keyset('n', 'gW', lsp_callbacks.workspace_symbols, key_opts)
  keyset('n', 'gr', lsp_callbacks.references, key_opts)
  keyset('n', '<leader>d', lsp_callbacks.type_definitions, key_opts)
  keyset('n', '<leader>rn', vim.lsp.buf.rename, key_opts)
  keyset('n', '<leader>ga', vim.lsp.buf.code_action, key_opts)
  keyset(
    'n',
    '<leader>qf',
    function()
      vim.lsp.buf.code_action {
        context = { only = { 'quickfix' } },
        apply = true,
      }
    end,
    key_opts
  )
  keyset(
    'n',
    '<leader>f',
    function() vim.lsp.buf.format { async = true } end,
    key_opts
  )
  -- workspace folders
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, key_opts)
  vim.keymap.set(
    'n',
    '<space>wr',
    vim.lsp.buf.remove_workspace_folder,
    key_opts
  )
  vim.keymap.set(
    'n',
    '<space>wl',
    function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
    key_opts
  )
  -- diagnostic
  keyset('n', '<leader>e', vim.diagnostic.open_float, key_opts)
  keyset('n', '<leader>q', vim.diagnostic.setloclist, key_opts)
  keyset('n', '[d', vim.diagnostic.goto_prev, key_opts)
  keyset('n', ']d', vim.diagnostic.goto_next, key_opts)
end

return {
  -- NeoVIM LSP config

  -- Collection of common configurations for the Nvim LSP client
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'hrsh7th/nvim-cmp',
      'hrsh7th/vim-vsnip',
      'nvimdev/lspsaga.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-lua/popup.nvim',
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      local cmp = require('cmp')
      local lspconfig = require('lspconfig')

      cmp.setup {
        preselect = cmp.PreselectMode.None,
        snippet = {
          expand = function(args) vim.fn['vsnip#anonymous'](args.body) end,
        },
        mapping = {
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-n>'] = cmp.mapping.select_next_item(),
          -- Add tab support
          ['<S-Tab>'] = cmp.mapping.select_prev_item(),
          ['<Tab>'] = cmp.mapping.select_next_item(),
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.close(),
          ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
          },
        },

        -- Installed sources
        sources = {
          { name = 'nvim_lsp' },
          { name = 'vsnip' },
          { name = 'path' },
          { name = 'buffer' },
        },
      }

      -- shell
      -- yarn global add bash-language-server
      lspconfig.bashls.setup {
        filetypes = { 'bash', 'sh', 'zsh' },
        on_attach = lsp_on_attach,
      }

      -- c/c++ et al.
      lspconfig.clangd.setup { on_attach = lsp_on_attach }

      -- clojure
      -- brew install clojure-lsp/brew/clojure-lsp-native
      lspconfig.clojure_lsp.setup { on_attach = lsp_on_attach }

      -- docker
      -- yarn global add dockerfile-language-server-nodejs
      lspconfig.dockerls.setup { on_attach = lsp_on_attach }
      -- yarn global add @microsoft/compose-language-service
      lspconfig.docker_compose_language_service.setup {}

      -- javascript and friends
      -- yarn global add vscode-langservers-extracted
      lspconfig.eslint.setup { on_attach = lsp_on_attach }
      -- yarn global add typescript typescript-language-server
      lspconfig.tsserver.setup { on_attach = lsp_on_attach }

      -- lua
      -- brew install lua-language-server
      lspconfig.lua_ls.setup {
        on_attach = lsp_on_attach,
        commands = {
          Format = {
            function() require('stylua-nvim').format_file() end,
          },
        },
        settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim' },
            },
            format = {
              defaultConfig = {
                indent_style = 'space',
                indent_size = 2,
              },
            },
          },
        },
      }
      lspconfig.fennel_ls.setup {}
      -- lspconfig.fennel_language_server.setup {}

      -- markdown
      -- https://github.com/artempyanykh/marksman/releases/
      lspconfig.marksman.setup { on_attach = lsp_on_attach }

      -- python
      -- pip install ruff-lsp
      lspconfig.pyright.setup { on_attach = lsp_on_attach }
      lspconfig.ruff_lsp.setup {
        init_options = {
          settings = {
            args = {},
          },
        },
        on_attach = function(client, bufnr)
          client.server_capabilities.hoverProvider = false
          lsp_on_attach(client, bufnr)
        end,
      }

      -- LaTeX
      -- cargo install --git https://github.com/latex-lsp/texlab \
      --    --locked --tag <insert version here>
      lspconfig.texlab.setup {}

      -- yarn
      -- yarn global add yaml-language-server
      lspconfig.yamlls.setup { on_attach = lsp_on_attach }
    end,
    ft = {
      'sh',
      'bash',
      'zsh',
      'c',
      'cpp',
      'clojure',
      'edn',
      'dockerfile',
      'fennel',
      'yaml.docker-compose',
      'javascript',
      'javascriptreact',
      'javascript.jsx',
      'typescript',
      'typescriptreact',
      'typescript.tsx',
      'lua',
      'markdown',
      'python',
      'rust',
      'tex',
      'bib',
      'plaintex',
      'yaml',
    },
  },
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-vsnip',
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function() end,
  },
  {
    -- Visualize lsp progress
    'j-hui/fidget.nvim',
    tag = 'legacy',
    event = 'LspAttach',
  },
  {
    'nvimdev/lspsaga.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    init = function() end,
    config = function()
      require('lspsaga').setup {
        symbol_in_winbar = {
          color_mode = true,
          enable = true,
        },
      }
      u.create_command('Outline', 'Lspsaga outline', { nargs = 0 })
    end,
    event = 'LspAttach',
    cmd = { 'Outline' },
  },
  {
    'prettier/vim-prettier',
    init = function()
      vim.g['prettier#autoformat_config_present'] = true
      vim.g['prettier#autoformat_require_pragma'] = false
    end,
    ft = {
      'javascript',
      'javascriptreact',
      'javascript.jsx',
      'typescript',
      'typescriptreact',
      'typescript.tsx',
    },
  },
  {
    'ckipp01/stylua-nvim',
    config = function()
      u.create_autocmd('BufWritePre', { pattern = '*.lua', command = 'Format' })
    end,
    ft = 'lua',
  },
  {
    -- A heavily modified fork of rust-tools.nvim
    -- https://github.com/mrcjkb/rustaceanvim
    'mrcjkb/rustaceanvim',
    version = '^3', -- Recommended
    dependencies = {
      'nvim-lua/plenary.nvim',
      'mfussenegger/nvim-dap',
      {
        'lvimuser/lsp-inlayhints.nvim',
        opts = {},
      },
    },
    config = function()
      vim.g.rustaceanvim = {
        inlay_hints = {
          auto = true,
          highlight = 'NonText',
          parameter_hints_prefix = '',
          show_parameter_hints = true,
        },
        server = {
          -- on_attach is a callback called when the language server attachs to the buffer
          on_attach = lsp_on_attach,
          settings = {
            -- to enable rust-analyzer settings visit:
            -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
            ['rust-analyzer'] = {
              cargo = { autoReload = true },
              check = {
                command = 'clippy',
                extraArgs = { '--no-deps', '--', '-Wclippy::pedantic' },
              },
              checkOnSave = {
                command = 'clippy',
                extraArgs = { '--no-deps', '--', '-Wclippy::pedantic' },
              },
              imports = {
                merge = { glob = false },
                prefix = 'crate',
              },
              inlayHints = {
                bindingModeHints = { enable = true },
                closingBraceHints = { minLines = 1 },
                closureReturnTypeHints = { enable = 'always' },
              },
              lens = {
                references = {
                  adt = { enable = true },
                  enumVariant = { enable = true },
                  method = { enable = true },
                  trait = { enable = true },
                },
              },
              rustfmt = {
                rangeFormatting = { enable = true },
              },
            },
          },
        },
        tools = {
          hover_actions = {
            auto_focus = true,
          },
        },
      }
    end,
    ft = 'rust',
  },
  {
    'rust-lang/rust.vim',
    init = function() vim.g.rustfmt_autosave = 1 end,
    ft = 'rust',
  },
  {
    'pangloss/vim-javascript',
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
    ft = { 'javascript', 'typescript' },
  },
  {
    'leafgarland/typescript-vim',
    ft = 'typescript',
  },
}
