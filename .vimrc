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
" Global Options {{{
set termguicolors

" have Vim load indentation rules and plugins according to the detected
" filetype.
if has("autocmd")
    filetype plugin indent on
    set omnifunc=syntaxcomplete#Complete
endif

" this is now set in the packer config() method for the colorscheme
" colorscheme selenized_bw

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

" }}}
" Plugins {{{
" Installed Plugins {{{

lua <<EOF
lsp_servers = {
    'pyright',
    'tsserver',
    'sqlls',
    'rust_analyzer',
    'intelephense',
    'omnisharp',
    'graphql',
    'gopls',
    'eslint',
    'dockerls',
    'bashls',
    'tailwindcss',
    'vimls',
    'sqls',
    'yamlls',
    'jsonls',
}

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
    use 'tpope/vim-eunuch'
    use 'junegunn/gv.vim'
    use 'junegunn/goyo.vim'
    use 'FooSoft/vim-argwrap'
    use 'honza/vim-snippets'
    use 'lambdalisue/suda.vim'
    use 'wellle/targets.vim'
    use 'tpope/vim-dadbod'
    use 'kristijanhusak/vim-dadbod-ui'
    use {
        'psf/black',
        branch = 'stable',
    }

    -- LSP
    use {
        'CosmicNvim/cosmic-ui',
        requires = {
            'MunifTanjim/nui.nvim',
            'nvim-lua/plenary.nvim',
            'ray-x/lsp_signature.nvim',
            'rcarriga/nvim-notify',
        },
        config = function()
            -- enable nvim-notify since cosmic-ui requires it
            vim.notify = require('notify')

            -- fix hover window border
            local cosmic_ui = require('cosmic-ui')
            local border = cosmic_ui.get_border()

            cosmic_ui.setup({})
            function map(mode, lhs, rhs, opts)
                local options = { noremap = true, silent = true }
                if opts then
                    options = vim.tbl_extend('force', options, opts)
                end
                vim.api.nvim_set_keymap(mode, lhs, rhs, options)
            end

            -- -- See `:help vim.lsp.*` for documentation on any of the below functions
            -- map('n', 'gd', '<cmd>lua require("telescope.builtin").lsp_definitions()<cr>')
            -- map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')
            -- map('n', 'gi', '<cmd>lua require("telescope.builtin").lsp_implementations()<cr>')
            -- map('n', 'gt', '<cmd>lua require("telescope.builtin").lsp_type_definitions()<cr>')
            -- map('n', 'gr', '<cmd>lua require("telescope.builtin").lsp_references()<cr>')
            -- map('n', '<leader>r', '<cmd>lua require("cosmic-ui").rename()<cr>')
            -- buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

            -- -- diagnostics
            -- map('n', '[g', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
            -- map('n', ']g', '<cmd>lua vim.diagnostic.goto_next()<cr>')
            -- map('n', 'ge', '<cmd>lua vim.diagnostic.open_float(nil, { scope = "line", })<cr>')
            -- map('n', '<leader>ge', '<cmd>Telescope diagnostics bufnr=0<cr>')

            -- -- hover
            -- map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')

            -- -- typescript helpers
            -- map('n', '<leader>gr', ':TSLspRenameFile<CR>')
            -- map('n', '<leader>go', ':TSLspOrganize<CR>')
            -- map('n', '<leader>gi', ':TSLspImportAll<CR>')
        end,
        after = 'nvim-lspconfig',
    }
    use 'neovim/nvim-lspconfig'
    use {
        'williamboman/nvim-lsp-installer',
        config = function()
            local lsp_installer = require("nvim-lsp-installer")
            for _, name in pairs(lsp_servers) do
                local server_is_found, server = lsp_installer.get_server(name)
                if server_is_found then
                    if not server:is_installed() then
                        print("Installing " .. name)
                        server:install()
                    end
                end
            end

            local nvim_lsp = require('lspconfig')

            local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
            local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

            -- Enable completion triggered by <c-x><c-o>
            buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

            -- Mappings.
            local opts = { noremap=true, silent=true }

            -- Use an on_attach function to only map the following keys
            -- after the language server attaches to the current buffer
            local on_attach = function(client, bufnr)
                local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
                local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

                -- Enable completion triggered by <c-x><c-o>
                buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

                -- Mappings.
                local opts = { noremap=true, silent=true }

                -- See `:help vim.lsp.*` for documentation on any of the below functions
                buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
                buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
                buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
                buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
                buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)

                buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
                buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
                buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
                buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
                buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
                buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
                buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
                buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
                buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
                buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
                buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
                buf_set_keymap('n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

                -- typescript helpers
                buf_set_keymap('n', '<leader>gr', ':TSLspRenameFile<CR>', opts)
                buf_set_keymap('n', '<leader>go', ':TSLspOrganize<CR>', opts)
                buf_set_keymap('n', '<leader>gi', ':TSLspImportAll<CR>', opts)
            end

            -- Setup lspconfig.
            local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

            lsp_installer.on_server_ready(function(server)
                local opts = {
                    on_attach = on_attach,
                    flags = {
                        debounce_text_changes = 150,
                    },
                    capabilities = capabilities,
                }
                server:setup(opts)
            end)
        end
    }
    use {
        'hrsh7th/nvim-cmp',
        requires = {
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'onsails/lspkind-nvim',
        },
        after = 'cosmic-ui',
        config = function()
            vim.api.nvim_command('set completeopt=menu,menuone,noselect')

            local cmp = require('cmp')
            local cosmic_ui = require('cosmic-ui')

            local has_words_before = function()
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
            end
            local get_formatting = function()
                local ok, _ = pcall(require, 'lspkind')
                if not ok then
                    return {}
                end

                return {
                    format = require('lspkind').cmp_format({
                        with_text = true,
                        menu = {
                            buffer = '[buf]',
                            nvim_lsp = '[LSP]',
                            nvim_lua = '[VimApi]',
                            path = '[path]',
                            luasnip = '[snip]',
                        },
                    }),
                }
            end

            cmp.setup({
                snippet = {
                    -- REQUIRED - you must specify a snippet engine
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
                mapping = {
                    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
                    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
                    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
                    ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
                    ['<C-e>'] = cmp.mapping({
                        i = cmp.mapping.abort(),
                        c = cmp.mapping.close(),
                    }),
                    ['<CR>'] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Insert,
                        select = true,
                    }),
                    ['<Tab>'] = cmp.mapping(function(fallback)
                            if cmp.visible() then
                                cmp.select_next_item()
                            elseif require('luasnip').expand_or_jumpable() then
                                require('luasnip').expand_or_jump()
                            elseif has_words_before() then
                                cmp.complete()
                            else
                                fallback()
                            end
                        end, {
                            'i',
                            's',
                            }),
                        ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif require('luasnip').jumpable(-1) then
                            require('luasnip').jump(-1)
                        else
                            fallback()
                        end
                    end, {
                        'i',
                        's',
                    }),
                },
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'nvim_lua' },
                    { name = 'buffer' },
                    { name = 'luasnip' },
                    { name = 'path' },
                }),
                documentation = {
                    border = cosmic_ui.get_border(),
                    winhighlight = 'FloatBorder:FloatBorder,Normal:Normal',
                },
                experimental = {
                    ghost_text = true,
                },
                formatting = get_formatting(),
            })

            -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline('/', {
                sources = {
                    { name = 'buffer' }
                }
            })

            -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline(':', {
                sources = cmp.config.sources({
                    { name = 'path' }
                }, {
                    { name = 'cmdline' }
                })
            })

        end
    }

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
                    layout_strategy = "flex",
                    layout_config = {
                        flex = {
                            flip_columns = 130,
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
                        {'diagnostics', sources={'nvim_diagnostic', 'coc'}},
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
    use {
        'jan-warchol/selenized',
        rtp = 'editors/vim',
        config = function()
            vim.cmd('colorscheme selenized_bw')
        end,
    }
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
    let exe_path = v:progpath
    " if the progpath is the path inside the appimage
    if (exe_path[0:15] ==# '/tmp/.mount_nvim')
        let exe_path = trim(system('which nvim'))
        if (v:shell_error)
            echom 'Failed to find Neovim executable location.'
            return v:false
        endif
    endif

    " download the new image
    let temp = tempname()
    echom 'Downloading....'
    try
        let downloaded = system("wget -q -O " . temp . " " . url)
    catch
        echom 'Failed to download new version.'
        return v:false
    endtry
    " move into place
    try
        let passwd = inputsecret("[sudo] password for " . $USER . ": ")
        echom "\n"
        let continue = input('The new version will be installed to ' . exe_path . '. Continue? [y/n] ')
        echom "\n"
        if (continue ==? 'y')
            let moved = system("sudo -S mv " . temp . " " . exe_path, passwd)
            let moved = system("sudo -S chmod +x " . exe_path, passwd)
            echom 'Neovim updated! (restart required)'
            return v:true
        endif
    catch
        echom 'Failed to move downloaded update to ' . exe_path . '.'
    endtry

    return v:false
endfunction
command! UpgradeNvim call UpgradeNvim()

" }}}
" Autocommands {{{

" autotrim trailing whitespace
autocmd FileType python,php,javascript,text,markdown,typescript,vim autocmd BufWritePre <buffer> %s/\s\+$//e

augroup filetypes
    autocmd!
    autocmd FileType help setlocal nolist
    " set indicator at row 80 for easier compliance with PEP 8
    autocmd FileType python setlocal commentstring=#\ %s cc=80
    autocmd FileType python autocmd BufWritePre <buffer> execute ':Black'
    autocmd BufEnter *.zsh-theme setlocal filetype=zsh
    autocmd BufEnter *.sh setlocal tabstop=2 shiftwidth=2 softtabstop=2
    if has('nvim')
        autocmd TermOpen * startinsert
    endif
    " plugin autocommands
    autocmd FileType vim let b:argwrap_line_prefix = '\'
augroup END

augroup templates
    autocmd BufNewFile * call LoadTemplate(s:NEOVIM_DIR . '/templates')
augroup END

augroup colors
    " autocmd Colorscheme * hi Normal guibg=NONE ctermbg=NONE " transparent bg
augroup END

" }}}
