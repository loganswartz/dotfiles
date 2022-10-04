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

local M = {
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
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            pattern = { '*' },
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
            local opts = { buffer = bufnr, noremap = true, silent = true }

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
            map('<leader>ts', function() TsHelperMenu:mount() end)
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
            local override = overrides[lsp] or function(opts) return opts end
            local new_opts = override(vim.deepcopy(options))

            if lsp == 'tsserver' then
                local ok, typescript = pcall(require, 'typescript')
                if ok then
                    typescript.setup({
                        server = new_opts,
                    })
                end
            else
                lspconfig[lsp].setup(new_opts)
            end
        end
    end
}

return M
