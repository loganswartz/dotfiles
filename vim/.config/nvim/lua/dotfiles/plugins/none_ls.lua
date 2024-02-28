local M = {
    'nvimtools/none-ls.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvimtools/none-ls-extras.nvim',
    },
    config = function()
        local none_ls = require('null-ls')
        local formatting = require('dotfiles.utils.formatting')

        none_ls.setup({
            sources = {
                none_ls.builtins.formatting.gofmt,
                none_ls.builtins.formatting.sqlfmt,
                none_ls.builtins.formatting.prettierd.with({
                    disabled_filetypes = { 'yaml', 'markdown' },
                }),
                require('none-ls.diagnostics.eslint'),
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
