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
            function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
        },
        {
            "<leader>h",
            function() vim.lsp.inlay_hint.enable(vim.lsp.inlay_hint.is_enabled()) end,
            desc = "Toggle Inlay Hints",
        },
        { "K", vim.lsp.buf.hover },
    },
    config = function()
        local lsp_utils = require("dotfiles.plugins.lspconfig.utils")
        local helpers = require("dotfiles.utils.helpers")
        local external = require("dotfiles.external")

        local lsps = vim.tbl_keys(helpers.where(external.lsps, { setup = true }))

        for _, lsp in ipairs(lsps) do
            -- require("lspconfig")[lsp].setup({})
            lsp_utils.setup_lsp(lsp, {})
        end
    end,
}

return M
