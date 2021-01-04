let g:vimsyn_embed = 'l'
let g:vimsyn_noerror = 1

lua << EOF

------------------ PACKER INSTALL --------------------------
local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
    execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
    execute 'packadd packer.nvim'
end

-------------------- HELPERS -------------------------------
local helpers = {}

local scopes = {o = vim.o, b = vim.bo, w = vim.wo}

-- Make general settings less verbose
function helpers.opt(scope, key, value)
    scopes[scope][key] = value
    if scope ~= 'o' then scopes['o'][key] = value end
end

-- Make a keybinding
function helpers.map(mode, lhs, rhs, opts)
    local options = {noremap = true}
    if opts then options = vim.tbl_extend('force', options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local opt = helpers.opt
local map = helpers.map

-------------------- PLUGINS -------------------------------
vim.cmd [[packadd packer.nvim]]
require('packer').startup(function ()
    use {'wbthomason/packer.nvim', opt = true}

    use {'LnL7/vim-nix'}

    use {'nvim-treesitter/nvim-treesitter'}
    use {'mhartington/oceanic-next'}
    use {'kyazdani42/nvim-web-devicons'}
    use {'tpope/vim-commentary'}

   -- use {'neovim/nvim-lspconfig'}
   -- use {'nvim-lua/completion-nvim'}
   -- use {'nvim-lua/lsp-status.nvim'}
    use {'nvim-lua/plenary.nvim'}
    use {'nvim-lua/popup.nvim'}
    use {'nvim-telescope/telescope.nvim'}
    use {'tjdevries/express_line.nvim'}

    use {'neoclide/coc.nvim', branch = 'release'}

    use {'mkitt/tabline.vim'}
    use {'SirVer/ultisnips'}
    use {'honza/vim-snippets'}
end)

-------------------- OPTIONS -------------------------------
local indent = 4
vim.cmd('set undodir=$HOME/.config/nvim/undodir') -- set undo directory
opt('o', 'undofile', true)                 -- use undo directory

opt('b', 'expandtab', true)                -- Use spaces instead of tabs
opt('b', 'shiftwidth', indent)             -- Size of an indent
opt('b', 'smartindent', true)              -- Insert indents automatically
opt('b', 'tabstop', indent)                -- Number of spaces tabs count for
opt('b', 'softtabstop', indent)            -- Size of an indent
opt('o', 'hidden', true)                   -- Enable modified buffers in background
opt('o', 'scrolloff', 4 )                  -- Lines of context
opt('o', 'shiftround', true)               -- Round indent
opt('o', 'sidescrolloff', 4 )              -- Columns of context
opt('o', 'smartcase', true)                -- Don't ignore case with capitals
opt('o', 'splitbelow', true)               -- Put new windows below current
opt('o', 'splitright', true)               -- Put new windows right of current
opt('o', 'termguicolors', true)            -- True color support
opt('w', 'list', true)                     -- Show some invisible characters (tabs etc.)
opt('w', 'number', true)                   -- Print line number
opt('w', 'relativenumber', true)           -- Relative line numbers
opt('w', 'wrap', false)                    -- no wrap
opt('o', 'mouse', 'a')                     -- enable mouse support

vim.cmd('set signcolumn=yes')              -- enable signcol always
vim.cmd('set noshowmode')
vim.cmd('set completeopt=menuone,noinsert')
vim.cmd('set shortmess+=c')

-------------------- COLORSCHEME ---------------------------
vim.cmd('syntax enable')
vim.cmd('colorscheme OceanicNext')

-------------------- MAPPINGS ------------------------------
vim.g.mapleader = ' '
map('i', '<C-c>', '<ESC>')                                                -- Make C-c act as <Esc>
map('n', '<F5>', ':let _s=@/<Bar>:%s/\\s\\+$//e<Bar>:let @/=_s<Bar><CR>') -- Trailing whitespace
map('n', '<F6>', ':retab<CR>')                                            -- Mixed indent
map('n', '<F7>', 'gg=G')                                                  -- Auto tab adjust entire buffer
map('n', '<leader><CR>', ':noh<CR>')                                      -- Remove highlighting

-------------------- TREE-SITTER ---------------------------
local treesitter = require 'nvim-treesitter.configs'
treesitter.setup {ensure_installed = 'maintained', highlight = {enable = true}}

-------------------- COMMANDS ------------------------------
vim.cmd('au TextYankPost * lua vim.highlight.on_yank {on_visual = false}')

--------------------- PLUGIN -------------------------------
-- Ultisnips
vim.g.UltiSnipsExpandTrigger = '<C-l>'
vim.g.UltiSnipsJumpForwardTrigger = '<C-j>'
vim.g.UltiSnipsJumpBackwardTrigger = '<C-k>'
vim.cmd("let g:UltiSnipsSnippetDirectories = [$HOME . '/.config/nixpkgs/configs/nvim/UltiSnips']")

-- Telescope
map('n', '<leader><leader>', '<cmd>lua require("telescope.builtin").find_files()<cr>')
map('n', '<leader>h', '<cmd>lua require("telescope.builtin").oldfiles()<cr>')
map('n', '<leader>bb', '<cmd>lua require("telescope.builtin").buffers()<cr>')
map('n', '<leader>gl', '<cmd>lua require("telescope.builtin").live_grep()<cr>')

----------------------- LSP -----------------------------------
--local lsp = require "lspconfig"
--local completion = require "completion"
--local lsp_status = require "lsp-status"
--
---- Connect LSP to lsp-status
--lsp_status.register_progress()
--lsp_status.config({ -- used in lsp_status.status()
--    indicator_errors = 'E',
--    indicator_warnings = 'W',
--    indicator_info = 'I',
--    indicator_hint = 'H', indicator_ok = '✔️', })
--
--local custom_attach = function(client, buffer)
--    print("Using LSP: " .. client.name)
--
--    completion.on_attach(client, buffer)
--    lsp_status.on_attach(client, buffer)
--    opt('b', 'omnifunc', 'v:lua.vim.lsp.omnifunc')
--
--    -- Many of the below don't work in certain servers
--    map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
--    map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
--    map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
--    map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
--    map("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
--    map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
--    map("n", "gp", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
--
--    map("n", "<leader>sd", "<cmd>lua vim.lsp.buf.document_symbol()<CR>")
--    map("n", "<leader>sw", "<cmd>lua vim.lsp.buf.workspace_symbol('')<CR>") -- empty string removes prompt
--    map("n", "<leader>d", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>")
--    map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
--    map("n", "<leader>r", "<cmd>lua vim.lsp.buf.rename()<CR>")
--    map("n", "<leader>cf", "<cmd>lua vim.lsp.buf.formatting()<CR>")
--
--    map("n", "[e", "<cmd>lua vim.lsp.diagnostic.goto_prev { wrap = false }<CR>")
--    map("n", "]e", "<cmd>lua vim.lsp.diagnostic.goto_next { wrap = false }<CR>")
--end
--
---- Diagnostic Config
--vim.lsp.handlers["textDocument/publishDiagnostics"] =
--    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
--        virtual_text = false,
--        signs = true,
--        underline = true,
--        update_in_insert = false
--    })
--
---- Use Telescope for some actions instead
--vim.lsp.handlers["textDocument/references"] = require("telescope.builtin").lsp_references
--vim.lsp.handlers["textDocument/documentSymbol"] = require("telescope.builtin").lsp_document_symbols
--vim.lsp.handlers["workspace/symbol"] = require("telescope.builtin").lsp_workspace_symbols
--
---- Completion Config
--vim.g.completion_enable_snippet = 'UltiSnips'
--vim.g.completion_enable_auto_popup = 0
--vim.g.completion_menu_length = 30
--vim.cmd('imap <silent> <c-space> <Plug>(completion_trigger)')
--
---- Add custom config here as desired
--local servers = {
--    rust_analyzer = {},
--    gopls = {},
--    sumneko_lua = {
--        settings = {
--            Lua = {
--                diagnostics = {
--                    globals = {"vim", "use"}
--                },
--                completion = {
--                    keywordSnippet = "Disable"
--                }
--            }
--        }
--    },
--    html = {
--        capabilities = {
--            textDocument = {
--                completion = {
--                    completionItem = {
--                        snippetSupport = true
--                    }
--                }
--            }
--        }
--    },
--    cssls = {
--        capabilities = {
--            textDocument = {
--                completion = {
--                    completionItem = {
--                        snippetSupport = true
--                    }
--                }
--            }
--        }
--    },
--}
--
---- Default capability config
--local default_capabilities_config = {
--    textDocument = {completion = {completionItem = {snippetSupport = false}}}
--}
--
--for server, config in pairs(servers) do
--    config.on_attach = custom_attach
--    config.capabilities = vim.tbl_deep_extend('keep', config.capabilities or {},
--        default_capabilities_config,
--        lsp_status.capabilities)
--
--    lsp[server].setup(config)
--end

---------------------- STATUSLINE--------------------------
local builtin = require('el.builtin')
local extensions = require('el.extensions')
local sections = require('el.sections')
local subscribe = require('el.subscribe')
local lsp_statusline = require('el.plugins.lsp_status')

local a = vim.api
local hi = sections.highlight

local git_icon = subscribe.buf_autocmd("el_file_icon", "BufRead",
function(_, bufnr)
    local icon = extensions.file_icon(_, bufnr)
    if icon then return icon .. ' ' end

    return ''
end)

local git_branch = subscribe.buf_autocmd("el_git_branch", "BufEnter",
function(window, buffer)
    local branch = extensions.git_branch(window, buffer)
    if branch then return ' ' .. extensions.git_icon() .. ' ' .. branch end
end)

local git_changes = subscribe.buf_autocmd("el_git_changes", "BufWritePost",
function(window, buffer)
    return extensions.git_changes(window, buffer)
end)

local function lsp_diagnostics(window, buffer)
    if not buffer.lsp then return '' end

    local level_indicator = {
        Error = 'E',
        Warning = 'W',
        Information = 'I',
        Hint = 'H'
    }
    local diagnostics_str = ''

    for level, indicator in pairs(level_indicator) do
        local count = vim.lsp.diagnostic.get_count(buffer.bufnr, level)
        if count > 0 then
            diagnostics_str = diagnostics_str .. indicator ..  count ..
            ' '
        end
    end

    if #diagnostics_str > 0 then
        return '[' .. diagnostics_str:sub(1, -2) .. ']'
    end

    return ''
end

local coc_stat = {
    coc_diag = function(_, buf, severity)
        -- severity can be: error, warning, hint, information
        local ok, res = pcall(a.nvim_buf_get_var, buf.bufnr,
        "coc_diagnostic_info")

        if ok then
            local count = res[severity]

            if count > 0 then
                return count > 0 and
                string.format(" %s%s ", severity:sub(1, 1), count) or
                ""
            end
        end
    end
}

local function coc_e(win, buf)
    return coc_stat.coc_diag(win, buf, "error")
end

local function coc_w(win, buf)
    return coc_stat.coc_diag(win, buf, "warning")
end

local function coc_h(win, buf)
    return coc_stat.coc_diag(win, buf, "hint")
end

local function coc_i(win, buf)
    return coc_stat.coc_diag(win, buf, "information")
end

local ei = "ElMiddleInactive" -- blank background for error/warn/etc, can use colors instead

require('el').setup {
    generator = function(_, _)
        return {
            extensions.gen_mode {
                format_string = ' %s '
            },
            git_branch,
            ' ',
            sections.split,

            git_icon,
            sections.maximum_width(
                builtin.responsive_file(140, 90),
                0.30
            ),
            sections.collapse_builtin {
                ' ',
                builtin.modified_flag
            },
            sections.split,
            lsp_statusline.server_progress,
            lsp_diagnostics,
            hi({active = ei, inactive = ei}, coc_e),
            hi({active = ei, inactive = ei}, coc_w),
            hi({active = ei, inactive = ei}, coc_h),
            hi({active = ei, inactive = ei}, coc_i),
            git_changes,
            '[', builtin.line_with_width(3), ':',  builtin.column_with_width(2), ']',
            '[','%P',']',
            sections.collapse_builtin {
                '[',
                builtin.help_list,
                builtin.readonly_list,
                ']',
            },
            builtin.filetype,
        }
    end
}
EOF

" COC.nvim settings
" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [e <Plug>(coc-diagnostic-prev)
nmap <silent> ]e <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
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

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>r <Plug>(coc-rename)

augroup mygroup
  autocmd!
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>c  <Plug>(coc-codeaction-selected)
nmap <leader>c  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ca  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
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
nnoremap <silent><nowait> <space>so  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>ss  :<C-u>CocList -I symbols<cr>
