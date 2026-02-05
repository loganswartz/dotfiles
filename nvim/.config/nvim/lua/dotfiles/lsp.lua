local have = require("dotfiles.utils.env").have
local helpers = require("dotfiles.utils.helpers")

local M = {}

-- LSPs
-- Anything with `install` set to `true` will be installed automatically by mason.nvim
-- Anything with `setup` set to `true` will be automatically set up by lspconfig
M.lsps = {
    astro = { install = have("npm"), setup = true },
    bashls = { install = have("npm"), setup = true },
    dockerls = { install = have("npm"), setup = true },
    clangd = { install = true, setup = true },
    eslint = { install = have("npm"), setup = true },
    -- this alias isn't supported by mason-lspconfig, so it's installed in tools.lua instead
    gh_actions_ls = { install = false, setup = true },
    graphql = { install = have("npm"), setup = true },
    -- currently trying out phpactor instead of intelephense
    intelephense = { install = have("npm"), setup = false },
    gopls = { install = have("go"), setup = true },
    jsonls = { install = have("npm"), setup = true },
    -- laravel_ls = { install = have("go"), setup = true },
    lua_ls = { install = true, setup = true },
    marksman = { install = true, setup = true },
    -- requires Python <=3.12
    -- nginx_language_server = { install = have('python'), setup = true },
    nil_ls = { install = true, setup = true },
    phpactor = { install = have("npm"), setup = false },
    -- rustaceanvim needs rust-analyzer, but handles all the setup itself
    rust_analyzer = { install = true, setup = false },
    svelte = { install = have("npm"), setup = true },
    tombi = { install = true, setup = true },
    ty = { install = true, setup = true },
    vimls = { install = have("npm"), setup = true },
    yamlls = { install = have("npm"), setup = true },
}

function M.setup()
    vim.lsp.inlay_hint.enable()
    vim.lsp.config("*", {})

    local enabled = vim.tbl_keys(helpers.where(M.lsps, { setup = true }))
    local disabled = vim.tbl_keys(helpers.where(M.lsps, { setup = false }))

    -- ensure only these servers specifically are enabled
    vim.lsp.enable(disabled, false)
    vim.lsp.enable(enabled)
end

return M
