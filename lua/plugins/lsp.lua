--
-- rust plugins and settings
--

local u = require('util')

local lsp_callbacks

if pcall(require, 'telescope.builtin') then
  local ts_builtin = require('telescope.builtin')
  lsp_callbacks = {
    definitions = ts_builtin.lsp_definitions,
    document_symbols = ts_builtin.lsp_document_symbols,
    implementations = ts_builtin.lsp_implementations,
    references = ts_builtin.lsp_references,
    type_definitions = ts_builtin.lsp_type_definitions,
  }
else
  lsp_callbacks = {
    definitions = vim.lsp.buf.definition,
    document_symbols = vim.lsp.buf.document_symbol,
    implementations = vim.lsp.buf.implementation,
    references = vim.lsp.buf.references,
    type_definitions = vim.lsp.buf.type_definition,
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
  -- diagnostic
  keyset(
    'n',
    '<leader>e',
    function() vim.diagnostic.open_float(nil, { focusable = false }) end,
    key_opts
  )
  keyset('n', '<leader>q', vim.diagnostic.setloclist, key_opts)
  keyset('n', '[d', vim.diagnostic.goto_prev, key_opts)
  keyset('n', ']d', vim.diagnostic.goto_next, key_opts)

  u.create_command(
    'LspFormat',
    function() vim.lsp.buf.format { async = true } end,
    { nargs = 0 }
  )
end

return {
  -- NeoVIM LSP config

  -- Collection of common configurations for the Nvim LSP client
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      {
        'hrsh7th/nvim-cmp',
        dependencies = {
          'hrsh7th/cmp-buffer',
          'hrsh7th/cmp-path',
          'hrsh7th/cmp-vsnip',
          'hrsh7th/cmp-nvim-lsp',
        },
      },
      'nvim-lua/plenary.nvim',
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

      -- golang
      lspconfig.gopls.setup { on_attach = lsp_on_attach }

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
          FormatLua = {
            function() require('stylua-nvim').format_file() end,
          },
        },
        settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim', 'zfs' },
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
      'go',
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
    'stevearc/conform.nvim',
    config = function()
      require('conform').setup {
        format_on_save = function(bufnr)
          -- Disable with a global or buffer-local variable
          if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
          end
          return { timeout_ms = 2000, lsp_fallback = true }
        end,

        formatters = {
          comrak = {
            command = 'comrak',
            args = { '--width=72', '--to=commonmark' },
          },
        },
        formatters_by_ft = {
          markdown = { 'comrak' },
          javascript = { 'prettierd', 'prettier' },
          lua = { 'stylua' },
          python = { 'ruff_format' },
        },
      }
      u.create_command(
        'Format',
        function()
          require('conform').format { async = true, lsp_fallback = true }
        end,
        { nargs = 0 }
      )
      u.create_command('FormatDisable', function(args)
        if args.bang then
          -- FormatDisable! will disable formatting just for this buffer
          vim.b.disable_autoformat = true
        else
          vim.g.disable_autoformat = true
        end
      end, {
        desc = 'Disable autoformat-on-save',
        bang = true,
      })
      u.create_command('FormatEnable', function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
      end, {
        desc = 'Re-enable autoformat-on-save',
      })
    end,
    event = 'BufWritePre',
    cmd = { 'ConformInfo', 'Format', 'FormatDisable', 'FormatEnable' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_fallback = true }
        end,
        desc = 'Format buffer (conform)',
      },
    },
  },
  {
    -- Visualize lsp progress
    'j-hui/fidget.nvim',
    opts = {
      progress = {
        display = {
          skip_history = false,
        },
      },
    },
    event = 'LspAttach',
  },
  {
    'nvimdev/lspsaga.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('lspsaga').setup {
        code_action = {
          show_server_name = true,
        },
        lightbulb = {
          sign = true, -- show icon on left of line
          virtual_text = false, -- show icon on right of line
        },
        symbol_in_winbar = {
          color_mode = true,
          enable = true,
          show_file = true,
        },
      }
      u.create_command('Outline', 'Lspsaga outline', { nargs = 0 })
    end,
    event = 'LspAttach',
    cmd = 'Outline',
  },
  {
    'ray-x/go.nvim',
    dependencies = {
      'ray-x/guihua.lua',
      'neovim/nvim-lspconfig',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function() require('go').setup() end,
    -- event = 'CmdlineEnter',
    ft = { 'go', 'gomod' },
  },
  {
    'rust-lang/rust.vim',
    init = function() vim.g.rustfmt_autosave = 1 end,
    ft = 'rust',
  },
  {
    -- A heavily modified fork of rust-tools.nvim
    -- https://github.com/mrcjkb/rustaceanvim
    'mrcjkb/rustaceanvim',
    version = '^4', -- Recommended
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
    -- Can set `lazy = false` per https://github.com/mrcjkb/rustaceanvim/blob/master/README.md
    ft = 'rust',
  },
}
