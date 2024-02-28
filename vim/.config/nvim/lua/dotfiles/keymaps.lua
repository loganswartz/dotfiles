local M = {}

local function manager_keybinds()
    vim.keymap.set('n', "<leader>l", require("lazy").home)
    vim.keymap.set('n', "<leader>m", require("mason.ui").open)
end

function M.setup()
    manager_keybinds()
end

return M
