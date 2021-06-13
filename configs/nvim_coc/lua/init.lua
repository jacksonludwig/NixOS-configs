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
    'tpope/vim-commentary',
  }

  use {
    'mhartington/oceanic-next',
  }

  use {
    'nvim-lua/popup.nvim',
    'nvim-lua/plenary.nvim'
  }

  use {
    'nvim-telescope/telescope.nvim',
    disable = false,
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
      vim.api.nvim_set_keymap('n', '<space>g', '<cmd>lua require("telescope.builtin").live_grep()<cr>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<space>ff', '<cmd>lua require("telescope.builtin").file_browser()<cr>', { noremap = true, silent = true })
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
          enable = false
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
    'peitalin/vim-jsx-typescript',
  }

  use {
    'neoclide/coc.nvim', branch = 'release',
  }

  use { 
    "rcarriga/vim-ultest",
    disable = true,
    requires = {"vim-test/vim-test"},
    run = ":UpdateRemotePlugins",
    config = function()
      vim.g.ultest_use_pty = 1
      vim.g.ultest_output_on_line = 0
      vim.api.nvim_set_keymap('n', '<space>tf', '<Plug>(ultest-next-fail)', { noremap = false, silent = true })
      vim.api.nvim_set_keymap('n', '<space>tb', '<Plug>(ultest-prev-fail)', { noremap = false, silent = true })
      vim.api.nvim_set_keymap('n', '<space>tn', '<Plug>(ultest-run-nearest)', { noremap = false, silent = true })
      vim.api.nvim_set_keymap('n', '<space>tt', '<Plug>(ultest-run-file)', { noremap = false, silent = false })
      vim.api.nvim_set_keymap('n', '<space>ts', '<Plug>(ultest-summary-toggle)', { noremap = false, silent = true })
      vim.api.nvim_set_keymap('n', '<space>to', '<Plug>(ultest-output-show)', { noremap = false, silent = true })
      vim.api.nvim_set_keymap('n', '<space>tj', '<Plug>(ultest-output-jump)', { noremap = false, silent = true })
      vim.api.nvim_set_keymap('n', '<space>tx', '<Plug>(ultest-stop-file)', { noremap = false, silent = true })
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
vim.cmd('set signcolumn=yes')
vim.cmd('set tabstop=2')
vim.cmd('set shiftwidth=2')
vim.cmd('set expandtab')
vim.cmd('set number')
vim.cmd('set relativenumber')
vim.cmd('set mouse=a')
vim.cmd('set completeopt=menuone,noselect')

-------------------- MAPPINGS -------------------------------
vim.api.nvim_set_keymap('n', '<esc>', '<cmd>noh<CR>', { noremap = false, silent = true })

-------------------- THEME -------------------------------
vim.cmd('colorscheme OceanicNext')

