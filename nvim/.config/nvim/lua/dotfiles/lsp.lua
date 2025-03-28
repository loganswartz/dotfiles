-- local external = require("dotfiles.external")
-- local helpers = require("dotfiles.utils.helpers")

local M = {}

function M.setup()
    vim.lsp.inlay_hint.enable()

    vim.lsp.config("*", {})

    -- local lsps = vim.tbl_keys(helpers.where(external.lsps, { setup = true }))
    -- vim.lsp.enable(vim.tbl_keys(lsps))
end

return M
