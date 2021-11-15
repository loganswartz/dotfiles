" My .vimrc
" To make this easier to read, open in vim and do `:set foldmethod=marker` and
" then do `zM` in normal mode. Open and close folds with `za`.

" First Time Setup {{{
let s:NEOVIM_DIR = "$HOME/.config/nvim"

" Alias init.vim to ~/.vimrc
if empty(glob(s:NEOVIM_DIR . '/init.vim'))
    exec "silent !mkdir -p " . s:NEOVIM_DIR . " && printf 'source ~/.vimrc' > " . s:NEOVIM_DIR . '/init.vim'
endif

" Bootstrap packer.nvim
lua <<EOF
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd 'packadd packer.nvim'
end
EOF

" }}}
" Plugins {{{
" Installed Plugins {{{

lua <<EOF
return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Vimscript
    use 'dstein64/vim-startuptime'
    use 'alvan/vim-closetag'
    use 'PProvost/vim-ps1'
    use 'tpope/vim-surround'
    use 'tpope/vim-fugitive'
    use 'tpope/vim-speeddating'
    use 'tpope/vim-vinegar'
    use 'tpope/vim-commentary'
    use 'joereynolds/place.vim'
    use 'junegunn/rainbow_parentheses.vim'
    use 'tpope/vim-eunuch'
    use 'junegunn/gv.vim'
    use 'junegunn/goyo.vim'
    use 'FooSoft/vim-argwrap'
    use 'honza/vim-snippets'
    use 'lambdalisue/suda.vim'
    use 'wellle/targets.vim'
    use 'tpope/vim-dadbod'
    use 'kristijanhusak/vim-dadbod-ui'

    -- coc.nvim
    use {
        'neoclide/coc.nvim', branch = 'release', run = ':CocUpdate'
    }
    use 'fannheyward/coc-react-refactor'

    -- Lua
    use {
        'lukas-reineke/indent-blankline.nvim',
        config = function()
            require("indent_blankline").setup {
                char = "┆",
                space_char_blankline = " ",
                buftype_exclude = {"terminal"},
                use_treesitter = true,
                show_current_context = true,
                show_first_indent_level = true,
                show_trailing_blankline_indent = false,
            }
        end
    }
    use {
        'nvim-telescope/telescope.nvim',
        config = function()
            require('telescope').setup {
                defaults = {
                    vimgrep_arguments = {
                        'rg',
                        '--color=never',
                        '--no-heading',
                        '--with-filename',
                        '--line-number',
                        '--column',
                        '--smart-case'
                        },
                    prompt_prefix = "> ",
                    selection_caret = "> ",
                    entry_prefix = "  ",
                    initial_mode = "insert",
                    selection_strategy = "reset",
                    sorting_strategy = "descending",
                    layout_strategy = "horizontal",
                    layout_config = {
                        horizontal = {
                            mirror = false,
                            },
                        vertical = {
                            mirror = false,
                            },
                        },
                    file_sorter =  require'telescope.sorters'.get_fuzzy_file,
                    file_ignore_patterns = {},
                    generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,
                    winblend = 0,
                    border = {},
                    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
                    color_devicons = true,
                    use_less = true,
                    path_display = {},
                    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
                    file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
                    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
                    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,

                    -- Developer configurations: Not meant for general override
                    buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker
                }
            }
        end
    }
    use 'nvim-treesitter/playground'
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function()
            require('nvim-treesitter.configs').setup {
                ensure_installed = "maintained",
                highlight = {
                    enable = true,
                    disable = { "c", "rust" },
                    additional_vim_regex_highlighting = false,
                },
                indent = {
                    enable = true
                },
                playground = {
                    enable = true,
                    disable = {},
                    updatetime = 25,
                    persist_queries = false,
                    keybindings = {
                        toggle_query_editor = 'o',
                        toggle_hl_groups = 'i',
                        toggle_injected_languages = 't',
                        toggle_anonymous_nodes = 'a',
                        toggle_language_display = 'I',
                        focus_language = 'f',
                        unfocus_language = 'F',
                        update = 'R',
                        goto_node = '<cr>',
                    show_help = '?',
                    },
                }
            }
        end
    }
    use {
        'lewis6991/gitsigns.nvim',
        requires = { 'nvim-lua/plenary.nvim' },
        config = function()
            require("gitsigns").setup {
                signs = {
                    add          = {hl = 'GitSignsAdd'   , text = '+'},
                    change       = {hl = 'GitSignsChange', text = '~'},
                    delete       = {hl = 'GitSignsDelete', text = '_'},
                    topdelete    = {hl = 'GitSignsDelete', text = '‾'},
                    changedelete = {hl = 'GitSignsChange', text = '~'},
                },
            }
        end,
    }
    use {
        'nvim-lualine/lualine.nvim',
        requires = {'kyazdani42/nvim-web-devicons', opt = true},
        config = function()
            require'lualine'.setup {
                options = {
                    icons_enabled = false,
                    theme = 'auto',
                    component_separators = { left = '|', right = '|'},
                    section_separators = { left = '', right = ''},
                    disabled_filetypes = {},
                    always_divide_middle = true,
                    },
                sections = {
                    lualine_a = {{'mode', color = { gui=nil } }},  -- remove bold
                    lualine_b = {
                        'branch',
                        'vim.opt.readonly._value and "RO" or ""',
                        {'filename', file_status = false},
                        'vim.opt.mod._value and "+" or ""',
                    },
                    lualine_c = {'PluginUpdatesIndicator'},
                    lualine_x = {
                        {'diagnostics', sources={'nvim_lsp', 'coc'}},
                        'fileformat',
                        'encoding',
                        'filetype',
                    },
                    lualine_y = {'progress'},
                    lualine_z = {{'location', color = { gui=nil } }}  -- remove bold
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
        end,
    }

    -- My plugins
    use 'loganswartz/vim-plug-updates'
    use 'loganswartz/vim-squint'

    -- Colorschemes
    use 'navarasu/onedark.nvim'
    use 'bluz71/vim-moonfly-colors'
    use 'EdenEast/nightfox.nvim'
    use 'sainnhe/everforest'
end)
EOF

" reload vimrc on saves, and recompile packer config
" https://gist.github.com/romainl/379904f91fa40533175dfaec4c833f2f
augroup packer_user_config
    autocmd!
    autocmd BufWritePost .vimrc nested source <afile> | PackerCompile
augroup end

" }}}
" Plugin-Specific Settings {{{
" coc.nvim {{{

let g:coc_config_home = "$HOME/.config/nvim"
let g:coc_global_extensions = [
    \ 'coc-tsserver',
    \ 'coc-prettier',
    \ 'coc-eslint',
    \ 'coc-phpls',
    \ 'coc-snippets',
    \ 'coc-svelte',
    \ 'coc-tailwindcss',
    \ 'coc-pyright',
    \ 'coc-xml',
    \ 'coc-json',
    \ 'coc-vimlsp',
    \ 'coc-omnisharp',
    \ 'coc-db',
    \ ]

" show variable info in popup window
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

" Code definitions
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> <leader>gd :call CocActionAsync('jumpDefinition', 'SP')<CR>
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gr <Plug>(coc-references)

" Diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nnoremap <silent> <space>d :<C-u>CocList diagnostics<cr>

" Code actions
nmap <leader>do <Plug>(coc-codeaction)
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')
command! -nargs=0 SortImports :call CocActionAsync('runCommand', 'editor.action.organizeImport')

" tab auto completion
inoremap <silent><expr> <TAB>
    \ pumvisible() ? "\<C-n>" :
    \ <SID>check_back_space() ? "\<TAB>" :
    \ coc#refresh()

inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" mapping for snippets
" Use <C-l> for trigger snippet expand.
imap <C-l> <Plug>(coc-snippets-expand)

" https://github.com/neoclide/coc-snippets#examples
" inoremap <silent><expr> <TAB>
"       \ pumvisible() ? coc#_select_confirm() :
"       \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ coc#refresh()

let g:coc_snippet_next = '<TAB>'
let g:coc_snippet_prev = '<S-TAB>'

" Use <c-space> to trigger completion.
" inoremap <silent><expr> <NUL> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
    inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
 inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=200

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
" if has("nvim-0.5.0") || has("patch-8.1.1564")
"     " Recently vim can merge signcolumn and number column into one
"     set signcolumn=number
" else
"     set signcolumn=yes
" endif

" xmap <leader>r  <Plug>(coc-codeaction-selected)
" nmap <leader>r  <Plug>(coc-codeaction-selected)

" }}}
" vim-argwrap {{{
nnoremap gw :ArgWrap<CR>
let g:argwrap_tail_comma = 1

" }}}
" indent-blankline {{{
set list listchars=trail:·,tab:┆─,nbsp:␣

" }}}
" telescope.nvim {{{
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>

" }}}
" place.vim {{{
nmap ga <Plug>(place-insert)
nmap gb <Plug>(place-insert-multiple)
" }}}
" onedark.nvim {{{
let g:onedark_transparent_background = v:true
let g:onedark_italic_comment = v:false
" }}}
" dadbod-ui {{{
" za or return to open drawer option (same as folds)
autocmd FileType dbui nmap <buffer> za <Plug>(DBUI_SelectLine)
autocmd FileType dbui nmap <buffer> <CR> <Plug>(DBUI_SelectLine)
call db_ui#utils#set_mapping('<C-E>', '<Plug>(DBUI_ExecuteQuery)')

" run a single query instead of the whole file (analogous to dbeaver's Ctrl+Enter)
nmap <C-E> vip\S

" }}}
" }}}
" }}}
" Autocommands {{{

" autotrim trailing whitespace
autocmd FileType python,php,javascript,text,markdown,typescript,vim autocmd BufWritePre <buffer> %s/\s\+$//e

augroup filetypes
    autocmd!
    autocmd FileType help setlocal nolist
    " set indicator at row 80 for easier compliance with PEP 8
    autocmd FileType python setlocal commentstring=#\ %s cc=80
    autocmd BufEnter *.zsh-theme setlocal filetype=zsh
    autocmd BufEnter *.sh setlocal tabstop=2 shiftwidth=2 softtabstop=2
    if has('nvim')
        autocmd TermOpen * startinsert
    endif
    " plugin autocommands
    autocmd FileType vim let b:argwrap_line_prefix = '\'
    autocmd BufEnter * RainbowParentheses
augroup END

augroup templates
    autocmd BufNewFile * call LoadTemplate(s:NEOVIM_DIR . '/templates')
augroup END

augroup colors
    autocmd Colorscheme * hi Normal guibg=NONE ctermbg=NONE " transparent bg
augroup END

" }}}
" Global Options {{{
colorscheme onedark

set termguicolors
set foldmethod=marker
set mouse=a

" I hate terminal bells.
set visualbell

" enable line numbers and statusbars on all windows
set number
set laststatus=2
"
" disable mode indicator in statusbar (redundant because of airline)
set noshowmode
set showcmd

" when scrolling, always have at least 8 lines between the cursor and the edge
" of the screen for better context (and to avoid editing right at the edge)
set scrolloff=8

" default to 4 spaces for tabs
set expandtab smarttab shiftwidth=4 tabstop=4 softtabstop=4

" default direction to open splits
set splitright splitbelow

" don't automatically resize splits
" set noequalalways

set showmatch incsearch hlsearch

" more aesthetically pleasing color column
highlight ColorColumn ctermbg=236

" have Vim load indentation rules and plugins according to the detected
" filetype.
if has("autocmd")
    filetype plugin indent on
    set omnifunc=syntaxcomplete#Complete
endif

" }}}
" Key Remaps {{{

" \/ clears search highlighting
nnoremap <leader>/ :nohlsearch<CR>

" navigate by visual lines, not real lines
nnoremap j gj
nnoremap k gk
nnoremap <Up> g<Up>
nnoremap <Down> g<Down>
" highlight last inserted text
nnoremap gV `[v`]

