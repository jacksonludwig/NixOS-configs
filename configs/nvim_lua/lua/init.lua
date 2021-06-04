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
  use {'wbthomason/packer.nvim', opt = true}

  use {'tpope/vim-commentary'}

  use {'mhartington/oceanic-next'}

  use {
    'nvim-telescope/telescope.nvim',
    requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}},
    config = function() 
      vim.api.nvim_set_keymap('n', '<space><space>', '<cmd>lua require("telescope.builtin").find_files()<cr>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<space>fr', '<cmd>lua require("telescope.builtin").oldfiles()<cr>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<space>bb', '<cmd>lua require("telescope.builtin").buffers()<cr>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<space>sg', '<cmd>lua require("telescope.builtin").live_grep()<cr>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<space>ff', '<cmd>lua require("telescope.builtin").file_browser()<cr>', { noremap = true, silent = true })
    end
  }

  use {
    'hrsh7th/nvim-compe',
  }

  use {
    'jose-elias-alvarez/nvim-lsp-ts-utils',
  }

  use {
    'neovim/nvim-lspconfig',
  }

  use {
    'airblade/vim-rooter',
  }

  use {
    'rafamadriz/friendly-snippets'
  }

  use {
    'hrsh7th/vim-vsnip', 
    config = function() 

      -- use .ts snippets in .tsx files
      vim.g.vsnip_filetypes = {
        typescriptreact = {"typescript"}
      }

      vim.api.nvim_exec([[
      imap <expr> <C-l>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-l>'
      smap <expr> <C-l>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-l>'

      imap <expr> <C-j>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-j>'
      smap <expr> <C-j>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-j>'

      imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
      smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
      imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
      smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'

      nmap        s   <Plug>(vsnip-select-text)
      xmap        s   <Plug>(vsnip-select-text)
      nmap        S   <Plug>(vsnip-cut-text)
      xmap        S   <Plug>(vsnip-cut-text)
        ]], true)
    end
  }

  -- use {
  --   'hrsh7th/vim-vsnip-integ'
  -- }

  use { 'windwp/nvim-ts-autotag', 'JoosepAlviste/nvim-ts-context-commentstring' }

  use {
    'nvim-treesitter/nvim-treesitter', run = ':TSUpdate',
    config = function ()
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
        context_commentstring = {
          enable = true
        }
      }
    end
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
vim.cmd('set updatetime=100')
vim.cmd('set signcolumn=yes')

vim.o.mouse = 'a'
vim.wo.number = true
vim.wo.relativenumber = true
vim.o.completeopt = "menuone,noselect"

-------------------- autocmd -------------------------------
vim.api.nvim_exec([[
autocmd Filetype lua setlocal ts=2 sts=2 sw=2 et
autocmd Filetype vim setlocal ts=2 sts=2 sw=2 et
autocmd Filetype javascript setlocal ts=2 sts=2 sw=2 et
autocmd Filetype typescript setlocal ts=2 sts=2 sw=2 et
autocmd Filetype css setlocal ts=2 sts=2 sw=2
autocmd Filetype html setlocal ts=2 sts=2 sw=2
autocmd Filetype json setlocal ts=2 sts=2 sw=2
  ]], true)

-------------------- MAPPINGS -------------------------------
vim.api.nvim_set_keymap('n', '<esc>', '<cmd>noh<CR>', { noremap = false, silent = true })

-------------------- THEME -------------------------------
vim.cmd('colorscheme OceanicNext')

-------------------- COMPLETION -------------------------------
require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = false;

  source = {
    path = true;
    buffer = true;
    calc = false;
    vsnip = false;
    nvim_lsp = true;
    nvim_lua = true;
    spell = true;
    tags = false;
    snippets_nvim = false;
    treesitter = false;
  };
}
vim.api.nvim_exec([[
inoremap <silent><expr> <C-space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })
  ]], true)

------------------------ LSP --------------------------

local nvim_lsp = require("lspconfig")

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
  }
)

