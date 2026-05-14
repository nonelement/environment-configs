-- Config
vim.opt.scrolloff = 2
vim.opt.number = true
-- neat feature, figure out how to make this work
vim.opt.relativenumber = false

vim.opt.wildmenu = true
vim.opt.wildmode = "list:longest"

vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.list = true
vim.opt.listchars = 'eol:¬,tab:▏ ,trail:•,nbsp:␣,'
-- vim.opt.listchars = 'eol:¬,tab:▏ ,trail:•,extends:»,precedes:«,nbsp:␣,'

vim.opt.signcolumn = "number"
vim.opt.autoread = true
vim.opt.colorcolumn = '120'
vim.opt.undofile = true
vim.opt.wrap = false

-- Figure out how to actually check this value
-- Currently this is defaulting to 'tmux'
-- if vim.fn.has_key(vim.fn.environ(), 'TMUX') then
--   vim.g.clipboard = 'tmux'
-- else
--   vim.g.clipboard = 'pbcopy'
-- end

-- Folding
vim.opt.foldmethod = indent

-- Used in conjunction with tmux color fix: https://github.com/sainnhe/everforest/blob/master/doc/everforest.txt#L547
if (vim.fn.has("termguicolors")) then
  vim.opt.termguicolors = true
end

-- Recommended by nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.mapleader = " "

-- Bindings
vim.keymap.set('', '<C-p>', "<cmd>lua require('fzf-lua').files()<cr>")
vim.keymap.set('', '<C-l>', "<cmd>lua require('fzf-lua').live_grep()<cr>")
vim.keymap.set('', '<C-e>', "<cmd>NvimTreeFocus<cr>")
vim.keymap.set('', '<leader>e', "<cmd>NvimTreeFindFile<cr>")
-- What does this do again?
vim.keymap.set('n', 'J', "<cmd>lua vim.diagnostic.open_float()<cr>")
-- Useful for paging through results of :vimgrep /pattern/ **/*
vim.keymap.set('', '<C-j>', "<cmd>cnext<cr>")
vim.keymap.set('', '<C-k>', "<cmd>cprev<cr>")
-- Malleable
vim.keymap.set('', '<leader>?', "<cmd>lua print(vim.lsp.log.get_filename())<cr>")

-- AutoCommands
vim.api.nvim_create_autocmd(
  'BufWritePre',
  {
    pattern = '*',
    command = [[:%s/\s\+$//e]]
  }
)

vim.api.nvim_create_autocmd(
  'TextYankPost',
  {
    pattern = '*',
    command = 'silent! lua vim.highlight.on_yank({ timeout = 500 })'
  }
)

-- Plugins
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins")

-- LSP
vim.lsp.log.set_level('debug')

-- Rust
-- install: rust-analyzer
vim.lsp.config('rust_analyzer', {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
      },
      imports = {
        group = {
          enable = false,
        },
      },
      completion = {
        postfix = {
          enable = false,
        },
      },
      -- checkOnSave = {
      --   command = "clippy"
      -- }
    },
  },
})
vim.lsp.enable('rust_analyzer')

-- Python
-- install: uv tool install basedpyright
vim.lsp.config('basedpyright', {
  cmd = { "basedpyright-langserver", "--stdio" },
  filetypes = { "python" },
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = "basic",
      },
    },
  },
})
--   settings = {
--     basedpyright = {
--       analysis = {
--         diagnosticSeverityOverrides = {
--           reportMissingParameterType = false,
--           reportUnknownParameterType = false,
--           reportUnknownArgumentType = false,
--           reportUnknownVariableType = false,
--           reportUnknownLambdaType = false,
--           reportUnknownMemberType = false,
--         }
--       }
--     }
--   },
vim.lsp.enable('basedpyright')


-- TS
-- install: npm i -g @typescript/native-preview
vim.lsp.config("ts_go_ls", {
    cmd = { vim.loop.os_homedir() .. "/.nvm/versions/node/v24.15.0/bin/tsgo", "--lsp", "--stdio" },
    filetypes = {
        "javascript",
        "javascriptreact",
        --"javascript.jsx",
        "typescript",
        "typescriptreact",
        --"typescript.tsx",
    },
    root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
})
vim.lsp.enable("ts_go_ls")


-- Spellcheck
vim.lsp.config('harper_ls', {
  cmd = { "harper-ls", "--stdio" },
  settings = {
    ["harper-ls"] = {
      linters = {
        SentenceCapitalization = false,
        OrthographicConsistency = false,
        SpellCheck = true,
      },
    },
  },
})
-- vim.lsp.enable('harper_ls')


require("catppuccin").setup()
vim.cmd.colorscheme "catppuccin"


