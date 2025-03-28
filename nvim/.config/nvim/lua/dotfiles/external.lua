local have = require('dotfiles.utils.env').have

local M = {}

-- LSPs
-- Anything with `install` set to `true` will be installed automatically by mason.nvim
-- Anything with `setup` set to `true` will be automatically set up by lspconfig
M.lsps = {
    bashls = { install = have('npm'), setup = true },
    dockerls = { install = have('npm'), setup = true },
    clangd = { install = true, setup = true },
    graphql = { install = have('npm'), setup = true },
    -- currently trying out phpactor instead of intelephense
    intelephense = { install = have('npm'), setup = false },
    gopls = { install = have('go'), setup = true },
    jsonls = { install = have('npm'), setup = true },
    lua_ls = { install = true, setup = true },
    marksman = { install = true, setup = true },
    -- requires Python <=3.12
    -- nginx_language_server = { install = have('python'), setup = true },
    phpactor = { install = have('composer'), setup = false },
    pyright = { install = have('npm'), setup = true },
    ruff = { install = true, setup = true },
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
    codelldb = { install = true }, -- rust debugging
    debugpy = { install = have('python') },
    gofumpt = { install = have('go') },
    goimports = { install = have('go') },
    ["go-debug-adapter"] = { install = have('go') },
    ["graphql-language-service-cli"] = { install = have('npm') },
    isort = { install = have('python') },
    jq = { install = true },
    ["kulala-fmt"] = { install = have('npm') },
    ["nginx-config-formatter"] = { install = have('python') },
    phpstan = { install = true },
    prettierd = { install = have('npm') },
    sqlfmt = { install = true },
    stylua = { install = true },
    ["php-cs-fixer"] = { install = have('composer') },
    ["php-debug-adapter"] = { install = have('npm') },
    psalm = { install = true },
}

return M
