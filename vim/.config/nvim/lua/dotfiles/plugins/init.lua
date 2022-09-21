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
    require('packer').startup({
        function(use)
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
            use(require('dotfiles.plugins.dadbod'))
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
            use(require('dotfiles.plugins.smart-splits'))
            use {
                'rhysd/git-messenger.vim',
                config = function()
                    vim.g.git_messenger_floating_win_opts = { border = 'rounded' }
                    vim.g.git_messenger_popup_content_margins = false
                end,
            }

            -- LSP
            use(require('dotfiles.plugins.cosmic-ui'))
            use(require('dotfiles.plugins.null-ls'))
            use 'jose-elias-alvarez/typescript.nvim'
            use 'folke/lua-dev.nvim'
            use 'nanotee/sqls.nvim'
            use {
                'williamboman/nvim-lsp-installer',
                requires = { 'rcarriga/nvim-notify' },
            }
            use(require('dotfiles.plugins.lspconfig'))
            use(require('dotfiles.plugins.nvim-cmp'))

            -- Lua
            use(require('dotfiles.plugins.indent-blankline'))
            use(require('dotfiles.plugins.comment'))
            use(require('dotfiles.plugins.telescope'))
            use 'nvim-treesitter/playground'
            use(require('dotfiles.plugins.nvim-treesitter'))
            use(require('dotfiles.plugins.lualine'))
            use(require('dotfiles.plugins.gitsigns'))

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