" insert a random string of n length (possible characters are A-Za-z0-9)
nmap <leader>gs "=RandString()<C-M>p
imap <leader>gs <C-r>=RandString()<C-M>

" Paste mode toggle (paste mode prevents broken indentation when pasting)
nnoremap <C-p> :set invpaste paste?<CR>
set pastetoggle=<C-p>

if has("clipboard")
    " Copy your current visual selection to clipboard (or paste)
    vnoremap <C-c> "+y
    inoremap <RightMouse> <C-r>+
endif

" resize splits
nnoremap <silent> <M-=> :exec "resize +2"<CR>
nnoremap <silent> <M--> :exec "resize -2"<CR>
inoremap <silent> <M-=> <C-o>:exec "resize +2"<CR>
inoremap <silent> <M--> <C-o>:exec "resize -2"<CR>
nnoremap <silent> <M-]> :exec "vertical resize +2"<CR>
nnoremap <silent> <M-[> :exec "vertical resize -2"<CR>
inoremap <silent> <M-]> <C-o>:exec "vertical resize +2"<CR>
inoremap <silent> <M-[> <C-o>:exec "vertical resize -2"<CR>

" Alt-P to open the python docs for the hovered library in your browser
nnoremap <silent> <M-p> "zyiw:silent exec "!xdg-open https://docs.python.org/3/library/" . @z . ".html"<CR>

" Switch split direction
nnoremap <silent> <C-w><space> :call ToggleWindowHorizontalVerticalSplit()<CR>

" }}}
" Functions {{{

" :w!! to save as root
cmap w!! SudaWrite
cmap b! %!python3 -m black -q -

command! VTerm vnew | terminal
command! Term new | terminal
command! Lint call OpenLintingWindow()
command! RunModule call RunModule('%', 0)
command! RunModuleSudo call RunModule('%', 1)
command! -nargs=+ -complete=file SP exec s:terminal_orientation_is_vertical() ? 'vs ' : 'sp ' . '<args>'

function! s:terminal_orientation_is_vertical()
    return winwidth(0) > float2nr(winheight(0)*3.27027)
endfunction

function! s:current_python_module(path)
    let l:path = fnamemodify(expand(a:path), ':p')
    for module in split($PYTHONPATH, ':')
        if stridx(l:path, module) == 0
            return fnamemodify(module, ':t')
        endif
    endfor
endfunction

function! RunModule(path, sudo, ...)
    let l:user = a:0 >= 1 ? a:1 : 0
    let l:module = s:current_python_module(a:path)
    if len(l:module) > 0
        exec "new term://" . (a:sudo ? 'sudo ' : '') . (l:user ? '-u ' . l:user . ' ' : '') . "python3 -m " . l:module
    else
        echo "Couldn't find a matching python module in $PYTHONPATH!"
    endif
endfunction

function! RandString(...)
    let l:length = (a:0 >= 1 && a:1 > 0) ? a:1 : input("l: ")
    return system("head /dev/urandom | tr -dc A-Za-z0-9 | head -c " . l:length)
endfunction

" load skeleton template for some filetype if a template with that extension exists
function! LoadTemplate(template_dir)
    let ftype = expand('%:e')
    let skel = a:template_dir . '/skeleton.' . ftype
    if !empty(glob(skel))
        exec "0r " . skel
        normal Gddgg
    endif
endfunction

function! ToggleWindowHorizontalVerticalSplit()
    if !s:terminal_orientation_is_vertical() " if vertical, switch to horizontal
        windo wincmd K
    else " if horizontal, switch to vertical
        windo wincmd H
    endif
endfunction

" returns v:true if successful, else v:false
function! UpgradeNvim()
    let url = 'https://github.com/neovim/neovim/releases/download/stable/nvim.appimage'
    let exe = v:progpath
    " if the progpath is the path inside the appimage
    if (exe[0:15] ==# '/tmp/.mount_nvim')
        let exe = trim(system('which nvim'))
        if (v:shell_error)
            echom 'Failed to find Neovim executable location.'
            return v:false
        endif
    endif

    " download the new image
    let temp = tempname()
    try
        let downloaded = system("wget -q -O " . temp . " " . url)
    catch
        echom 'Failed to download new version.'
        return v:false
    endtry
    " move into place
    try
        let pass = inputsecret("[sudo] password for " . $USER . ": ")
        echom "\n"
        let moved = system("sudo -S mv " . temp . " " . v:progpath, pass)
    catch
        echom 'Failed to move downloaded update to ' . exe . '.'
        return v:false
    endtry

    echom 'Neovim updated! (restart required)'
    return v:true
endfunction
command! UpgradeNvim call UpgradeNvim()

" }}}
