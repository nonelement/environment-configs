return {
  {
    'nonelement/floatingtodo.nvim',
    config = function()
      require("floatingtodo").setup({ target_file = "~/todo.md" })
      vim.keymap.set("n", "<leader>td", ":Td<CR>", {silent = true})
    end
  },
  {
    'sainnhe/everforest',
    lazy = false,
    priority = 1000,
    config = function ()
      vim.g.everforest_background = 'hard'
      vim.g.everforest_transparent_background = 1
      vim.g.everforest_disable_terminal_colors = 1
      vim.cmd([[colorscheme everforest]])
    end,
  },
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local actions = require("fzf-lua.actions")
      require("fzf-lua").setup({
        winopts = {
          backdrop = 100,
          preview = {
            vertical = 'down:20%',
          }
        },
      })
    end
  },
  {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local function custom_bindings(bufnr)
        local api = require("nvim-tree.api")

        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end
        -- default mappings
        api.config.mappings.default_on_attach(bufnr)

        -- custom mappings
        vim.keymap.set('n', 't', api.node.open.tab, opts('Open: New tab'))
        vim.keymap.del('n', '<C-t>', { buffer = bufnr })
      end
      require("nvim-tree").setup({
        on_attach = custom_bindings,
        actions = { open_file = { window_picker = { enable = false } } },
        git = { enable = false, ignore = false }
      })
    end,
  }, {
    'itchyny/lightline.vim',
    lazy = false,
    config = function()
      -- vim.o.showmode = false
      vim.g.lightline = {
        colorscheme = 'wombat',
        active = {
          left = {
            { 'mode', 'paste' },
            { 'readonly', 'filename', 'modified' }
          },
          right = {
            { 'lineinfo' },
            { 'percent' },
            { 'fileencoding', 'filetype' }
          },
        },
        component_function = {
          filename = 'LightlineFilename'
        },
      }
      function LightlineFilenameInLua(opts)
        if vim.fn.expand('%:t') == '' then
          return '[Not Saved]'
        else
          return vim.fn.getreg('%')
        end
      end
      -- https://github.com/itchyny/lightline.vim/issues/657
      vim.api.nvim_exec(
        [[
          function! g:LightlineFilename()
          return v:lua.LightlineFilenameInLua()
          endfunction
        ]],
      true
      )
    end
  },
  {
    "hrsh7th/nvim-cmp",
    -- load cmp on InsertEnter
    event = "InsertEnter",
    -- these dependencies will only be loaded when cmp loads
    -- dependencies are always lazy-loaded unless specified otherwise
    dependencies = {
      'neovim/nvim-lspconfig',
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    config = function()
      local cmp = require('cmp')
      cmp.setup({
        snippet = {
          -- REQUIRED by nvim-cmp. get rid of it once we can
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-k>'] = cmp.mapping.scroll_docs(-4),
          ['<C-j>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          -- Accept currently selected item.
          -- Set `select` to `false` to only confirm explicitly selected items.
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
        }, {
          { name = 'path' },
        }),
        experimental = {
          ghost_text = true,
        },
      })

      -- Enable completing paths in :
      cmp.setup.cmdline(':', {
        sources = cmp.config.sources({
          { name = 'path' }
        })
      })
    end
  }
}
