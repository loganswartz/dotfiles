""""""""""""""""""""
"""""\ Global \"""""
""""""""""""""""""""

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


""""""""""""""""""""""""
"""""\ Key Remaps \"""""
""""""""""""""""""""""""

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


"""""""""""""""""""""""
"""""\ Filetypes \"""""
"""""""""""""""""""""""

"    autocmd BufWritePre *.php,*.py,*.js,*.txt,*.hs,*.java,*.md
"                \:call <SID>StripTrailingWhitespaces()

augroup configgroup
    autocmd!
    autocmd VimEnter * highlight clear SignColumn
    autocmd FileType cs setlocal expandtab
    autocmd Filetype help setlocal nolist
    autocmd FileType java setlocal noexpandtab
    autocmd FileType java setlocal list
    autocmd FileType java setlocal listchars=tab:+\ ,eol:-
    autocmd FileType java setlocal formatprg=par\ -w80\ -T4
    autocmd FileType php setlocal expandtab
    autocmd FileType php setlocal list
    autocmd FileType php setlocal listchars=tab:+\ ,eol:-
    autocmd FileType php setlocal formatprg=par\ -w80\ -T4
    autocmd FileType ruby setlocal tabstop=2
    autocmd FileType ruby setlocal shiftwidth=2
    autocmd FileType ruby setlocal softtabstop=2
    autocmd FileType ruby setlocal commentstring=#\ %s
    autocmd FileType python setlocal commentstring=#\ %s
                \setlocal cc=80  " set indicator at row 80 for easier compliance with PEP 8
    autocmd BufEnter *.cls setlocal filetype=java
    autocmd BufEnter *.zsh-theme setlocal filetype=zsh
    autocmd BufEnter Makefile setlocal noexpandtab
    autocmd BufEnter *.sh setlocal tabstop=2
    autocmd BufEnter *.sh setlocal shiftwidth=2
    autocmd BufEnter *.sh setlocal softtabstop=2
augroup END


"""""""""""""""""""""""
"""""\ Functions \"""""
"""""""""""""""""""""""

" w!! to save as root
cmap w!! w !sudo tee > /dev/null %


""""""""""""""""""""""
"""""""\ Misc \"""""""
""""""""""""""""""""""
" if init.vim doesn't exist, create it and setup to use regular vimrc
" (sourcing this vimrc once will thus enable it's usage from that point onward)
if empty(glob('~/.config/nvim/init.vim'))
  silent !mkdir -p ~/.config/nvim && printf "set runtimepath^=~/.vim runtimepath+=~/.vim/after\nlet &packpath=&runtimepath\nsource ~/.vimrc" > ~/.config/nvim/init.vim
endif


""""""""""""""""""""""
"""""\ Vim-Plug \"""""
""""""""""""""""""""""
" autoinstall vim-plug if not present
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" vim +PlugUpdate! +qall <--- install plugins noninteractively
"call plug#begin('~/.vim/vim-plug')
call plug#begin('~/.config/nvim/vim-plug')

Plug 'itchyny/lightline.vim'
Plug 'thaerkh/vim-indentguides'
Plug 'alvan/vim-closetag'

call plug#end()
"Plug 'jiangmiao/auto-pairs'

