local env = require('dotfiles.utils.env')
local Collection = require('dotfiles.utils.collection')

local have_npm = env.has('npm')
local have_composer = env.has('composer')

local M = {}

-- LSPs
-- Anything with `install` set to `true` will be installed automatically by mason.nvim
-- Anything with `setup` set to `true` will be automatically set up by lspconfig
M.lsps = Collection:new({
    bashls = { install = have_npm, setup = true },
    dockerls = { install = have_npm, setup = true },
    graphql = { install = have_npm, setup = true },
    intelephense = { install = have_npm, setup = true },
    gopls = { install = true, setup = true },
    jsonls = { install = have_npm, setup = true },
    lua_ls = { install = true, setup = true },
    marksman = { install = true, setup = true },
    -- might use phpactor instead of intelephense eventually
    phpactor = { install = have_composer, setup = false },
    pyright = { install = have_npm, setup = true },
    ruff_lsp = { install = true, setup = true },
    -- rustaceanvim needs rust-analyzer, but handles all the setup itself
    rust_analyzer = { install = true, setup = false },
    svelte = { install = have_npm, setup = true },
    -- typescript-tools.nvim needs tsserver, but handles all the setup itself
    tsserver = { install = have_npm, setup = false },
    vimls = { install = have_npm, setup = true },
    yamlls = { install = have_npm, setup = true },
})

-- Tools
-- Anything with `install` set to `true` will be installed automatically by mason-tools.nvim
M.tools = Collection:new({
    prettierd = { install = have_npm },
    -- php_debug_adapter = { install = have_npm },
    sqlfmt = { install = true },
    -- phpstan = { install = true },
})

return M
