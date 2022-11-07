local M = {}

-- Setup an LSP, allowing for server-specific modifications
function M.setup_lsp(lsp, options)
    local setup_server = require("lspconfig")[lsp].setup

    -- Overrides for certain LSPs.
    -- We pass in the setup method and our options, which allows us to do things before AND after setup.
    local overrides = {
        sumneko_lua = function(setup, opts)
            require('neodev').setup({})

            return setup(vim.tbl_deep_extend("force", opts, {
                settings = {
                    Lua = {
                        workspace = {
                            preloadFileSize = 500
                        }
                    }
                }
            }))
        end,
        tsserver = function(setup, opts)
            local result = setup(opts)

            local ok, typescript = pcall(require, 'typescript')
            if ok then
                typescript.setup({
                    server = opts,
                })
            end

            require('dotfiles.utils.helpers').register_lsp_attach(function(client, bufnr)
                local TsHelperMenu = require('dotfiles.menus.ts_helper')
                vim.keymap.set('n', '<leader>ts', function() TsHelperMenu:mount() end, { buffer = bufnr })
            end, 'tsserver')

            return result
        end,
        rust_analyzer = function(setup, opts)
            local rt = require("rust-tools")

            rt.setup({
                server = {
                    on_attach = function(_, bufnr)
                        -- Hover actions
                        vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
                        -- Code action groups
                        vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
                    end,
                },
            })
        end,
    }

    local override = overrides[lsp]
    if override == nil then
        return setup_server(options)
    else
        return override(setup_server, options)
    end
end

-- Register indicators / signs for diagnostics.
function M.define_diagnostic_indicators()
    local levels = vim.diagnostic.severity
    local signs = {
        [levels.ERROR] = { sign = "", label = 'Error' },
        [levels.WARN] = { sign = "", label = 'Warn' },
        [levels.INFO] = { sign = "", label = 'Info' },
        [levels.HINT] = { sign = "", label = 'Hint' },
    }

    vim.diagnostic.config({
        float = { source = 'always' },
        virtual_text = {
            prefix = '', -- Could be '•', '●', '■', '▎', 'x', etc
            format = function(diagnostic)
                local sign = signs[diagnostic.severity].sign
                return string.format(sign .. " %s", diagnostic.message)
            end
        }
    })

    for _, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. icon.label
        vim.fn.sign_define(hl, { text = icon.sign, texthl = hl, numhl = hl })
    end
end

-- Configure diagnostic warnings to auto-open on hover if the PUM is not already open.
function M.configure_pum()
    vim.o.updatetime = 150
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        pattern = { '*' },
        callback = require('dotfiles.utils.helpers').auto_open_diag_hover,
    })
end

-- Set all our LSP-related keymaps.
function M.register_keymaps(bufnr)
    local opts = { buffer = bufnr, noremap = true, silent = true }

    local function map(mapping, cmd)
        return vim.keymap.set('n', mapping, cmd, opts)
    end

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    map('<leader>D', vim.lsp.buf.type_definition)
    map('gD', vim.lsp.buf.declaration)
    map('gd', require("telescope.builtin").lsp_definitions)
    map('gi', require("telescope.builtin").lsp_implementations)
    map('gt', require("telescope.builtin").lsp_type_definitions)
    map('gr', require("telescope.builtin").lsp_references)
    map('<leader>r', require("cosmic-ui").rename)
    map('<leader>ga', require("cosmic-ui").code_actions)

    -- workspace stuff
    map('<leader>wa', vim.lsp.buf.add_workspace_folder)
    map('<leader>wr', vim.lsp.buf.remove_workspace_folder)
    map('<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end)

    -- actions
    -- map('<leader>ca', vim.lsp.buf.code_action)
    map('<leader>e', vim.diagnostic.open_float)
    map('<leader>q', vim.diagnostic.setloclist)
    map('<leader>f', require("dotfiles.utils.formatting").LspFormat)

    -- diagnostics
    map('[g', vim.diagnostic.goto_prev)
    map(']g', vim.diagnostic.goto_next)
    map('ge', function() vim.diagnostic.open_float(nil, { scope = "line", }) end)
    map('<leader>ge', '<cmd>Telescope diagnostics bufnr=0<cr>')

    -- hover
    map('K', vim.lsp.buf.hover)
    map('<C-k>', require('dotfiles.documentation').showDocLinks)
end

function M.register_autoformatting()
    local formatting = require('dotfiles.utils.formatting')
    local register = require('dotfiles.utils.helpers').register_lsp_attach

    register(function(client, bufnr)
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
    end)
end

function M.register_format_command(client, bufnr)
    local format = function() require('dotfiles.utils.formatting').LspFormat(bufnr) end
    vim.api.nvim_create_user_command('Format', format, {})
end

function M.register_mason_tools_notification()
    vim.api.nvim_create_autocmd('User', {
        pattern = 'MasonToolsUpdateCompleted',
        callback = function()
            vim.schedule(function()
                vim.notify('mason-tool-installer has finished.')
            end)
        end,
    })
end

return M
