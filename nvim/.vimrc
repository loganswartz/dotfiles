" My .vimrc
" To make this easier to read, open in vim and do `:set foldmethod=marker` and
" then do `zM` in normal mode. Open and close folds with `za`.

" Global Options {{{
set termguicolors
set cursorline

set listchars=trail:·,tab:┆─,nbsp:␣
set list

" have Vim load indentation rules and plugins according to the detected
" filetype.
if has("autocmd")
    filetype plugin indent on
    set omnifunc=syntaxcomplete#Complete
endif

set foldmethod=marker
set mouse=a

" I hate terminal bells.
set visualbell

set number
set laststatus=3

" disable mode indicator in statusbar (redundant because of airline)
set noshowmode
set showcmd

" when scrolling, always have at least 8 lines between the cursor and the edge
" of the screen for better context (and to avoid editing right at the edge)
set scrolloff=8
set sidescrolloff=8

" default to 4 spaces for tabs
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4
set softtabstop=4

" default direction to open splits
set splitright
set splitbelow

" don't automatically resize splits
" set noequalalways

set showmatch
set incsearch
set hlsearch

" enable transparency
set pumblend=10
set winblend=20

" }}}
" Key Remaps {{{

" \/ clears search highlighting
nnoremap <silent> <leader>/ :nohlsearch<CR>

" navigate by visual lines, not real lines
nnoremap j gj
nnoremap k gk
nnoremap <Up> g<Up>
nnoremap <Down> g<Down>

" highlight last inserted text
nnoremap gV `[v`]

" Paste mode toggle (paste mode prevents broken indentation when pasting)
nnoremap <C-p> :set invpaste paste?<CR>
" set pastetoggle=<C-p>

if has("clipboard")
    " Copy your current visual selection to clipboard (or paste)
    vnoremap <C-c> "+y
    inoremap <RightMouse> <C-r>+
endif

" Switch split direction
nnoremap <silent> <C-w><space> :call ToggleWindowHorizontalVerticalSplit()<CR>

" open the current dir in a split
nnoremap <silent> _ :exec "SP " . (!empty(expand('%:h')) ? expand('%:h') : getcwd())<CR>

" }}}
" Functions {{{

command! Term exec (s:terminal_orientation_is_vertical() ? 'VTerm' : 'HTerm')
command! VTerm vnew | terminal
command! HTerm new | terminal
command! -nargs=+ -complete=file SP exec (s:terminal_orientation_is_vertical() ? 'vs' : 'sp') . ' <args>'

function! s:terminal_orientation_is_vertical()
    return winwidth(0) > float2nr(winheight(0)*3.27027)
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

function! FindExistingInstall()
    let exe_path = v:progpath
    " if the progpath is the path inside the appimage
    if (exe_path[0:15] ==# '/tmp/.mount_nvim')
        let exe_path = trim(system('which nvim'))
        if (v:shell_error)
            return v:false
        endif
    endif

    return exe_path
endfunction

function! RunCommand(cmd, sudo_passwd = v:null)
    if a:sudo_passwd is v:null
        call system(a:cmd)
    else
        call system('sudo -S ' . a:cmd, a:sudo_passwd)
    endif
    return v:shell_error
endfunction

" returns v:true if successful, else v:false
function! InstallNvimToLocation(location, sudo = v:null)
    let url = 'https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage'

    try
        let temp = tempname()
        call system(["wget", "-q", "-O", temp, url])
        if v:shell_error
            echom "Failed to download Neovim."
        endif
        let rc = RunCommand("mv " . temp . " " . a:location, a:sudo)
        if rc != 0
            echom "Failed to move binary to destination."
        endif
        let rc = RunCommand("chmod +x " . a:location, a:sudo)
        if rc != 0
            echom "Failed to move binary to destination."
        endif
        return rc == 0
    catch
    endtry

    return v:false
endfunction

function! NeedSudo(path)
    if isdirectory(a:path)  " existing dir
        return filewritable(a:path) != 2
    elseif !empty(glob(a:path))  " existing file
        return filewritable(a:path) != 1
    else  " hypothetical filename, so we need to check the parent dir permissions
        return filewritable(fnamemodify(a:path, ':h')) != 2
    endif
endfunction

function! Trueish(val)
    let t = type(a:val)

    if t == 1  " string
        return strchars(a:val) > 0
    endif

    return a:val
endfunction

" returns v:true if successful, else v:false
function! InstallNvim()
    let paths = split($PATH, ':')

    let existing = FindExistingInstall()
    let default = Trueish(existing) ? existing : (Trueish(paths[0]) ? paths[0] : expand('~/.local/bin/nvim'))

    let location = trim(input('Install where? [default: ' . default . '] '))
    echom "\n"
    let location = location != '' ? location : default

    let passwd = v:null
    if NeedSudo(location)
        let passwd = inputsecret("[sudo] password for " . $USER . ": ")
        echom "\n"
    endif

    let success = InstallNvimToLocation(location, passwd)
    if success
        echom 'Neovim installed to ' . location . '.'
    else
        echom 'Failed to install to ' . location . '.'
    endif

    return v:false
endfunction
command! InstallNvim call InstallNvim()

function! SynStack()
    if !exists("*synstack")
        return
    endif
    let l:s = synstack(line('.'), col('.'))
    echo join(map(l:s, 'synIDattr(v:val, "name") . " (" . synIDattr(synIDtrans(v:val), "name") .")"'), ', ')
endfunction

function! OpenParentInSplit()
    exec 'SP ' . expand('%:p:h')
endfunction
command! Parent call OpenParentInSplit()

function! WriteSiblingFile(name)
    let l:passed_extension = len(fnamemodify(a:name, ':e')) > 0
    let l:fp = expand('%:p:h') . '/' . a:name . (l:passed_extension ? '' : '.' . expand('%:p:e:e:e'))
    exec 'w ' . l:fp
    exec 'e ' . l:fp
endfunction
command! -nargs=1 WriteSibling call WriteSiblingFile(<f-args>)

function! GetVisualSelection(sep = "\n")
    " Why is this not a built-in Vim script function?!
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, a:sep)
endfunction

" }}}
" Autocommands {{{

" autotrim trailing whitespace
autocmd FileType python,php,javascript,text,markdown,typescript,vim autocmd BufWritePre <buffer> %s/\s\+$//e

augroup filetypes
    autocmd!
    autocmd FileType help setlocal nolist
    autocmd FileType gitcommit setlocal cc=72
    " set indicator at row 80 for easier compliance with PEP 8
    autocmd FileType python setlocal commentstring=#\ %s cc=80
    autocmd FileType markdown setlocal cc=80 textwidth=80
    autocmd FileType sh,bash,yaml,html,css setlocal tabstop=2 shiftwidth=2 softtabstop=2
    autocmd BufEnter *.zsh-theme setlocal filetype=zsh
    if has('nvim')
        autocmd TermOpen * startinsert
    endif
    " plugin autocommands
    autocmd FileType vim let b:argwrap_line_prefix = '\'
augroup END

" }}}
" Load Neovim Config {{{
if has('nvim')
    lua require('dotfiles').setup()
endif

" allow machine-specific settings to be loaded
for file in split(glob('~/.vimrc.d/*.vim'), '\n')
  execute 'source ' . file
endfor

" }}}
