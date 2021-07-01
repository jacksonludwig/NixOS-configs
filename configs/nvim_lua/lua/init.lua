------------------ PACKER INSTALL --------------------------
local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end

-------------------- PLUGINS -------------------------------
local packer = require('packer')

packer.init({
  luarocks = {
    python_cmd = 'python3'
  }
})

packer.startup(function ()
  use {
    'wbthomason/packer.nvim',
  }

  use {
    'LnL7/vim-nix',
  }

  use {
    'tpope/vim-commentary',
    'tpope/vim-fugitive',
    'tpope/vim-rhubarb',
  }

  use {
    'arzg/vim-colors-xcode',
  }

  use {
    'tjdevries/gruvbuddy.nvim',
    requires = { 'tjdevries/colorbuddy.nvim' },
  }

  use {
    'nvim-lua/popup.nvim',
    'nvim-lua/plenary.nvim',
    'kyazdani42/nvim-web-devicons',
  }

  use {
    'nvim-telescope/telescope.nvim',
    disable = false,
    config = function() 
      require('telescope').setup {
        defaults = {
          file_previewer = require('telescope.previewers').cat.new,
          grep_previewer = require('telescope.previewers').vimgrep.new,
        }
      }

      vim.api.nvim_set_keymap('n', '<space><space>', '<cmd>lua require("telescope.builtin").find_files()<cr>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<space>fr', '<cmd>lua require("telescope.builtin").oldfiles()<cr>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<space>bb', '<cmd>lua require("telescope.builtin").buffers()<cr>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<space>g', '<cmd>lua require("telescope.builtin").live_grep()<cr>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<space>ff', '<cmd>lua require("telescope.builtin").file_browser()<cr>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<space>vc', '<cmd>lua require("telescope.builtin").git_commits()<cr>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<space>vb', '<cmd>lua require("telescope.builtin").git_branches()<cr>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<space>vs', '<cmd>lua require("telescope.builtin").git_status()<cr>', { noremap = true, silent = true })
    end
  }

  use {
    'airblade/vim-rooter',
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    requires = {'JoosepAlviste/nvim-ts-context-commentstring'},
    run = ':TSUpdate',
    config = function()
      require'nvim-treesitter.configs'.setup {
        ensure_installed = "maintained",
        highlight = {
          enable = true,
          disable = {"typescript", "typescriptreact"}
        },
        indent = {
          enable = false
        },
        context_commentstring = {
          enable = true
        }
      }
    end
  }

  use {
    'neovim/nvim-lspconfig',
    requires = { 'jose-elias-alvarez/nvim-lsp-ts-utils', 'jose-elias-alvarez/null-ls.nvim' },
    config = function()
      local nvim_lsp = require("lspconfig")

      local on_attach_common = function(client, bufnr)
        local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
        local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

        --Enable completion triggered by <c-x><c-o>
        buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings.
        local opts = { noremap=true, silent=true }

        -- See `:help vim.lsp.*` for documentation on any of the below functions
        buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
        buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
        buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
        buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
        buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
        buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
        buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
        buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
        buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
        buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
        buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
        buf_set_keymap('n', '<space>d', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
        buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
        buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
        buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
        buf_set_keymap("n", "<space>z", "<cmd>lua vim.lsp.buf.formatting_sync()<CR>", opts)
      end

      require("null-ls").setup {}

      nvim_lsp.tsserver.setup {
        on_attach = function(client, bufnr)
          on_attach_common(client, bufnr)

          -- disable tsserver formatting 
          client.resolved_capabilities.document_formatting = false

          local ts_utils = require("nvim-lsp-ts-utils")

          -- defaults
          ts_utils.setup {
            debug = false,
            disable_commands = false,
            enable_import_on_completion = true,
            import_all_timeout = 5000, -- ms

            -- eslint
            eslint_enable_code_actions = true,
            eslint_enable_disable_comments = true,
            eslint_bin = "eslint_d",
            eslint_config_fallback = nil,
            eslint_enable_diagnostics = true,

            -- formatting
            enable_formatting = true,
            formatter = "eslint_d",
            formatter_config_fallback = nil,

            -- parentheses completion
            complete_parens = false,
            signature_help_in_parens = false,

            -- update imports on file move
            update_imports_on_move = false,
            require_confirmation_on_move = false,
            watch_dir = nil,
          }

          -- required to fix code action ranges
          ts_utils.setup_client(client)

          -- format on save
          vim.cmd("autocmd BufWritePost <buffer> lua vim.lsp.buf.formatting_sync()")

          -- no default maps, so you may want to define some here
          vim.api.nvim_buf_set_keymap(bufnr, "n", "tor", ":TSLspOrganize<CR>", {silent = true})
          vim.api.nvim_buf_set_keymap(bufnr, "n", "tqf", ":TSLspFixCurrent<CR>", {silent = true})
          vim.api.nvim_buf_set_keymap(bufnr, "n", "trn", ":TSLspRenameFile<CR>", {silent = true})
          vim.api.nvim_buf_set_keymap(bufnr, "n", "tia", ":TSLspImportAll<CR>", {silent = true})
        end,
        flags = {
          debounce_text_changes = 150,
        },
       }

       vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
         vim.lsp.diagnostic.on_publish_diagnostics, {
           virtual_text = false,
         }
       )

    end
  }

  use {
    'cohama/lexima.vim',
    requires = { 'hrsh7th/nvim-compe' },
    config = function()
      require'compe'.setup {
        enabled = true;
        autocomplete = true;
        debug = false;
        min_length = 1;
        preselect = 'disable';
        throttle_time = 80;
        source_timeout = 200;
        resolve_timeout = 800;
        incomplete_delay = 400;
        max_abbr_width = 100;
        max_kind_width = 100;
        max_menu_width = 100;
        documentation = true;

        source = {
          path = true;
          buffer = true;
          calc = true;
          nvim_lsp = true;
          nvim_lua = true;
          -- vsnip = true;
        };
      }

      vim.cmd([[
      let g:lexima_no_default_rules = v:true
      call lexima#set_default_rules()
      inoremap <silent><expr> <C-Space> compe#complete()
      inoremap <silent><expr> <CR>      compe#confirm(lexima#expand('<LT>CR>', 'i'))
      inoremap <silent><expr> <C-e>     compe#close('<C-e>')
      inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
      inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })
      ]])
    end
  }

end)

-------------------- VARIABLES -------------------------------
local opt = vim.opt

opt.undofile = true
opt.hidden = true
opt.termguicolors = true
opt.splitright = true
opt.splitbelow = true
opt.wrap = false
opt.signcolumn = "yes"
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.number = true
opt.relativenumber = true
opt.mouse = 'a'
opt.completeopt = { 'menuone', 'noselect' }
opt.foldmethod = 'marker'
opt.foldlevel = 0
opt.modelines = 1

-- Highlight on yank
vim.api.nvim_exec([[
augroup YankHighlight
autocmd!
autocmd TextYankPost * silent! lua vim.highlight.on_yank()
augroup end
]],
false)

-- autocmd for theme stuff
vim.api.nvim_exec([[
function SetColors()
  :hi VertSplit guibg=NONE
  :hi SignColumn guibg=bg
  :hi LineNr guibg=bg
endfunction

augroup minimal_theme
autocmd!
autocmd ColorScheme * call SetColors()
augroup END
]],
false)

-------------------- MAPPINGS -------------------------------
vim.api.nvim_set_keymap('n', '<esc>', '<cmd>noh<CR>', { noremap = false, silent = true })

-------------------- THEME -------------------------------
require('colorbuddy').colorscheme('gruvbuddy')
