local M = {}

function ConfiguredLSPs()
    return {
        'pyright',
        'tsserver',
        -- 'graphql',
        'intelephense',
        'dockerls',
        'bashls',
        'vimls',
        'yamlls',
        'jsonls',
        'sumneko_lua',
        'rust_analyzer',
    }
end

M.ConfiguredLSPs = ConfiguredLSPs

function M.setup()
    require('packer').startup({ function(use)
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
        use 'arthurxavierx/vim-caser'
        use 'junegunn/gv.vim'
        use 'junegunn/goyo.vim'
        use {
            'FooSoft/vim-argwrap',
            config = function()
                vim.keymap.set('n', 'gw', ':ArgWrap<CR>')
                vim.g.argwrap_tail_comma = true
            end,
        }
        use {
            'norcalli/nvim-colorizer.lua',
            config = function()
                require('colorizer').setup()
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
                local formatting = require('dotfiles.utils.formatting')
                null_ls.setup({
                    sources = {
                        null_ls.builtins.formatting.black,
                        null_ls.builtins.formatting.gofmt,
                        null_ls.builtins.formatting.rustfmt,
                        null_ls.builtins.formatting.prettierd.with({
                            timeout = 1000,
                            disabled_filetypes = { 'yaml' },
                        }),
                        null_ls.builtins.diagnostics.codespell,
                    },
                    on_attach = function(client, bufnr)
                        -- autoformat on save
                        if client.supports_method("textDocument/formatting") then
                            vim.api.nvim_clear_autocmds({ group = formatting.LspAugroup, buffer = bufnr })
                            vim.api.nvim_create_autocmd("BufWritePre", {
                                group = formatting.LspAugroup,
                                buffer = bufnr,
                                callback = function()
                                    formatting.LspFormat(bufnr)
                                end,
                            })
                        end
                    end,
                })
            end,
        }
        use 'jose-elias-alvarez/typescript.nvim'
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
                require('nvim-lsp-installer').setup({
                    ensure_installed = ConfiguredLSPs(),
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
                vim.api.nvim_create_autocmd({'CursorHold','CursorHoldI'}, {
                    pattern = {'*'},
                    callback = require('dotfiles.utils.helpers').auto_open_diag_hover,
                })
                local formatting = require('dotfiles.utils.formatting')

                -- Use an on_attach function to only map the following keys
                -- after the language server attaches to the current buffer
                local on_attach = function(client, bufnr)
                    -- autoformat on save
                    if client.supports_method("textDocument/formatting") then
                        vim.api.nvim_clear_autocmds({ group = formatting.LspAugroup, buffer = bufnr })
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            group = formatting.LspAugroup,
                            buffer = bufnr,
                            callback = function()
                                formatting.LspFormat(bufnr)
                            end,
                        })
                    end

                    -- Enable completion triggered by <c-x><c-o>
                    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

                    -- Mappings.
                    local opts = { buffer=bufnr, noremap=true, silent=true }

                    local function map(mapping, cmd) return vim.keymap.set('n', mapping, cmd, opts) end

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
                    map('<leader>f', '<cmd>lua require("dotfiles.utils.formatting").LspFormat()<CR>')

                    -- diagnostics
                    map('[g', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
                    map(']g', '<cmd>lua vim.diagnostic.goto_next()<cr>')
                    map('ge', '<cmd>lua vim.diagnostic.open_float(nil, { scope = "line", })<cr>')
                    map('<leader>ge', '<cmd>Telescope diagnostics bufnr=0<cr>')

                    -- hover
                    map('K', '<cmd>lua vim.lsp.buf.hover()<cr>')
                    map('<C-k>', '<cmd>lua vim.lsp.buf.hover()<CR>')

                    -- typescript helpers
                    local TsHelperMenu = require('dotfiles.menus.ts_helper')
                    map('<leader>ts', function () TsHelperMenu:mount() end)
                end

                -- Setup lspconfig
                local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

                -- add border to hover and signatureHelp floats
                local handlers = {
                    ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'solid' }),
                    ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'solid' }),
                }
                local options = {
                    on_attach = on_attach,
                    capabilities = capabilities,
                    handlers = handlers,
                }

                -- special configs for certain LSPs
                local overrides = {
                    ["sumneko_lua"] = function(opts)
                        local lua_dev = require('lua-dev').setup({
                            settings = {
                                Lua = {
                                    workspace = {
                                        preloadFileSize = 500
                                    }
                                }
                            }
                        })

                        return vim.tbl_deep_extend("force", lua_dev, opts)
                    end,
                }

                for _, lsp in pairs(ConfiguredLSPs()) do
                    local override = overrides[lsp] or function (opts) return opts end

                    local new_opts = override(vim.deepcopy(options))
                    lspconfig[lsp].setup(new_opts)

                    if lsp == 'tsserver' then
                        local ok, typescript = pcall(require, 'typescript')
                        if ok then
                            typescript.setup({
                                server = new_opts,
                            })
                        end
                    end
                end
            end
        }
        use {
            'hrsh7th/nvim-cmp',
            requires = {
                'saadparwaiz1/cmp_luasnip',
                'L3MON4D3/LuaSnip',
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

                local navigate_next = cmp.mapping(function(fallback)
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

                local navigate_previous = cmp.mapping(function(fallback)
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
                -- https://github.com/lukas-reineke/indent-blankline.nvim/issues/265#issuecomment-942000366
                local opts = {silent = true, noremap = true}
                vim.keymap.set('n', 'za', 'za:IndentBlanklineRefresh<CR>', opts)
                vim.keymap.set('n', 'zA', 'zA:IndentBlanklineRefresh<CR>', opts)
                vim.keymap.set('n', 'zo', 'zo:IndentBlanklineRefresh<CR>', opts)
                vim.keymap.set('n', 'zO', 'zO:IndentBlanklineRefresh<CR>', opts)
                vim.keymap.set('n', 'zR', 'zR:IndentBlanklineRefresh<CR>', opts)
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
            requires = { 'nvim/lua/plenary.nvim' },
            config = function()
                local builtins = require('telescope.builtin')
                local previewers = require('telescope.previewers')

                require('telescope').setup {
                    defaults = {
                        mappings = {
                            i = {
                                ["<C-u>"] = false
                            },
                        },
                        layout_strategy = "flex",
                        layout_config = {
                            flex = {
                                flip_columns = 130,
                            },
                        },
                        set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
                        file_previewer = previewers.vim_buffer_cat.new,
                        grep_previewer = previewers.vim_buffer_vimgrep.new,
                        qflist_previewer = previewers.vim_buffer_qflist.new,
                        vimgrep_arguments = {
                            "rg",
                            "--color=never",
                            "--no-heading",
                            "--with-filename",
                            "--line-number",
                            "--column",
                            "--smart-case",
                            "--trim"
                        }
                    },
                }

                vim.keymap.set('n', '<leader>ff', builtins.find_files)
                vim.keymap.set('n', '<leader>fg', function () builtins.live_grep({
                    additional_args = { "--pcre2" },
                }) end)
                vim.keymap.set('n', '<leader>fb', builtins.buffers)
                vim.keymap.set('n', '<leader>fh', builtins.help_tags)
                vim.keymap.set('n', '<leader>fd', builtins.diagnostics)
                vim.keymap.set('n', '<leader>fs', builtins.git_status)
            end
        }
        use 'nvim-treesitter/playground'
        use {
            'nvim-treesitter/nvim-treesitter',
            run = function() pcall(vim.cmd, 'TSUpdate') end,
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
            config = function()
                vim.g.selenized_variant = 'bw'
                vim.cmd('colorscheme selenized')
            end,
        }

        -- Colorschemes
        use {
            'navarasu/onedark.nvim',
            config = function()
                vim.g.onedark_transparent_background = true
                vim.g.onedark_italic_comment = false
            end,
        }
        end,

        config = {
            display = {
                open_fn = function()
                    return require('packer.util').float()
                end,
            },
        },
    })
end

return M
