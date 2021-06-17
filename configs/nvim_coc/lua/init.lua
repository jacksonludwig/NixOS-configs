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
    'tpope/vim-fugitive',
    'tpope/vim-rhubarb',
  }

  use {
    'mkitt/tabline.vim',
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

-- Highlight on yank
vim.api.nvim_exec([[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]], false)

-------------------- MAPPINGS -------------------------------
vim.api.nvim_set_keymap('n', '<esc>', '<cmd>noh<CR>', { noremap = false, silent = true })

-------------------- THEME -------------------------------
vim.cmd('colorscheme OceanicNext')

