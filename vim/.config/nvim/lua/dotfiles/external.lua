local have = require('dotfiles.utils.env').have

local M = {}

-- LSPs
-- Anything with `install` set to `true` will be installed automatically by mason.nvim
-- Anything with `setup` set to `true` will be automatically set up by lspconfig
M.lsps = {
    bashls = { install = have('npm'), setup = true },
    dockerls = { install = have('npm'), setup = true },
    graphql = { install = have('npm'), setup = true },
    intelephense = { install = have('npm'), setup = false },
    gopls = { install = have('go'), setup = true },
    jsonls = { install = have('npm'), setup = true },
    lua_ls = { install = true, setup = true },
    marksman = { install = true, setup = true },
    -- might use phpactor instead of intelephense eventually
    phpactor = { install = have('composer'), setup = true },
    pyright = { install = have('npm'), setup = true },
    ruff_lsp = { install = true, setup = true },
    -- rustaceanvim needs rust-analyzer, but handles all the setup itself
    rust_analyzer = { install = true, setup = false },
    svelte = { install = have('npm'), setup = true },
    -- typescript-tools.nvim needs tsserver, but handles all the setup itself
    ts_ls = { install = have('npm'), setup = false },
    vimls = { install = have('npm'), setup = true },
    yamlls = { install = have('npm'), setup = true },
}

-- Tools
-- Anything with `install` set to `true` will be installed automatically by mason-tools.nvim
M.tools = {
    prettierd = { install = have('npm') },
    -- php_debug_adapter = { install = have_npm },
    sqlfmt = { install = true },
    phpstan = { install = true },
}

return M
