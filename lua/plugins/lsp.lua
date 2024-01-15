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

local function lsp_on_attach(client, buffer)
  -- This callback is called when the LSP is atttached/enabled for this buffer
  -- we could set keymaps related to LSP, etc here.
  local keymap_opts = { buffer = buffer }
  local keyset = vim.keymap.set

  require('lsp-inlayhints').on_attach(client, buffer)

  -- Code navigation and shortcuts
  keyset('n', 'K', vim.lsp.buf.hover, keymap_opts)
  keyset('n', '<c-]>', vim.lsp.buf.definition, keymap_opts)
  keyset('n', 'gd', vim.lsp.buf.definition, keymap_opts)
  keyset('n', 'gD', vim.lsp.buf.implementation, keymap_opts)
  keyset('n', '1gD', vim.lsp.buf.type_definition, keymap_opts)
  keyset('i', '<c-k>', vim.lsp.buf.signature_help, keymap_opts)
  keyset('n', 'g0', vim.lsp.buf.document_symbol, keymap_opts)
  keyset('n', 'gW', vim.lsp.buf.workspace_symbol, keymap_opts)
  keyset('n', 'ga', vim.lsp.buf.code_action, keymap_opts)
  keyset('n', 'gr', vim.lsp.buf.references, keymap_opts)
  -- prev/next diagnostic
  keyset('n', '[g', vim.diagnostic.goto_prev, keymap_opts)
  keyset('n', ']g', vim.diagnostic.goto_next, keymap_opts)
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
                indent_size = 3,
              },
            },
          },
        },
      }

      -- markdown
      -- https://github.com/artempyanykh/marksman/releases/
      lspconfig.marksman.setup { on_attach = lsp_on_attach }

      -- python
      lspconfig.pyright.setup { on_attach = lsp_on_attach }

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
    command = { 'Outline' },
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
