lua << EOF

vim.g.vimsyn_embed = 'l'

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
    use {'NLKNguyen/papercolor-theme'}

    use {'LnL7/vim-nix'}
    use {'harenome/vim-mipssyntax'}

    use {
      'nvim-telescope/telescope.nvim',
      requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
    }

		use { 'neoclide/coc.nvim', branch = 'release' }
    use {'mattn/emmet-vim'}

    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
end)

-------------------- VARIABLES -------------------------------
vim.cmd('set undodir=$HOME/.config/nvim/undodir')
vim.cmd('set undofile')
vim.cmd('set hidden')
vim.cmd('set termguicolors')
vim.cmd('set list')

vim.o.mouse = 'a'
vim.wo.number = true
vim.wo.relativenumber = true
vim.g.syntax = true
vim.o.completeopt = "menuone,noselect"

-------------------- THEME -------------------------------
--vim.cmd('set background=light')
vim.cmd('colorscheme PaperColor')

-------------------- autocmd -------------------------------
vim.cmd('autocmd Filetype lua setlocal ts=2 sts=2 sw=2')
vim.cmd('autocmd Filetype vim setlocal ts=2 sts=2 sw=2')
vim.cmd('autocmd Filetype javascript setlocal ts=2 sts=2 sw=2')
vim.cmd('autocmd Filetype css setlocal ts=2 sts=2 sw=2')

-------------------- MAPPINGS -------------------------------
vim.api.nvim_set_keymap('n', '<space><space>', '<cmd>lua require("telescope.builtin").find_files()<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<space>fr', '<cmd>lua require("telescope.builtin").oldfiles()<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<space>bb', '<cmd>lua require("telescope.builtin").buffers()<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<space>sg', '<cmd>lua require("telescope.builtin").live_grep()<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<space>ff', '<cmd>lua require("telescope.builtin").file_browser()<cr>', { noremap = true, silent = true })

-------------------- TREESITTER -------------------------------
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = false;
  },
  indent = {
		enable = false;
  }
}
EOF

" COC
set nobackup
set nowritebackup
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" COC extensions:
let g:coc_global_extensions = [
  \ 'coc-json',
  \ 'coc-tsserver',
  \ 'coc-emmet',
  \ ]

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[d` and `]d` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> <space>D <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Symbol renaming.
nmap <space>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <space>=  <Plug>(coc-format-selected)
nmap <space>=  <Plug>(coc-format-selected)

" Maybe not needed
augroup mygroup
  autocmd!
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<space>cap` for current paragraph
xmap <space>c  <Plug>(coc-codeaction-selected)
nmap <space>c  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <space>ca  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <space>qf  <Plug>(coc-fix-current)

" C-f, s-b to scroll floating window
nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>sd  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>se  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>sc  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>sd  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>sw  :<C-u>CocList -I symbols<cr>
