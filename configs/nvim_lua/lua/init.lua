------------------ PACKER INSTALL --------------------------
local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
  execute 'packadd packer.nvim'
end

-------------------- PLUGINS -------------------------------
vim.cmd [[packadd packer.nvim]]
require('packer').startup(function ()
  use {
    'wbthomason/packer.nvim',
    opt = true,
  }

  use {
    'tpope/vim-commentary',
  }

  use {
    'mhartington/oceanic-next',
  }

  use {
    'nvim-telescope/telescope.nvim',
    requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}},

    config = function() 
      -- This disables tree-sitter highlighting in previewers. Workaround for slowness currently.
      local previewers = require('telescope.previewers')
      local putils = require('telescope.previewers.utils')
      local pfiletype = require('plenary.filetype')

      local new_maker = function(filepath, bufnr, opts)
        opts = opts or {}
        if opts.use_ft_detect == nil then
          local ft = pfiletype.detect(filepath)
          -- Here for example you can say: if ft == "xyz" then this_regex_highlighing else nothing end
          opts.use_ft_detect = false
          putils.regex_highlighter(bufnr, ft)
        end
        previewers.buffer_previewer_maker(filepath, bufnr, opts)
      end

      require('telescope').setup {
        defaults = {
          buffer_previewer_maker = new_maker,
        }
      }

      vim.api.nvim_set_keymap('n', '<space><space>', '<cmd>lua require("telescope.builtin").find_files()<cr>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<space>fr', '<cmd>lua require("telescope.builtin").oldfiles()<cr>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<space>bb', '<cmd>lua require("telescope.builtin").buffers()<cr>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<space>sg', '<cmd>lua require("telescope.builtin").live_grep()<cr>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<space>ff', '<cmd>lua require("telescope.builtin").file_browser()<cr>', { noremap = true, silent = true })
    end
  }

  use {
    'airblade/vim-rooter',
  }

  use {
    'neovim/nvim-lspconfig',
  }

  use {
    'hrsh7th/vim-vsnip',
  }

  use {
    'rafamadriz/friendly-snippets',
  }

  use {
    'hrsh7th/nvim-compe',
  }

  use {
    'jose-elias-alvarez/nvim-lsp-ts-utils',
  }

  use {
    'nvim-treesitter/nvim-treesitter', run = ':TSUpdate',
  }

  use {
    'windwp/nvim-ts-autotag',
  }

  use {
    'peitalin/vim-jsx-typescript',
  }

  use {
    'jose-elias-alvarez/null-ls.nvim',
  }

end)

-------------------- VARIABLES -------------------------------
vim.cmd('set undodir=$HOME/.config/nvim/undodir')
vim.cmd('set undofile')
vim.cmd('set hidden')
vim.cmd('set termguicolors')
vim.cmd('set splitright')
vim.cmd('set splitbelow')
vim.cmd('set nowrap')
vim.cmd('set signcolumn=yes')
vim.cmd('set tabstop=2')
vim.cmd('set shiftwidth=2')
vim.cmd('set expandtab')
vim.cmd('set pumheight=40')
vim.cmd('set number')
vim.cmd('set relativenumber')
vim.cmd('set mouse=a')

-------------------- MAPPINGS -------------------------------
vim.api.nvim_set_keymap('n', '<esc>', '<cmd>noh<CR>', { noremap = false, silent = true })

-------------------- THEME -------------------------------
vim.cmd('colorscheme OceanicNext')

------- LSP
local nvim_lsp = require("lspconfig")

