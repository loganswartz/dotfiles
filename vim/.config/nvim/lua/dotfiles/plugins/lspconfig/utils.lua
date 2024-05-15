local M = {}

-- Setup an LSP, allowing for server-specific modifications
function M.setup_lsp(lsp, options)
    local lspconfig_setup = require("lspconfig")[lsp].setup

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
    }

    local override = overrides[lsp]
    if override == nil then
        return lspconfig_setup(options)
    else
        return override(lspconfig_setup, options)
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

    -- vim.diagnostic.config({
    --     float = { source = 'always' },
    --     virtual_text = {
    --         prefix = '', -- Could be '•', '●', '■', '▎', 'x', etc
    --         format = function(diagnostic)
    --             local sign = signs[diagnostic.severity].sign
    --             return string.format(sign .. " %s", diagnostic.message)
    --         end
    --     }
    -- })

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
    -- Setup lspconfig
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    -- add border to hover and signatureHelp floats
    local handlers = {
        ["textDocument/rename"] = M.notify_rename,
        ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' }),
        ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' }),
    }

    local options = {
        capabilities = capabilities,
        handlers = handlers,
        on_attach = function(client, bufnr)
            -- Don't format if we're in a git merge
            if not M.are_git_merging(bufnr) then
                require('lsp-format').on_attach(client, bufnr)
            end
        end,
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

function M.inlay_hints(bufnr, value)
    if bufnr == nil then
        bufnr = vim.api.nvim_get_current_buf()
    end

    local clients = vim.lsp.get_clients({ bufnr })
    local supports_inlay_hints = vim.tbl_filter(function(client)
        return client.supports_method('textDocument/inlayHint')
    end, clients)

    if #supports_inlay_hints == 0 then
        return
    end

    local ih = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint
    if type(ih) == "function" then
        ih(value)
    elseif type(ih) == "table" and ih.enable then
        if value == nil then
            value = not ih.is_enabled(bufnr)
        end
        ih.enable()
    end
end

return M
