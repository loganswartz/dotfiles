local have = require("dotfiles.utils.env").have
local helpers = require("dotfiles.utils.helpers")

local M = {}

-- LSPs
-- Anything with `install` set to `true` will be installed automatically by mason.nvim
-- Anything with `setup` set to `true` will be automatically set up by lspconfig
M.lsps = {
    bashls = { install = have("npm"), setup = true },
    dockerls = { install = have("npm"), setup = true },
    clangd = { install = true, setup = true },
    -- this alias isn't supported by mason-lspconfig, so it's installed in tools.lua instead
    gh_actions_ls = { install = false, setup = true },
    graphql = { install = have("npm"), setup = true },
    -- currently trying out phpactor instead of intelephense
    intelephense = { install = have("npm"), setup = false },
    gopls = { install = have("go"), setup = true },
    jsonls = { install = have("npm"), setup = true },
    lua_ls = { install = true, setup = true },
    marksman = { install = true, setup = true },
    -- requires Python <=3.12
    -- nginx_language_server = { install = have('python'), setup = true },
    phpactor = { install = have("composer"), setup = false },
    pyright = { install = have("npm"), setup = true },
    ruff = { install = true, setup = true },
    -- rustaceanvim needs rust-analyzer, but handles all the setup itself
    rust_analyzer = { install = true, setup = false },
    svelte = { install = have("npm"), setup = true },
    -- typescript-tools.nvim needs tsserver, but handles all the setup itself
    ts_ls = { install = have("npm"), setup = false },
    vimls = { install = have("npm"), setup = true },
    yamlls = { install = have("npm"), setup = true },
}

function M.setup()
    local lsps = vim.tbl_keys(helpers.where(M.lsps, { setup = true }))

    vim.lsp.inlay_hint.enable()
    vim.lsp.config("*", {})
    vim.lsp.enable(lsps)
end

return M
