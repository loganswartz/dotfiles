local cmd = require('dotfiles.utils.helpers').cmd_factory
local createMenu = require('dotfiles.utils.menu').createMenu
local Menu = require('nui.menu')

return createMenu({
    title = "[TS Helper Actions]",
    lines = {
        Menu.item("Add Missing Imports", { callback = cmd('TypescriptAddMissingImports') }),
        Menu.item("Rename File", { callback = cmd('TypescriptRenameFile') }),
        Menu.item("Go to Source Definition", { callback = cmd('TypescriptGoToSourceDefinition') }),
        Menu.item("Organize Imports", { callback = cmd('TypescriptOrganize') }),
        Menu.item("Remove Unused Variables", { callback = cmd('TypescriptRemoveUnused') }),
        Menu.item("Fix All Issues", { callback = cmd('TypescriptFixAll') }),
    },
})
