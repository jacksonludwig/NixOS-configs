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

  use {
    'mhartington/oceanic-next', 
    config = function() 
      vim.g.oceanic_next_terminal_bold = 1
      vim.g.oceanic_next_terminal_italic = 1
    end
  }

  use { 'benknoble/vim-mips' }

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
    'mhartington/formatter.nvim',
    config = function()
      require('formatter').setup({
        logging = false,
        filetype = {
          javascript = {
            -- prettier
            function()
              return {
                exe = "prettier",
                args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0), '--single-quote'},
                stdin = true
              }
            end
          },
        }
      })
      -- stuff to format on save
      vim.api.nvim_exec([[
      augroup FormatAutogroup
      autocmd!
      autocmd BufWritePost *.js FormatWrite
      augroup END
        ]], true)
    end
  }

  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    },
    config = function() require('gitsigns').setup() end
  }

  use {'hoob3rt/lualine.nvim', 
    disable = false,
    config = function() 
      local lualine = require "lualine"
      local oceanic_next = require('jackson.oceanic_next.statusline')
      lualine.setup({
        sections = {
          lualine_a = {""},
          lualine_b = {"branch"},
          lualine_c = {"filename"},
          lualine_x = {"b:gitsigns_status"},
          lualine_y = {"filetype"},
          lualine_z = {
            "location",
            {
              "diagnostics",
              sources = {"nvim_lsp"},
              symbols = {error = "•", warn = "•", info = "•"}
            }
          }
        },
        options = {
          theme = oceanic_next,
          section_separators = '',
          component_separators = '',
        }
      }) 
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
    'rafamadriz/friendly-snippets'
  }

  use {
    'hrsh7th/vim-vsnip', 
    config = function() 
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

  use {'airblade/vim-rooter'}

  use {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup({
        'css';
        'javascript';
      })
    end
  }

  use { 'windwp/nvim-ts-autotag', 'JoosepAlviste/nvim-ts-context-commentstring' }

  use {
    'nvim-treesitter/nvim-treesitter', run = ':TSUpdate',
    config = function ()
      require'nvim-treesitter.configs'.setup {
        ensure_installed = "maintained",
        highlight = {
          enable = true
        },
        indent = {
          enable = true
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
vim.g.syntax = true
vim.o.completeopt = "menuone,noselect"
vim.g.tex_flavor = "latex"

-------------------- THEME -------------------------------
vim.cmd('colorscheme OceanicNext')

-------------------- autocmd -------------------------------
vim.api.nvim_exec([[
autocmd Filetype lua setlocal ts=2 sts=2 sw=2 et
autocmd Filetype vim setlocal ts=2 sts=2 sw=2 et
autocmd Filetype javascript setlocal ts=2 sts=2 sw=2 et
autocmd Filetype css setlocal ts=2 sts=2 sw=2
autocmd Filetype html setlocal ts=2 sts=2 sw=2
autocmd Filetype json setlocal ts=2 sts=2 sw=2
autocmd Filetype asm setlocal filetype=mips
  ]], true)

-------------------- MAPPINGS -------------------------------
vim.api.nvim_set_keymap('n', '<esc>', '<cmd>noh<CR>', { noremap = false, silent = true })

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
    vsnip = true;
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


-------------------- LSP -------------------------------
local nvim_lsp = require('lspconfig')
local on_attach = function(client, bufnr)
  print("LSP started: " .. client.name)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>Telescope lsp_definitions<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>Telescope lsp_references<CR>', opts)
  buf_set_keymap('n', '<space>d', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>sw', '<cmd>Telescope lsp_dynamic_workspace_symbols<CR>', opts)
  buf_set_keymap('n', '<space>sd', '<cmd>Telescope lsp_document_symbols<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>Telescope lsp_code_actions<CR>', opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<space>=", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("n", "<space>=", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end

end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
    signs = true,
    update_in_insert = false,
  }
)

-- Use a loop to conveniently both setup defined servers 
-- and map buffer local keybindings when the language server attaches
local servers = { "pyright", "gopls", "texlab" }
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    capabilities = capabilities,
    on_attach = on_attach,
  }
end

-- Servers that need extra config
-- tsserver
local tsserver_on_attach = function(client, bufnr)
  on_attach(client, bufnr)
  require("nvim-lsp-ts-utils").setup({})
end
nvim_lsp.tsserver.setup({
  capabilities = capabilities,
  on_attach = tsserver_on_attach,
})
