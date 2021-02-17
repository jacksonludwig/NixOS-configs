lua << EOF

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
    use {'LnL7/vim-nix'}
    use {'tpope/vim-commentary'}
    use {'dracula/vim'}
    use {'harenome/vim-mipssyntax'}

    use {
      'nvim-telescope/telescope.nvim',
      requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
    }
end)

-------------------- VARIABLES -------------------------------
vim.cmd('set undodir=$HOME/.config/nvim/undodir')
vim.cmd('set undofile')

vim.o.mouse = 'a'
vim.wo.number = true
vim.wo.relativenumber = true
vim.bo.expandtab = true
vim.g.syntax = true
vim.api.nvim_set_option("termguicolors", true) 

-------------------- THEME -------------------------------
vim.cmd('colorscheme dracula') -- Use dracula colorscheme

EOF
