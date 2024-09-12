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
                [vim.diagnostic.severity.ERROR] = '',
                [vim.diagnostic.severity.WARN] = '',
                [vim.diagnostic.severity.INFO] = '󰙎',
                [vim.diagnostic.severity.HINT] = '',
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
end

return M
