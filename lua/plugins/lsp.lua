--
-- rust plugins and settings
--

local u = require('util')

local lsp_callbacks = {
  code_action = vim.lsp.buf.code_action,
  code_format = function() vim.lsp.buf.format { async = true } end,
  curr_diag = function() vim.diagnostic.open_float(nil, { focusable = false }) end,
  goto_prev = function() vim.diagnostic.jump { count = -1, float = true } end,
  goto_next = function() vim.diagnostic.jump { count = 1, float = true } end,
  quick_fix = function()
    vim.lsp.buf.code_action {
      context = { only = { 'quickfix' } },
      apply = true,
    }
  end,
}

if pcall(require, 'telescope.builtin') then
  local ts_builtin = require('telescope.builtin')
  lsp_callbacks.definitions = ts_builtin.lsp_definitions
  lsp_callbacks.document_symbols = ts_builtin.lsp_document_symbols
  lsp_callbacks.implementations = ts_builtin.lsp_implementations
  lsp_callbacks.references = ts_builtin.lsp_references
  lsp_callbacks.type_definitions = ts_builtin.lsp_type_definitions
else
  lsp_callbacks.definitions = vim.lsp.buf.definition
  lsp_callbacks.document_symbols = vim.lsp.buf.document_symbol
  lsp_callbacks.implementations = vim.lsp.buf.implementation
  lsp_callbacks.references = vim.lsp.buf.references
  lsp_callbacks.type_definitions = vim.lsp.buf.type_definition
end

local function lsp_on_attach(client, bufnr)
  -- Called when the LSP is atttached/enabled for this buffer.
  -- Can set keymaps related to LSP, etc here.
  local key_opts = {
    buffer = bufnr,
    noremap = true,
    silent = true,
  }

  vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

  local function _map(mode, key, cmd, opts)
    opts = vim.tbl_extend('keep', opts or {}, key_opts)
    return u.keymapset(mode, key, cmd, vim.tbl_extend('keep', opts, key_opts))
  end
  local lsp_nmap = function(...) return _map('n', ...) end
  local lsp_imap = function(...) return _map('i', ...) end

  -- override code_action only for rust filetypes
  if vim.bo.filetype == 'rust' then
    lsp_callbacks.code_action = function() vim.cmd.RustLsp('codeAction') end
  end

  -- Code navigation and shortcuts
  lsp_nmap('<leader>rn', vim.lsp.buf.rename, { desc = 'LSP rename' })
  lsp_nmap('K', vim.lsp.buf.hover, { desc = 'LSP hover' })
  lsp_imap('<c-k>', vim.lsp.buf.signature_help, { desc = 'LSP signature' })
  lsp_nmap('gD', vim.lsp.buf.declaration, { desc = 'LSP declarations' })
  lsp_nmap('gd', lsp_callbacks.definitions, { desc = 'LSP definitions' })
  lsp_nmap(
    'gi',
    lsp_callbacks.implementations,
    { desc = 'LSP implementations' }
  )
  lsp_nmap(
    'g0',
    lsp_callbacks.document_symbols,
    { desc = 'LSP document symbols' }
  )
  lsp_nmap('gr', lsp_callbacks.references, { desc = 'LSP references' })
  lsp_nmap(
    '<leader>d',
    lsp_callbacks.type_definitions,
    { desc = 'LSP type definitions' }
  )

  -- diagnostic
  lsp_nmap(
    '<leader>e',
    lsp_callbacks.curr_diag,
    { desc = 'LSP diagnostic under cursor' }
  )
  lsp_nmap('[d', lsp_callbacks.goto_prev, { desc = 'LSP previous diagnostic' })
  lsp_nmap(']d', lsp_callbacks.goto_next, { desc = 'LSP next diagnostic' })
  lsp_nmap('<leader>gl', vim.diagnostic.setloclist, { desc = 'Show loclist' })

  -- code actions
  lsp_nmap(
    '<leader>ga',
    lsp_callbacks.code_action,
    { desc = 'lsp code action' }
  )
  lsp_nmap('<leader>gq', lsp_callbacks.quick_fix, { desc = 'lsp quickfix' })

  u.create_command('LspFormat', lsp_callbacks.code_format, { nargs = 0 })
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

      -- deno
      -- brew install deno
      lspconfig.denols.setup { on_attach = lsp_on_attach }

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
      -- lspconfig.ts_ls.setup { on_attach = lsp_on_attach }

      lspconfig.kotlin_language_server.setup { on_attach = lsp_on_attach }

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

      -- mojo
      lspconfig.mojo.setup {}

      -- python
      -- pip install ruff
      lspconfig.pyright.setup {
        on_attach = lsp_on_attach,
        settings = {
          python = {
            venvPath = vim.env.HOME .. '/.pyenv/versions',
          },
        },
      }
      lspconfig.ruff.setup {
        -- init_options = {
        --   settings = {
        --     args = {},
        --   },
        -- },
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
      -- 'clojure',
      -- 'edn',
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
      'mojo',
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
          ktlint = {
            command = 'ktlint',
            args = { '--format' },
          },
        },
        formatters_by_ft = {
          clojure = { 'joker' },
          javascript = { 'prettierd', 'prettier' },
          kotlin = { 'ktfmt', 'ktlint' },
          markdown = { 'comrak' },
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
    'nvimdev/lspsaga.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('lspsaga').setup {
        code_action = {
          extend_gitsigns = true,
          show_server_name = true,
        },
        lightbulb = {
          sign = false, -- show icon on left of line
          virtual_text = false, -- show icon on right of line
        },
        outline = {
          win_width = 42,
        },
        symbol_in_winbar = {
          color_mode = true,
          enable = true,
          folder_level = 0,
          hide_keyword = false,
          separator = '  ',
          show_file = true,
        },
      }
      u.create_command('Outline', 'Lspsaga outline', { nargs = 0 })
    end,
    event = 'LspAttach',
    cmd = 'Outline',
  },
  {
    'mawkler/refjump.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    opts = {
      highlights = {
        enable = false,
      },
    },
    keys = { ']r', '[r' }, -- Uncomment to lazy load
  },
  {
    -- This plugin _seems_ to be unnecessary... but keeping for now
    'rust-lang/rust.vim',
    init = function() vim.g.rustfmt_autosave = 0 end,
    ft = 'rust',
  },
  {
    -- A heavily modified fork of rust-tools.nvim
    -- https://github.com/mrcjkb/rustaceanvim
    'mrcjkb/rustaceanvim',
    version = '^5', -- Recommended
    dependencies = {
      'nvim-lua/plenary.nvim',
      'mfussenegger/nvim-dap',
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
                extraArgs = {
                  '--no-deps',
                  '--',
                  '-Wclippy::all',
                  '-Wclippy::pedantic',
                },
              },
              checkOnSave = {
                command = 'clippy',
                extraArgs = {
                  '--no-deps',
                  '--',
                  '-Wclippy::all',
                  '-Wclippy::pedantic',
                },
              },
              imports = { merge = { glob = false }, prefix = 'crate' },
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
              rustfmt = { rangeFormatting = { enable = true } },
            },
          },
        },
        tools = { hover_actions = { auto_focus = true } },
      }
    end,
    -- Can set `lazy = false` per https://github.com/mrcjkb/rustaceanvim/blob/master/README.md
    ft = 'rust',
  },
}
