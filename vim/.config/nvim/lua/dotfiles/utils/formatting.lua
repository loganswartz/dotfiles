local M = {}

M.LspFormat = function(opts)
    vim.lsp.buf.format(vim.tbl_extend('keep', {
        filter = function(client) return client.name ~= "tsserver" end,
    },
    opts or {}))
end

M.LspAugroup = vim.api.nvim_create_augroup("LspFormatting", {})

return M
