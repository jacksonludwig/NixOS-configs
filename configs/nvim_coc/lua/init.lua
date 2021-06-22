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
    'peitalin/vim-jsx-typescript',
  }

  use {
    'neoclide/coc.nvim', branch = 'release',
  }

  use {
    'tjdevries/express_line.nvim',
    disable = false,
    config = function() 
      local builtin = require('el.builtin')
      local extensions = require('el.extensions')
      local sections = require('el.sections')
      local subscribe = require('el.subscribe')

      vim.opt.showmode = false

      local a = vim.api
      local hi = sections.highlight

      local coc_diag = function(_, buf, severity)
        local ok, res = pcall(a.nvim_buf_get_var, buf.bufnr, "coc_diagnostic_info")

        if ok then
          local count = res[severity]

          if count > 0 then
            return count > 0 and string.upper(string.format(" %s%s ", severity:sub(1, 1), count)) or ""
          end
        end
      end

      local coc_diag_wrapper = function(win, buf)
        local ei = "ElMiddleInactive"

        return {
          hi(
          {active = "CocListBlackGrey", inactive = ei},
          function(win, buf)
            return coc_diag(win, buf, "information")
          end
          ),
          hi(
          {active = "CocListBlackGrey", inactive = ei},
          function(win, buf)
            return coc_diag(win, buf, "hint")
          end
          ),
          hi(
          {active = "CocListBlackYellow", inactive = ei},
          function(win, buf)
            return coc_diag(win, buf, "warning")
          end
          ),
          hi(
          {active = "CocListBlackRed", inactive = ei},
          function(win, buf)
            return coc_diag(win, buf, "error")
          end
          )
        }
      end

      local git_icon = subscribe.buf_autocmd("el_file_icon", "BufRead", function(_, bufnr)
        local icon = extensions.file_icon(_, bufnr)
        if icon then
          return icon .. " "
        end

        return ""
      end)

      local git_branch = subscribe.buf_autocmd("el_git_branch", "BufEnter", function(window, buffer)
        local branch = extensions.git_branch(window, buffer)
        if branch then
          return " " .. extensions.git_icon() .. " " .. branch
        end
      end)

      local git_changes = subscribe.buf_autocmd("el_git_changes", "BufWritePost", function(window, buffer)
        return extensions.git_changes(window, buffer)
      end)

      require('el').setup{
        generator = function(win,buf)
          return {
            extensions.gen_mode {
              format_string = " %s ",
            },
            git_branch,
            " ",
            sections.split,
            git_icon,
            sections.maximum_width(builtin.responsive_file(140, 90), 0.30),
            sections.collapse_builtin {
              " ",
              builtin.modified_flag,
            },
            sections.split,
            coc_diag_wrapper(win, buf),
            git_changes,
            "[",
            builtin.line_with_width(3),
            ":",
            builtin.column_with_width(2),
            "]",
            sections.collapse_builtin {
              "[",
              builtin.help_list,
              builtin.readonly_list,
              "]",
            },
            builtin.filetype,
          }
        end
      }
    end
  }

  use {
    'hoob3rt/lualine.nvim',
    disable = true,
    config = function()
      require('lualine').setup {
        options = {
          theme = 'oceanicnext',
          icons_enabled = true,
          section_separators = { '', '' },
          component_separators = { '', '' },
        },
        sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {
            'branch',
            'filename'
          },
          lualine_x = {
            { 'diagnostics', sources = { 'coc' }, symbols = {error = '•', warn = '•', info = '•', hint = '•'} },
            { 'g:coc_status', 'bo:filetype' },
            'filetype',
            'progress',
            'location'
          },
          lualine_y = {},
          lualine_z = {}
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {'filename'},
          lualine_x = {'location'},
          lualine_y = {},
          lualine_z = {}
        },
        tabline = {},
        extensions = {}
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
vim.cmd('set signcolumn=yes')
vim.cmd('set tabstop=2')
vim.cmd('set shiftwidth=2')
vim.cmd('set expandtab')
vim.cmd('set number')
vim.cmd('set relativenumber')
vim.cmd('set mouse=a')
vim.cmd('set completeopt=menuone,noselect,noinsert')

vim.opt.foldmethod = 'marker'
vim.opt.foldlevel = 0
vim.opt.modelines = 1

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
require('colorbuddy').colorscheme('gruvbuddy')

