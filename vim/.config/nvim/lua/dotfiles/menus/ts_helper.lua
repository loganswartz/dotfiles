local createMenu = require('dotfiles.utils.menu').createMenu
local Menu = require('nui.menu')

return createMenu({
    title = "[TS Helper Actions]",
    lines = {
        Menu.item("Add Missing Imports", { callback = function() vim.cmd.TypescriptAddMissingImports() end }),
        Menu.item("Rename File", { callback = function() vim.cmd.TypescriptRenameFile() end }),
        Menu.item("Go to Source Definition", { callback = function() vim.cmd.TypescriptGoToSourceDefinition() end }),
        Menu.item("Organize Imports", { callback = function() vim.cmd.TypescriptOrganize() end }),
        Menu.item("Remove Unused Variables", { callback = function() vim.cmd.TypescriptRemoveUnused() end }),
        Menu.item("Fix All Issues", { callback = function() vim.cmd.TypescriptFixAll() end }),
    },
})
