local M = {
    'jose-elias-alvarez/null-ls.nvim',
    requires = {
        'nvim-lua/plenary.nvim',
    },
    config = function()
        local null_ls = require('null-ls')
        local formatting = require('dotfiles.utils.formatting')
        null_ls.setup({
            sources = {
                null_ls.builtins.formatting.black,
                null_ls.builtins.formatting.gofmt,
                null_ls.builtins.formatting.rustfmt,
                null_ls.builtins.formatting.sqlfmt,
                null_ls.builtins.formatting.prettierd.with({
                    disabled_filetypes = { 'yaml', 'markdown' },
                }),
                null_ls.builtins.diagnostics.eslint,
            },
            on_attach = function(client, bufnr)
                -- autoformat on save
                if client.supports_method("textDocument/formatting") then
                    vim.api.nvim_clear_autocmds({ group = formatting.LspAugroup, buffer = bufnr })
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = formatting.LspAugroup,
                        buffer = bufnr,
                        callback = function()
                            formatting.LspFormat({ bufnr = bufnr, timeout = 2000 })
                        end,
                    })
                end
            end,
        })
    end,
}

return M
