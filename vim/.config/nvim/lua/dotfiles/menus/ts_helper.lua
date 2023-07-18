local createMenu = require('dotfiles.utils.menu').createMenu

local options = {
    { name = "Add Missing Imports", callback = function() vim.cmd.TypescriptAddMissingImports() end },
    { name = "Remove Unused Variables", callback = function() vim.cmd.TypescriptRemoveUnused() end },
    { name = "Organize Imports", callback = function() vim.cmd.TypescriptOrganize() end },
    { name = "Rename File", callback = function() vim.cmd.TypescriptRenameFile() end },
    { name = "Go to Source Definition", callback = function() vim.cmd.TypescriptGoToSourceDefinition() end },
    { name = "Fix All Issues", callback = function() vim.cmd.TypescriptFixAll() end },
}

return createMenu("[TS Helper Actions]", options)
