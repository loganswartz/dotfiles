local createMenu = require('dotfiles.utils.menu').createMenu

local options = {
    ["Add Missing Imports"] = function() vim.cmd.TypescriptAddMissingImports() end,
    ["Rename File"] = function() vim.cmd.TypescriptRenameFile() end,
    ["Go to Source Definition"] = function() vim.cmd.TypescriptGoToSourceDefinition() end,
    ["Organize Imports"] = function() vim.cmd.TypescriptOrganize() end,
    ["Remove Unused Variables"] = function() vim.cmd.TypescriptRemoveUnused() end,
    ["Fix All Issues"] = function() vim.cmd.TypescriptFixAll() end,
}

return createMenu("[TS Helper Actions]", options)
