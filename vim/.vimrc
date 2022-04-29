" My .vimrc
" To make this easier to read, open in vim and do `:set foldmethod=marker` and
" then do `zM` in normal mode. Open and close folds with `za`.

" First Time Setup {{{
" Alias init.vim to ~/.vimrc
if empty(glob(stdpath('config') . '/init.vim'))
    exec "silent !mkdir -p " . stdpath('config') . " && printf 'source ~/.vimrc' > " . stdpath('config') . '/init.vim'
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

let g:selenized_variant = 'bw'
colorscheme selenized

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

" more aesthetically pleasing color column
highlight ColorColumn ctermbg=236

" }}}
" Plugins {{{

lua <<EOF
lsp_servers = {
    'pyright',
    'tsserver',
    'rust_analyzer',
    'intelephense',
    -- 'omnisharp',
    'graphql',
    'dockerls',
    'bashls',
    'tailwindcss',
    'vimls',
    'yamlls',
    'jsonls',
    'sumneko_lua',
    'sqls',
}

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Vimscript
    use 'dstein64/vim-startuptime'
    use 'alvan/vim-closetag'
    use 'tpope/vim-surround'
    use 'tpope/vim-fugitive'
    use 'tpope/vim-speeddating'
    use 'tpope/vim-vinegar'
    use {
        'joereynolds/place.vim',
        config = function()
            vim.keymap.set('n', 'ga', '<Plug>(place-insert)')
            vim.keymap.set('n', 'gb', '<Plug>(place-insert-multiple)')
        end,
    }
    use 'tpope/vim-eunuch'
    use 'junegunn/gv.vim'
    use 'junegunn/goyo.vim'
    use {
        'FooSoft/vim-argwrap',
        config = function()
            vim.keymap.set('n', 'gw', ':ArgWrap<CR>')
            vim.g.argwrap_tail_comma = true
        end,
    }
    use 'lambdalisue/suda.vim'
    use 'wellle/targets.vim'
    use {
        'tpope/vim-dadbod',
        config = function()
            -- za or return to open drawer option (same as folds)
            local function remapDbuiToggle(combo)
                return function ()
                    vim.keymap.set('n', combo, '<Plug>(DBUI_SelectLine)', { buffer = true })
                end
            end
            vim.api.nvim_create_autocmd({ 'FileType' }, {
                pattern = 'dbui',
                callback = remapDbuiToggle('za'),
            })
            vim.api.nvim_create_autocmd({ 'FileType' }, {
                pattern = 'dbui',
                callback = remapDbuiToggle('<CR>'),
            })
            vim.fn['db_ui#utils#set_mapping']('<C-E>', '<Plug>(DBUI_ExecuteQuery)')

            -- run a single query instead of the whole file (analogous to dbeaver's Ctrl+Enter)
            -- vim.keymap.set('n', '<C-E>', 'vip\S')
        end,
    }
    use 'kristijanhusak/vim-dadbod-ui'
    use {
        'psf/black',
        config = function()
            vim.g.black_quiet = true
        end,
    }
    use {
        'tibabit/vim-templates',
        config = function()
            vim.g.tmpl_search_paths = { vim.fn.stdpath('config') .. '/templates' }
        end,
    }
    use {
        'mrjones2014/smart-splits.nvim',
        config = function()
            -- resizing splits
            vim.keymap.set('n', '<A-Left>', require('smart-splits').resize_left)
            vim.keymap.set('n', '<A-Down>', require('smart-splits').resize_down)
            vim.keymap.set('n', '<A-Up>', require('smart-splits').resize_up)
            vim.keymap.set('n', '<A-Right>', require('smart-splits').resize_right)

            -- moving between splits
            vim.keymap.set('n', '<C-Left>', require('smart-splits').move_cursor_left)
            vim.keymap.set('n', '<C-Down>', require('smart-splits').move_cursor_down)
            vim.keymap.set('n', '<C-Up>', require('smart-splits').move_cursor_up)
            vim.keymap.set('n', '<C-Right>', require('smart-splits').move_cursor_right)
        end,
    }
    use {
        'rhysd/git-messenger.vim',
        config = function()
            vim.g.git_messenger_floating_win_opts = { border = 'rounded' }
            vim.g.git_messenger_popup_content_margins = false
        end,
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

            require('cosmic-ui').setup({
                border_style = 'rounded',
            })

            function map(mode, lhs, rhs, opts)
                local options = { noremap = true, silent = true }
                if opts then
                    options = vim.tbl_extend('force', options, opts)
                end
                vim.api.nvim_set_keymap(mode, lhs, rhs, options)
            end
        end,
        after = 'nvim-lspconfig',
    }
    use {
        'jose-elias-alvarez/null-ls.nvim',
        requires = {
            'nvim-lua/plenary.nvim',
        },
        config = function()
            local null_ls = require('null-ls')
            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.black,
                    null_ls.builtins.formatting.gofmt,
                    null_ls.builtins.formatting.rustfmt,
                    null_ls.builtins.formatting.sqlformat,
                    null_ls.builtins.formatting.prettierd.with({
                        timeout = 1000,
                        disabled_filetypes = { 'yaml' },
                    }),
                    null_ls.builtins.diagnostics.codespell,
                },
                on_attach = function(client)
                    if client.resolved_capabilities.document_formatting then
                        -- https://github.com/nanotee/nvim-lua-guide#defining-autocommands
                        vim.cmd([[
                            augroup LspFormatting
                                autocmd! * <buffer>
                                autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
                            augroup END
                        ]])
                    end
                end,
            })
        end,
    }
    use 'jose-elias-alvarez/nvim-lsp-ts-utils'
    use 'folke/lua-dev.nvim'
    use 'nanotee/sqls.nvim'
    use {
        'williamboman/nvim-lsp-installer',
        -- after = 'nvim-cmp',
        requires = { 'rcarriga/nvim-notify' },
    }
    use {
        'neovim/nvim-lspconfig',
        after = 'nvim-lsp-installer',
        config = function()
            -- autoinstall LSPs
            require("nvim-lsp-installer").setup({
                ensure_installed = lsp_servers,
                automatic_installation = true,
            })

            local lspconfig = require("lspconfig")

            vim.notify = require('notify')
            vim.diagnostic.config({
                float = { source = 'always' },
                virtual_text = {
                    prefix = '•', -- Could be '●', '■', '▎', 'x', etc
                }
            })
            -- change diagnostic gutter signs
            local signs = { Error = "", Warn = "", Info = "", Hint = "" }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
            end

            -- auto-open diagnostic warnings on hover if pum not already open
            vim.o.updatetime = 150
            function AutoOpenDiagnosticHover()
                local function is_float_window(id)
                    return vim.api.nvim_win_get_config(id).relative ~= ''
                end
                local float_is_open = vim.tbl_count(vim.tbl_filter(is_float_window, vim.api.nvim_list_wins())) > 0
                if not float_is_open then
                    vim.diagnostic.open_float(nil, {focus=false, scope="cursor"})
                end
            end
            vim.api.nvim_create_autocmd({'CursorHold','CursorHoldI'}, {
                pattern = {'*'},
                callback = AutoOpenDiagnosticHover,
            })

            -- Use an on_attach function to only map the following keys
            -- after the language server attaches to the current buffer
            local on_attach = function(client, bufnr)
                -- enable autoformatting on save
                if client.resolved_capabilities.document_formatting then
                    vim.api.nvim_create_autocmd({'BufWritePre'}, {
                        pattern = {'<buffer>'},
                        callback = vim.lsp.buf.formatting_sync,
                    })
                end

                -- Enable completion triggered by <c-x><c-o>
                vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

                -- Mappings.
                local opts = { buffer=bufnr, noremap=true, silent=true }

                function map(mapping, cmd) return vim.keymap.set('n', mapping, cmd, opts) end

                -- See `:help vim.lsp.*` for documentation on any of the below functions
                map('<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
                map('gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')
                map('gd', '<cmd>lua require("telescope.builtin").lsp_definitions()<cr>')
                map('gi', '<cmd>lua require("telescope.builtin").lsp_implementations()<cr>')
                map('gt', '<cmd>lua require("telescope.builtin").lsp_type_definitions()<cr>')
                map('gr', '<cmd>lua require("telescope.builtin").lsp_references()<cr>')
                map('<leader>r', '<cmd>lua require("cosmic-ui").rename()<cr>')
                map('<leader>ga', '<cmd>lua require("cosmic-ui").code_actions()<CR>')

                -- workspace stuff
                map('<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
                map('<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
                map('<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')

                -- actions
                -- vim.keymap.set('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
                map('<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>')
                map('<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>')
                map('<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>')

                -- diagnostics
                map('[g', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
                map(']g', '<cmd>lua vim.diagnostic.goto_next()<cr>')
                map('ge', '<cmd>lua vim.diagnostic.open_float(nil, { scope = "line", })<cr>')
                map('<leader>ge', '<cmd>Telescope diagnostics bufnr=0<cr>')

                -- hover
                map('K', '<cmd>lua vim.lsp.buf.hover()<cr>')
                map('<C-k>', '<cmd>lua vim.lsp.buf.hover()<CR>')

                -- typescript helpers
                map('<leader>gr', ':TSLspRenameFile<CR>')
                map('<leader>go', ':TSLspOrganize<CR>')
                map('<leader>gi', ':TSLspImportAll<CR>')
            end

            -- Setup lspconfig.
            local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

            -- add border to hover and signatureHelp floats
            local border = {
                {"╭", "FloatBorder"},
                {"─", "FloatBorder"},
                {"╮", "FloatBorder"},
                {"│", "FloatBorder"},
                {"╯", "FloatBorder"},
                {"─", "FloatBorder"},
                {"╰", "FloatBorder"},
                {"│", "FloatBorder"},
            }
            local handlers = {
                ["textDocument/hover"] =  vim.lsp.with(vim.lsp.handlers.hover, {border = border}),
                ["textDocument/signatureHelp"] =  vim.lsp.with(vim.lsp.handlers.signature_help, {border = border }),
            }
            local opts = {
                on_attach = on_attach,
                capabilities = capabilities,
                handlers = handlers,
            }

            -- special configs for certain LSPs
            local overrides = {
                ["sumneko_lua"] = function(opts)
                    return require("lua-dev").setup({
                        lspconfig = opts,
                    })
                end,
                ["tsserver"] = function(opts)
                    opts.on_attach = function(client, bufnr)
                        local ts_utils = require("nvim-lsp-ts-utils")
                        ts_utils.setup({})
                        ts_utils.setup_client(client)

                        -- prefer null-ls formatting
                        client.resolved_capabilities.document_formatting = false
                        client.resolved_capabilities.document_range_formatting = false
                    end

                    return opts
                end,
                ["sqls"] = function(opts)
                    opts.on_attach = function(client, bufnr)
                        require('sqls').on_attach(client, bufnr)
                    end

                    return opts
                end,
            }

            for _, lsp in pairs(lsp_servers) do
                local override = overrides[lsp] or function (opts) return opts end

                lspconfig[lsp].setup(opts)
            end
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
            vim.o.completeopt='menu,menuone,noselect'

            local cmp = require('cmp')

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
                            nvim_lua = '[Lua]',
                            path = '[path]',
                            luasnip = '[snip]',
                        },
                    }),
                }
            end

            navigate_next = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif require('luasnip').expand_or_jumpable() then
                        require('luasnip').expand_or_jump()
                    elseif has_words_before() then
                        cmp.complete()
                    else
                        fallback()
                    end
                end,
                { 'i', 's', }
            )

            navigate_previous = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif require('luasnip').jumpable(-1) then
                        require('luasnip').jump(-1)
                    else
                        fallback()
                    end
                end,
                { 'i', 's', }
            )

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
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = false,
                    }),
                    ['<Tab>'] = navigate_next,
                    ['<Down>'] = navigate_next,
                    ['<S-Tab>'] = navigate_previous,
                    ['<Up>'] = navigate_previous,
                },
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'nvim_lua' },
                    { name = 'buffer' },
                    { name = 'luasnip' },
                    { name = 'path' },
                }),
                window = {
                    documentation = cmp.config.window.bordered(),
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
            vim.o.listchars = "trail:·,tab:┆─,nbsp:␣"
            vim.o.list = true
        end
    }
    use {
        'numToStr/Comment.nvim',
        requires = { 'JoosepAlviste/nvim-ts-context-commentstring' },
        config = function()
            require('Comment').setup({
                -- NOTE: The example below is a proper integration and it is RECOMMENDED.
                ---@param ctx Ctx
                pre_hook = function(ctx)
                    local U = require('Comment.utils')

                    -- Determine the location where to calculate commentstring from
                    local location = nil
                    if ctx.ctype == U.ctype.block then
                        location = require('ts_context_commentstring.utils').get_cursor_location()
                    elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
                        location = require('ts_context_commentstring.utils').get_visual_start_location()
                    end

                    return require('ts_context_commentstring.internal').calculate_commentstring({
                        -- Determine whether to use linewise or blockwise commentstring
                        key = ctx.ctype == U.ctype.line and '__default' or '__multiline',
                        location = location,
                    })
                end,
            })
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

            vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>')
            vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>')
        end
    }
    use 'nvim-treesitter/playground'
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function()
            require('nvim-treesitter.configs').setup {
                ensure_installed = {
                    'bash', 'c', 'c_sharp', 'cmake',
                    'comment', 'cpp', 'css', 'dockerfile',
                    'go', 'graphql', 'html', 'javascript',
                    'jsdoc', 'json', 'json5', 'jsonc',
                    'julia', 'lua', 'make', 'markdown',
                    'perl', 'php', 'python', 'regex',
                    'rst', 'ruby', 'rust', 'scss',
                    'svelte', 'toml', 'tsx', 'typescript',
                    'vim', 'yaml',
                },
                highlight = {
                    enable = true,
                    disable = { "c", "rust" },
                    additional_vim_regex_highlighting = false,
                },
                indent = {
                    enable = true
                },
                playground = {
                    enable = false,
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
                },
                context_commentstring = {
                    enable = true,
                    enable_autocmd = false,
                },
            }
        end
    }
    use {
        'lewis6991/gitsigns.nvim',
        requires = { 'nvim-lua/plenary.nvim' },
        config = function()
            require("gitsigns").setup {
                signs = {
                    add          = { text = '+' },
                    change       = { text = '~' },
                    delete       = { text = '_' },
                    topdelete    = { text = '‾' },
                    changedelete = { text = '~' },
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
                    theme = "auto",
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
    use {
        'loganswartz/selenized.nvim',
        requires = {
            'rktjmp/lush.nvim',
        },
    }

    -- Colorschemes
    use {
        'navarasu/onedark.nvim',
        config = function()
            vim.g.onedark_transparent_background = true
            vim.g.onedark_italic_comment = false
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
" Key Remaps {{{

" https://github.com/lukas-reineke/indent-blankline.nvim/issues/265#issuecomment-942000366
nnoremap <silent> za za:IndentBlanklineRefresh<CR>
nnoremap <silent> zA zA:IndentBlanklineRefresh<CR>
nnoremap <silent> zo zo:IndentBlanklineRefresh<CR>
nnoremap <silent> zO zO:IndentBlanklineRefresh<CR>
nnoremap <silent> zR zR:IndentBlanklineRefresh<CR>

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

function! SynStack()
    if !exists("*synstack")
        return
    endif
    let l:s = synstack(line('.'), col('.'))
    echo join(map(l:s, 'synIDattr(v:val, "name") . " (" . synIDattr(synIDtrans(v:val), "name") .")"'), ', ')
endfunction

function! Format()
    lua vim.lsp.buf.formatting()
endfunction
command! Format call Format()

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
    autocmd FileType python autocmd BufWritePre <buffer> execute 'lua vim.lsp.buf.formatting_sync()'
    autocmd FileType sh,bash,yaml setlocal tabstop=2 shiftwidth=2 softtabstop=2
    autocmd BufEnter *.zsh-theme setlocal filetype=zsh
    if has('nvim')
        autocmd TermOpen * startinsert
    endif
    " plugin autocommands
    autocmd FileType vim let b:argwrap_line_prefix = '\'
augroup END

augroup colors
    " autocmd Colorscheme * hi Normal guibg=NONE ctermbg=NONE " transparent bg
augroup END

" }}}
