local M = {}

function M.setup()
    vim.diagnostic.config({
        float = { source = true },
        virtual_text = false,
        virtual_lines = {
            highlight_whole_line = true,
        },
        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = '',
                [vim.diagnostic.severity.WARN] = '󰉀',
                [vim.diagnostic.severity.INFO] = '󰙎',
                [vim.diagnostic.severity.HINT] = '󰌵',
            },
            -- linehl = {
            --     [vim.diagnostic.severity.ERROR] = 'DiagnosticVirtualTextError',
            --     [vim.diagnostic.severity.WARN] = 'DiagnosticVirtualTextWarn',
            --     [vim.diagnostic.severity.INFO] = 'DiagnosticVirtualTextInfo',
            --     [vim.diagnostic.severity.HINT] = 'DiagnosticVirtualTextHint',
            -- },
            numhl = {
                [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
                [vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
                [vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
                [vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
            },
        }
    })

    vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DiagnosticSignError', linehl = '', numhl = '' })
    vim.fn.sign_define('DapBreakpointCondition', { text = '', texthl = 'DiagnosticSignWarn', linehl = '', numhl = '' })
    vim.fn.sign_define('DapBreakpointRejected', { text = '󰜺', texthl = 'DiagnosticSignError', linehl = '', numhl = '' })
    vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'DiagnosticSignInfo', linehl = '', numhl = '' })

    -- disable virtual lines for the lazy.nvim window
    local LAZY_NAMESPACE = vim.api.nvim_get_namespaces().lazy
    if LAZY_NAMESPACE ~= nil then
        vim.diagnostic.config({
            virtual_text = true,
            virtual_lines = false,
        }, LAZY_NAMESPACE)
    end
end

return M
