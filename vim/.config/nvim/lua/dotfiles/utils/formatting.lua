local M = {}

M.LspFormat = function(opts)
    vim.lsp.buf.format(vim.tbl_extend('keep', {
            filter = function(client)
                -- typescript-tools (aka tsserver) is really slow to format things.
                -- This lets null-ls handle formatting instead.
                return client.name ~= "typescript-tools"
            end,
        },
        opts or {}))
end

M.LspAugroup = vim.api.nvim_create_augroup("LspFormatting", {})

return M
