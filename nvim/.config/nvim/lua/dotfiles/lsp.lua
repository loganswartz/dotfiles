local M = {}

function M.setup()
    vim.lsp.inlay_hint.enable()

    vim.lsp.config('*', {})
end

return M
