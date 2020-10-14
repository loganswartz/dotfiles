" My .vimrc
" To make this easier to read, open in vim and do `:set foldmethod=marker` and
" then do `zM` in normal mode.
"█████ First Time Setup █████ {{{
" if init.vim doesn't exist, create it and setup to use regular vimrc + vim folders (except for plugins which stay in ~/.config/nvim/vim-plug)
" --> sourcing this vimrc once will thus enable its usage from that point onward
" --> also, it will automatically symlink the sourced file to ~/.vimrc if a vimrc is
"     not detected in the home directory

if empty(glob('~/.vimrc'))
	let s:srcpath = resolve(expand('<sfile>:p:h')) . '/.vimrc'
	execute 'silent !ln -s ' . s:srcpath . ' ~/.vimrc'
endif
if empty(glob('~/.config/nvim/init.vim'))
	silent !mkdir -p ~/.config/nvim && printf "set runtimepath^=~/.vim runtimepath+=~/.vim/after\nlet &packpath=&runtimepath\nsource ~/.vimrc" > $HOME/.config/nvim/init.vim
	set runtimepath^=~/.vim runtimepath+=~/.vim/after
	let &packpath=&runtimepath
endif
" autoinstall to ~/.vim/autoload (so that vim and neovim both use it) if vim-plug if not present
if empty(glob('~/.vim/autoload/plug.vim'))
	if system("which wget") == ""
		echo "Wget does not appear to be installed, please install it with 'sudo apt install -y wget' to allow for automatic installation of vim-plug, or install vim-plug manually yourself to skip this step."
		echo ""
		quit
	endif
	silent !wget -P ~/.vim/autoload/
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	source ~/.vim/autoload/plug.vim
	autocmd VimEnter * PlugInstall --sync | quit | source ~/.vimrc
endif
if empty(glob('~/.vim/templates/'))   " symlink skeleton folder
	let s:srcpath = resolve(expand('<sfile>:p:h')) . '/vim_templates'
	execute 'silent !ln -s ' . s:srcpath . ' ~/.vim/templates'
endif

" }}}
"█████ Vim-Plug + Plugins █████ {{{
" Installed Plugins {{{
if !empty(glob('~/.vim/autoload/plug.vim'))
	call plug#begin('~/.config/nvim/vim-plug')

	Plug 'itchyny/lightline.vim'
	Plug 'thaerkh/vim-indentguides'
	Plug 'alvan/vim-closetag'
	Plug 'tomtom/tcomment_vim'
	Plug 'airblade/vim-gitgutter'
	Plug 'PProvost/vim-ps1'
	Plug 'tpope/vim-surround'
	Plug 'tpope/vim-fugitive'
	Plug 'tpope/vim-speeddating'
	Plug 'tpope/vim-vinegar'
	Plug 'junegunn/rainbow_parentheses.vim'
	Plug 'joshdick/onedark.vim'
	Plug 'tpope/vim-eunuch'
	Plug 'junegunn/gv.vim'
	Plug 'junegunn/goyo.vim'
	Plug 'FooSoft/vim-argwrap'
	Plug 'sheerun/vim-polyglot'
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
	Plug 'google/vim-colorscheme-primary'
	Plug 'loganswartz/vim-plug-updates'
	Plug 'honza/vim-snippets'

	call plug#end()
endif

" }}}
" Plugin-Specific Settings {{{
" Vim-GitGutter {{{
set updatetime=100
let g:gitgutter_max_signs = 500
" No mapping
let g:gitgutter_map_keys = 0
" Colors
let g:gitgutter_override_sign_column_highlight = 0
highlight clear SignColumn
highlight GitGutterAdd ctermfg=2
highlight GitGutterChange ctermfg=3
highlight GitGutterDelete ctermfg=1
highlight GitGutterChangeDelete ctermfg=4

" }}}
" Lightline.vim {{{
let g:lightline = {
\     'colorscheme': 'onedark',
\     'active': {
\         'left': [
\             [ 'mode', 'paste' ],
\             [ 'gitbranch', 'readonly', 'filename', 'modified' ],
\             [ 'pluginupdates', 'vimplugupdate' ]
\         ]
\     },
\     'component_function': {
\         'gitbranch': 'fugitive#head',
\         'pluginupdates': 'StatuslinePluginUpdates',
\         'vimplugupdate': 'StatuslineVimPlugUpdates'
\     },
\ }

" }}}
" vim-argwrap {{{
nnoremap gw :ArgWrap<CR>
let g:argwrap_tail_comma = 1
" }}}
" python-syntax {{{
let g:python_highlight_all = 1

" }}}
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
  \ ]
  " \ 'coc-python',

nnoremap <silent> K :call CocAction('doHover')<CR>

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gr <Plug>(coc-references)

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nnoremap <silent> <space>d :<C-u>CocList diagnostics<cr>

nmap <leader>do <Plug>(coc-codeaction)
nmap <leader>rn <Plug>(coc-rename)

" formatting for JavaScript / TypeScript / CSS / JSON
command! -nargs=0 Prettier :CocCommand prettier.formatFile

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
set updatetime=300

" }}}
" vim-polyglot {{{
" disable markdown conceallevel from vim_polyglot
let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0

" }}}
" }}}
" Miscellaneous {{{
" use this to disable plugin function calls when the plugin isn't loaded
function! PluginLoaded(name)
	if index(keys(g:plugs), a:name) == -1
		return 0
	else
		return 1
	endif
endfunction

" }}}
" }}}
"█████ Global Options █████ {{{
set hidden   " hold onto session history of closed files
set foldmethod=marker

if PluginLoaded('onedark.vim')
	colorscheme onedark
endif

set splitright
set splitbelow

