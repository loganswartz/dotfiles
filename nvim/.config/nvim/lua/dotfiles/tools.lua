local have = require("dotfiles.utils.env").have

-- Tools
-- Anything with `install` set to `true` will be installed automatically by mason-tools.nvim
return {
    codelldb = { install = true }, -- rust debugging
    debugpy = { install = have("python") },
    delve = { install = have("go") }, -- go debugging
    gofumpt = { install = have("go") },
    goimports = { install = have("go") },
    ["go-debug-adapter"] = { install = have("go") },
    ["graphql-language-service-cli"] = { install = have("npm") },
    ["gh-actions-language-server"] = { install = have("npm") },
    isort = { install = have("python") },
    jq = { install = true },
    ["kulala-fmt"] = { install = have("npm") },
    ["nginx-config-formatter"] = { install = have("python") },
    phpstan = { install = true },
    prettierd = { install = have("npm") },
    shellharden = { install = true },
    shfmt = { install = true },
    sqlfmt = { install = true },
    stylua = { install = true },
    ["php-cs-fixer"] = { install = have("composer") },
    ["php-debug-adapter"] = { install = have("npm") },
    psalm = { install = true },
}
