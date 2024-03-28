local env = require('dotfiles.utils.env')
local Collection = require('dotfiles.utils.collection')

local have_npm = env.has('npm')

local M = {}

M.lsps = Collection:new({
    bashls = { install = have_npm, enabled = true },
    dockerls = { install = have_npm, enabled = true },
    graphql = { install = have_npm, enabled = true },
    intelephense = { install = have_npm, enabled = true },
    -- phpactor = { install = have_npm, enabled = true },
    jsonls = { install = have_npm, enabled = true },
    pyright = { install = have_npm, enabled = true },
    svelte = { install = have_npm, enabled = true },
    tsserver = { install = have_npm, enabled = false },
    vimls = { install = have_npm, enabled = true },
    yamlls = { install = have_npm, enabled = true },
    marksman = { install = true, enabled = true },
    rust_analyzer = { install = true, enabled = true },
    lua_ls = { install = true, enabled = true },
    ruff_lsp = { install = true, enabled = true },
})

M.tools = Collection:new({
    prettierd = { install = have_npm, enabled = true },
    -- php_debug_adapter = { install = have_npm, enabled = true },
    sqlfmt = { install = true, enabled = true },
    -- phpstan = { install = true, enabled = true },
})

return M