" turn on syntax highlighting
if has("syntax")
  syntax on
endif
set showmatch
set incsearch
set hlsearch
" more aesthetically pleasing color column
highlight ColorColumn ctermbg=236
" set color column to be all columns 80+
"let &colorcolumn=join(range(80,999),",")
"let &colorcolumn="80,".join(range(96,999),",")

" have Vim load indentation rules and plugins according to the detected
" filetype.
if has("autocmd")
  filetype plugin indent on
  set omnifunc=syntaxcomplete#Complete
endif

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

" set visual tab character width to 4 spaces
set tabstop=4
set shiftwidth=4
set noexpandtab

" hide eol when IndentGuides is enabled
set listchars=tab:\|\ ,trail:·
set nolist

" don't highlight on vimrc re-source
" set nohlsearch

" don't automatically resize splits
" set noequalalways

" enable tree view by default in netrw
" (disabled for now due to bug with tree view where symlinks aren't followed correctly, see https://github.com/vim/vim/issues/2386)
"let g:netrw_liststyle = 3

" }}}
"█████ Key Remaps █████ {{{

" change leader key
" let mapleader=","

" \/ clears search highlighting
nnoremap <leader>/ :nohlsearch<CR>

" Reverse j and k (I used to prefer this, some people do)
"noremap j k
"noremap k j

" navigate by visual lines, not real lines
nnoremap j gj
nnoremap k gk
nnoremap <Up> g<Up>
nnoremap <Down> g<Down>
" highlight last inserted text
nnoremap gV `[v`]
" nnoremap <C-s> :w<CR>

" <C-x>r to insert a random string of n length (possible characters are A-Za-z0-9)
nmap <C-x>r "=RandString()<C-M>p
imap <C-x>r <C-r>=RandString()<C-M>

" Paste mode toggle (paste mode prevents broken indentation when pasting)
nnoremap <C-p> :set invpaste paste?<CR>
set pastetoggle=<C-p>
set showmode

vnoremap <C-c> "+y
inoremap <RightMouse> <C-r>+
set mouse=a

" resize splits
nnoremap <silent> <M-=> :exec "resize +2"<CR>
nnoremap <silent> <M--> :exec "resize -2"<CR>
inoremap <silent> <M-=> <C-o>:exec "resize +2"<CR>
inoremap <silent> <M--> <C-o>:exec "resize -2"<CR>
nnoremap <silent> <M-]> :exec "vertical resize +2"<CR>
nnoremap <silent> <M-[> :exec "vertical resize -2"<CR>
inoremap <silent> <M-]> <C-o>:exec "vertical resize +2"<CR>
inoremap <silent> <M-[> <C-o>:exec "vertical resize -2"<CR>


" }}}
"█████ Autocommands █████ {{{

"	autocmd BufWritePre *.php,*.py,*.js,*.txt,*.hs,*.java,*.md
"				\:call <SID>StripTrailingWhitespaces()

augroup filetypes
	autocmd!
	autocmd FileType help setlocal nolist
	autocmd FileType php setlocal expandtab
	autocmd FileType php setlocal list
	autocmd FileType python setlocal commentstring=#\ %s
				\setlocal cc=80  " set indicator at row 80 for easier compliance with PEP 8
	autocmd BufEnter *.zsh-theme setlocal filetype=zsh
	autocmd BufEnter Makefile setlocal noexpandtab
	autocmd BufEnter *.sh setlocal tabstop=2
	autocmd BufEnter *.sh setlocal shiftwidth=2
	autocmd BufEnter *.sh setlocal softtabstop=2
	if has('nvim')
		autocmd TermOpen * startinsert
	endif
	" plugin autocommands
	autocmd FileType vim let b:argwrap_line_prefix = '\'
	if PluginLoaded('rainbow_parentheses.vim')
		autocmd BufEnter * RainbowParentheses
	endif
augroup END

augroup templates
	autocmd BufNewFile * call LoadTemplate()
augroup END

augroup misc
	autocmd VimEnter * hi Normal guibg=NONE ctermbg=NONE " transparent bg
	autocmd VimEnter * call CheckForUpdates()
augroup END

" }}}
"█████ Functions █████ {{{

" :w!! to save as root
cmap w!! w !sudo tee > /dev/null %

" also comment out the echo messages in DisplayResults() in vim-outdated-plugins (because they are redundant)
function! StatuslinePluginUpdates()
	if exists('g:totalPluginUpdates') && g:totalPluginUpdates > 0
		return  '▲ ' . g:totalPluginUpdates
	else
		return ''
	endif
endfunction

function! StatuslineVimPlugUpdates()
	if exists('g:vimplugHasUpdate') && g:vimplugHasUpdate
		return '🔌 Vim-Plug Update Available'
	else
		return ''
	endif
endfunction

command! PluginUpdate PlugUpdate --sync | call CheckForUpdates()
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

function! OpenLintingWindow()
	let l:old_eventignore = &eventignore
	try
		let &eventignore = "TermOpen"
		new term://watch python3 -m flake8 --count --ignore=W391,W503 --max-complexity=10 --max-line-length=127 --statistics
	finally
		let &eventignore = l:old_eventignore
	endtry
	wincmd w
endfunction

function! RandString(...)
	let l:length = (a:0 >= 1 && a:1 > 0) ? a:1 : input("l: ")
	return system("head /dev/urandom | tr -dc A-Za-z0-9 | head -c " . l:length)
endfunction

" load skeleton template for some filetype if a template with that extension exists
function! LoadTemplate()
	let ftype=expand('%:e')
	let skel='~/.vim/templates/skeleton.' . ftype
	if !empty(glob(skel))
		exec "0r " . skel
	endif
endfunction

" }}}