local on_attach = function(client, bufnr)
  local buf_map = vim.api.nvim_buf_set_keymap
  vim.cmd("command! LspDef lua require('telescope.builtin').lsp_definitions()")
  vim.cmd("command! LspFormatting lua vim.lsp.buf.formatting_sync()")
  vim.cmd("command! LspCodeAction lua require('telescope.builtin').lsp_code_actions()")
  vim.cmd("command! LspHover lua vim.lsp.buf.hover()")
  vim.cmd("command! LspRename lua vim.lsp.buf.rename()")
  vim.cmd("command! LspOrganize lua lsp_organize_imports()")
  vim.cmd("command! LspRefs lua require('telescope.builtin').lsp_references()")
  vim.cmd("command! LspTypeDef lua vim.lsp.buf.type_definition()")
  vim.cmd("command! LspImplementation lua vim.lsp.buf.implementation()")
  vim.cmd("command! LspDiagPrev lua vim.lsp.diagnostic.goto_prev()")
  vim.cmd("command! LspDiagNext lua vim.lsp.diagnostic.goto_next()")
  vim.cmd( "command! LspDiagLine lua vim.lsp.diagnostic.show_line_diagnostics()")
  vim.cmd("command! LspSignatureHelp lua vim.lsp.buf.signature_help()")
  buf_map(bufnr, "n", "gd", ":LspDef<CR>", {silent = true})
  buf_map(bufnr, "n", "<space>r", ":LspRename<CR>", {silent = true})
  buf_map(bufnr, "n", "gr", ":LspRefs<CR>", {silent = true})
  buf_map(bufnr, "n", "gy", ":LspTypeDef<CR>", {silent = true})
  buf_map(bufnr, "n", "K", ":LspHover<CR>", {silent = true})
  buf_map(bufnr, "n", "gs", ":LspOrganize<CR>", {silent = true})
  buf_map(bufnr, "n", "[d", ":LspDiagPrev<CR>", {silent = true})
  buf_map(bufnr, "n", "]d", ":LspDiagNext<CR>", {silent = true})
  buf_map(bufnr, "n", "ga", ":LspCodeAction<CR>", {silent = true})
  buf_map(bufnr, "n", "<space>d", ":LspDiagLine<CR>", {silent = true})
  buf_map(bufnr, "i", "<C-x><C-x>", "<cmd> LspSignatureHelp<CR>", {silent = true})
end

nvim_lsp.tsserver.setup {
  on_attach = function(client)
    on_attach(client)
    local ts_utils = require("nvim-lsp-ts-utils")

    -- defaults
    ts_utils.setup {
      debug = false,
      disable_commands = false,
      enable_import_on_completion = false,
      import_on_completion_timeout = 5000,

      -- eslint
      eslint_enable_code_actions = true,
      eslint_bin = "eslint_d",
      eslint_args = {"-f", "json", "--stdin", "--stdin-filename", "$FILENAME"},
      eslint_enable_disable_comments = true,

      -- experimental settings!
      -- eslint diagnostics
      eslint_enable_diagnostics = false,
      eslint_diagnostics_debounce = 250,

      -- formatting
      enable_formatting = true,
      formatter = "prettier",
      formatter_args = {"--stdin-filepath", "$FILENAME"},
      format_on_save = true,
      no_save_after_format = false,

      -- parentheses completion
      complete_parens = false,
      signature_help_in_parens = false,

      -- update imports on file move
      update_imports_on_move = false,
      require_confirmation_on_move = false,
      watch_dir = "/src",
    }

    -- required to enable ESLint code actions and formatting
    ts_utils.setup_client(client)

    -- no default maps, so you may want to define some here
    vim.api.nvim_buf_set_keymap(bufnr, "n", "tgs", ":TSLspOrganize<CR>", {silent = true})
    vim.api.nvim_buf_set_keymap(bufnr, "n", "tqq", ":TSLspFixCurrent<CR>", {silent = true})
    vim.api.nvim_buf_set_keymap(bufnr, "n", "tgr", ":TSLspRenameFile<CR>", {silent = true})
    vim.api.nvim_buf_set_keymap(bufnr, "n", "tgi", ":TSLspImportAll<CR>", {silent = true})
  end
}
