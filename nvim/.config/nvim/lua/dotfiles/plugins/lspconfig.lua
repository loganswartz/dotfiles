local M = {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "folke/lazydev.nvim",
    },
    event = { "BufReadPre", "BufNewFile" },
    keys = {
        { "<leader>wa", vim.lsp.buf.add_workspace_folder },
        { "<leader>wr", vim.lsp.buf.remove_workspace_folder },
        {
            "<leader>wl",
            function()
                vim.print(vim.lsp.buf.list_workspace_folders())
            end,
        },
        {
            "<leader>h",
            function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
            end,
            desc = "Toggle Inlay Hints",
        },
        { "K", vim.lsp.buf.hover },
    },
}

return M