local on_attach = function(client, bufnr)
  local buf_map = vim.api.nvim_buf_set_keymap
  vim.cmd("command! LspDef lua vim.lsp.buf.definition()")
  vim.cmd("command! LspFormatting lua vim.lsp.buf.formatting_sync()")
  vim.cmd("command! LspCodeAction lua vim.lsp.buf.code_action()")
  vim.cmd("command! LspHover lua vim.lsp.buf.hover()")
  vim.cmd("command! LspRename lua vim.lsp.buf.rename()")
  vim.cmd("command! LspOrganize lua lsp_organize_imports()")
  vim.cmd("command! LspRefs lua vim.lsp.buf.references()")
  vim.cmd("command! LspTypeDef lua vim.lsp.buf.type_definition()")
  vim.cmd("command! LspImplementation lua vim.lsp.buf.implementation()")
  vim.cmd("command! LspDiagPrev lua vim.lsp.diagnostic.goto_prev()")
  vim.cmd("command! LspDiagNext lua vim.lsp.diagnostic.goto_next()")
  vim.cmd("command! LspDiagLine lua vim.lsp.diagnostic.show_line_diagnostics()")
  vim.cmd("command! LspSignatureHelp lua vim.lsp.buf.signature_help()")
  buf_map(bufnr, "n", "gd", ":LspDef<CR>", {silent = true})
  buf_map(bufnr, "n", "<space>r", ":LspRename<CR>", {silent = true})
  buf_map(bufnr, "n", "gr", ":LspRefs<CR>", {silent = true})
  buf_map(bufnr, "n", "gy", ":LspTypeDef<CR>", {silent = true})
  buf_map(bufnr, "n", "K", ":LspHover<CR>", {silent = true})
  buf_map(bufnr, "n", "<space>o", ":LspOrganize<CR>", {silent = true})
  buf_map(bufnr, "n", "[d", ":LspDiagPrev<CR>", {silent = true})
  buf_map(bufnr, "n", "]d", ":LspDiagNext<CR>", {silent = true})
  buf_map(bufnr, "n", "<space>c", ":LspCodeAction<CR>", {silent = true})
  buf_map(bufnr, "n", "<space>d", ":LspDiagLine<CR>", {silent = true})
  buf_map(bufnr, "i", "<C-x><C-x>", "<cmd> LspSignatureHelp<CR>", {silent = true})
end

require('null-ls').setup {}

nvim_lsp.tsserver.setup {
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)

    -- disable tsserver formatting since formatting via null-ls
    client.resolved_capabilities.document_formatting = false

    local ts_utils = require("nvim-lsp-ts-utils")

    -- defaults
    ts_utils.setup {
      debug = false,
      disable_commands = false,
      enable_import_on_completion = false,

      -- eslint
      eslint_enable_code_actions = false,
      eslint_enable_disable_comments = true,
      eslint_bin = "eslint_d",
      eslint_config_fallback = nil,

      -- eslint diagnostics
      eslint_enable_diagnostics = false,
      eslint_diagnostics_debounce = 250,

      -- formatting
      enable_formatting = true,
      formatter = "prettier_d_slim",
      formatter_config_fallback = nil,

      -- parentheses completion
      complete_parens = false,
      signature_help_in_parens = false,

      -- update imports on file move
      update_imports_on_move = false,
      require_confirmation_on_move = false,
      watch_dir = nil,
    }

    -- required to enable ESLint code actions and formatting
    ts_utils.setup_client(client)

    -- format on save
    vim.cmd("autocmd BufWritePost <buffer> LspFormatting")

    vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>tq", ":TSLspFixCurrent<CR>", {silent = true})
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>tr", ":TSLspRenameFile<CR>", {silent = true})
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>to", ":TSLspOrganize<CR>", {silent = true})
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>ti", ":TSLspImportAll<CR>", {silent = true})
  end
}

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
  }
)

vim.lsp.handlers["textDocument/definition"] = require('telescope.builtin').lsp_definitions
vim.lsp.handlers["textDocument/references"] = require('telescope.builtin').lsp_references
vim.lsp.handlers["textDocument/codeAction"] = require('telescope.builtin').lsp_code_actions

-- COMP
-- use .ts snippets in .tsx files
vim.g.vsnip_filetypes = {
    typescriptreact = {"typescript"}
}

require"compe".setup {
    preselect = "always",
    source = {
        path = true,
        buffer = true,
        vsnip = false,
        nvim_lsp = true,
        nvim_lua = true
    }
}

local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

vim.api.nvim_set_keymap("i", "<C-Space>", "compe#complete()", {expr = true, silent = true})
vim.api.nvim_set_keymap("i", "<CR>", [[compe#confirm("<CR>")]], {expr = true, silent = true})
vim.api.nvim_set_keymap("i", "<C-e>", [[compe#close("<C-e>")]], {expr = true, silent = true})
vim.api.nvim_set_keymap("i", "<C-f>", [[compe#scroll({ 'delta': +4 })]], {expr = true, silent = true})
vim.api.nvim_set_keymap("i", "<C-d>", [[compe#scroll({ 'delta': -4 })]], {expr = true, silent = true})
vim.api.nvim_exec([[
" Expand
imap <expr> <C-k>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-k>'
smap <expr> <C-k>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-k>'

" Jump forward
imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-jump-next)' : '<C-l>'
smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-jump-next)' : '<C-l>'

" Jump backward
imap <expr> <C-j> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<C-l>'
smap <expr> <C-j> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<C-j>'
]], true)

-- TREESITTER
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained",
  highlight = {
    enable = false
  },
  indent = {
    enable = false
  },
  autotag = {
    enable = true
  },
}
