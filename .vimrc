"▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
"█████ First Time Setup █████
"▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
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
	if system("which curl") == ""
		echo "Curl does not appear to be installed, please install it with 'sudo apt install -y curl' to allow for automatic installation of vim-plug, or install vim-plug manually yourself to skip this step."
		echo ""
		quit
	endif
	silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | quit | source ~/.vimrc "$MYVIMRC
endif

" enable tree view by default in netrw
" (disabled for now due to bug with tree view where symlinks aren't followed correctly, see https://github.com/vim/vim/issues/2386)
"let g:netrw_liststyle = 3


"▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
"█████ Global █████
"▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

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
set listchars-=eol:\$


"▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
"█████ Key Remaps █████
"▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

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
nnoremap <C-s> :w<CR>

" <C-x>r to insert a random string of n length (possible characters are A-Za-z0-9)
nmap <C-x>r "=RandString()<C-M>p
imap <C-x>r <C-r>=RandString()<C-M>



"▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
"█████ Filetypes █████
"▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

"	autocmd BufWritePre *.php,*.py,*.js,*.txt,*.hs,*.java,*.md
"				\:call <SID>StripTrailingWhitespaces()

augroup filetypes
	autocmd!
	autocmd Filetype help setlocal nolist
	autocmd FileType php setlocal expandtab
	autocmd FileType php setlocal list
	autocmd FileType python setlocal commentstring=#\ %s
				\setlocal cc=80  " set indicator at row 80 for easier compliance with PEP 8
	autocmd BufEnter *.zsh-theme setlocal filetype=zsh
	autocmd BufEnter Makefile setlocal noexpandtab
	autocmd BufEnter *.sh setlocal tabstop=2
	autocmd BufEnter *.sh setlocal shiftwidth=2
	autocmd BufEnter *.sh setlocal softtabstop=2
augroup END

augroup templates
	autocmd BufNewFile * call LoadTemplate()
augroup END

" load skeleton template for some filetype if a template with that extension exists
function! LoadTemplate()
	let ftype=expand('%:e')
	let skel='~/.vim/templates/skeleton.' . ftype
	if !empty(glob(skel))
		exec "0r " . skel
	endif
endfunction

"▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
"█████ Functions █████
"▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

" :w!! to save as root
cmap w!! w !sudo tee > /dev/null %

" also comment out the echo messages in DisplayResults() in vim-outdated-plugins (because they are redundant)
function! StatuslinePluginUpdates()
	if g:pluginsToUpdate == 0
		return ''
	else
		return  '▲ ' . g:pluginsToUpdate
	endif
endfunction

command! PluginUpdate PlugUpdate --sync | call CheckForUpdates()

function! RandString(...)
	"if a:0 > 0
	"	let l:length = a:1
	"else
	"	let l:length = input("l: ")
	"endif
	return system("head /dev/urandom | tr -dc A-Za-z0-9 | head -c" . input("l: "))
endfunction


"▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
"█████ Vim-Plug + Plugins █████
"▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

" vim +PlugUpdate! +qall <--- install plugins noninteractively
"call plug#begin('~/.vim/vim-plug')
if !empty(glob('~/.vim/autoload/plug.vim'))
	call plug#begin('~/.config/nvim/vim-plug')

	Plug 'itchyny/lightline.vim'
	Plug 'thaerkh/vim-indentguides'
	"Plug 'nathanaelkane/vim-indent-guides'
	Plug 'alvan/vim-closetag'
	Plug 'semanser/vim-outdated-plugins'
	Plug 'tomtom/tcomment_vim'
	Plug 'airblade/vim-gitgutter'
	Plug 'PProvost/vim-ps1'
	Plug 'tpope/vim-surround'
	Plug 'tpope/vim-fugitive'
	Plug 'tpope/vim-speeddating'
	Plug 'tpope/vim-vinegar'
	Plug 'junegunn/rainbow_parentheses.vim'
	Plug 'unblevable/quick-scope'
	"Plug 'tpope/vim-eunuch'
	"Plug 'benmills/vimux'
	"Plug 'kana/vim-textobj-user'
	"Plug 'jiangmiao/auto-pairs'

	call plug#end()
endif

"█████ Vim-GitGutter █████
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

"█████ Lightline.vim █████
let g:lightline = {
      \ 'colorscheme': 'powerline',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ],
      \             [ 'pluginupdates' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head',
      \   'pluginupdates': 'StatuslinePluginUpdates'
      \ },
      \ }

