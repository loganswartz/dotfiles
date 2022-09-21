local M = {}

M.LspFormat = function(bufnr)
    vim.lsp.buf.format({
        filter = function(client) return client.name ~= "tsserver" end,
        bufnr = bufnr,
    })
end

M.LspAugroup = vim.api.nvim_create_augroup("LspFormatting", {})

return M
