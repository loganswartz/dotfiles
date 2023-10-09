local M = {}

-- Setup an LSP, allowing for server-specific modifications
function M.setup_lsp(lsp, options)
    local setup_server = require("lspconfig")[lsp].setup

    -- Overrides for certain LSPs.
    -- We pass in the setup method and our options, which allows us to do things before AND after setup.
    local overrides = {
        lua_ls = function(setup, opts)
            require('neodev').setup({})

            return setup(vim.tbl_deep_extend("force", opts, {
                settings = {
                    Lua = {
                        workspace = {
                            checkThirdParty = false,
                            preloadFileSize = 500,
                        },
                        hint = {
                            enable = true,
                        },
                    }
                }
            }))
        end,
        phpactor = function(setup, opts)
            return setup(vim.tbl_deep_extend("force", opts, {
                init_options = {
                    ["language_server_phpstan.enabled"] = false,
                }
            }))
        end,
        tsserver = function(setup, opts)
            local result = setup(opts)

            local ok, typescript = pcall(require, 'typescript')
            if ok then
                typescript.setup({
                    server = vim.tbl_deep_extend("force", opts, {
                        settings = {
                            typescript = {
                                inlayHints = {
                                    includeInlayParameterNameHints = 'all',
                                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                                    includeInlayFunctionParameterTypeHints = true,
                                    includeInlayVariableTypeHints = true,
                                    includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                                    includeInlayPropertyDeclarationTypeHints = true,
                                    includeInlayFunctionLikeReturnTypeHints = true,
                                    includeInlayEnumMemberValueHints = true,
                                }
                            },
                            javascript = {
                                inlayHints = {
                                    includeInlayParameterNameHints = 'all',
                                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                                    includeInlayFunctionParameterTypeHints = true,
                                    includeInlayVariableTypeHints = true,
                                    includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                                    includeInlayPropertyDeclarationTypeHints = true,
                                    includeInlayFunctionLikeReturnTypeHints = true,
                                    includeInlayEnumMemberValueHints = true,
                                }
                            }
                        }
                    })
                })
            end

            require('dotfiles.utils.helpers').register_lsp_attach(function(client, bufnr)
                local TsHelperMenu = require('dotfiles.menus.ts_helper')
                vim.keymap.set('n', '<leader>ts', TsHelperMenu, { buffer = bufnr })
            end, { 'tsserver' })

            return result
        end,
        rust_analyzer = function(setup, opts)
            -- use rust-tools.nvim
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
    local default_opts = { buffer = bufnr, noremap = true, silent = true }

    ---@type fun(lhs: string, rhs: string|function, opts: nil)
    local function map(lhs, cmd, opts)
        opts = vim.tbl_deep_extend('force', default_opts, opts)
        return vim.keymap.set('n', lhs, cmd, opts)
    end

    -- workspace stuff
    map('<leader>wa', vim.lsp.buf.add_workspace_folder)
    map('<leader>wr', vim.lsp.buf.remove_workspace_folder)
    map('<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end)

    -- actions
    map('<leader>F', require("dotfiles.utils.formatting").LspFormat)

    -- hover
    map('K', vim.lsp.buf.hover)
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
                    -- avoid dirty merges
                    if not M.are_git_merging() then
                        formatting.LspFormat({ bufnr = bufnr })
                    end
                end,
            })
        end
    end)
end

function M.register_format_command(client, bufnr)
    local format = function()
        require('dotfiles.utils.formatting').LspFormat({ bufnr = bufnr })
    end
    vim.api.nvim_create_user_command('Format', format, {})
end

M.get_relative_path = function(file_path)
    local plenary_path = require('plenary.path')
    local parsed_path, _ = file_path:gsub('file://', '')
    local path = plenary_path:new(parsed_path)
    local relative_path = path:make_relative(vim.fn.getcwd())
    return './' .. relative_path
end

function M.notify_rename(...)
    local result
    local method
    local err = select(1, ...)
    local is_new = not select(4, ...) or type(select(4, ...)) ~= 'number'
    if is_new then
        method = select(3, ...).method
        result = select(2, ...)
    else
        method = select(2, ...)
        result = select(3, ...)
    end

    if err then
        vim.notify(("Error running LSP query '%s': %s"):format(method, err), vim.log.levels.ERROR)
        return
    end

    local new_word = ''
    if result and result.changes then
        local msgs = {}
        for f, c in pairs(result.changes) do
            new_word = c[1].newText
            table.insert(msgs, ('%d changes -> %s'):format(#c, M.get_relative_path(f)))
        end
        local currName = vim.fn.expand('<cword>')
        vim.notify(table.concat(msgs, '\n'), vim.log.levels.INFO, {
            title = ('Rename: %s -> %s'):format(currName, new_word),
        })
    end

    vim.lsp.handlers[method](...)
end

function M.generate_opts()
    M.define_diagnostic_indicators()
    M.configure_pum()
    M.register_autoformatting()
    M.register_format_command()

    -- Use an on_attach function to only map the following keys
    -- after the language server attaches to the current buffer
    local on_attach = function(client, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        M.register_keymaps(bufnr)
    end

    -- Setup lspconfig
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    -- add border to hover and signatureHelp floats
    local handlers = {
        ["textDocument/rename"] = M.notify_rename,
        ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' }),
        ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' }),
    }

    local options = {
        on_attach = on_attach,
        capabilities = capabilities,
        handlers = handlers,
    }

    return options
end

function M.are_git_merging(bufnr)
    bufnr = bufnr or 0
    local file = vim.api.nvim_buf_get_name(bufnr)
    local dir = vim.fn.fnamemodify(file, ':h')

    local cmd = { 'git', '-C', dir, 'rev-parse', '-q', '--verify', 'MERGE_HEAD' }
    return vim.system(cmd, { text = true }):wait().code == 0
end

return M
