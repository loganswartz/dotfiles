local functions = require("dotfiles.commands.functions")

local M = {}

function M.setup()
    -- center match in screen when going to next/previous match
    vim.keymap.set("n", "n", "nzz")
    vim.keymap.set("n", "N", "Nzz")

    -- navigate by visual lines, not real lines
    vim.keymap.set("n", "j", "gj")
    vim.keymap.set("n", "k", "gk")
    vim.keymap.set("n", "<Up>", "g<Up>")
    vim.keymap.set("n", "<Down>", "g<Down>")

    vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr><Esc>", { silent = true })

    -- Copy current visual selection to clipboard
    if vim.fn.has("clipboard") then
        vim.keymap.set("v", "<C-c>", '"+y')
    end

    vim.keymap.set("n", "<C-w><space>", functions.toggle_split_direction, { silent = true })
    vim.keymap.set("n", "_", functions.open_current_dir_in_split, { silent = true })

    -- plugin overlays
    vim.keymap.set("n", "<leader>l", function()
        functions.open_overlay("lazy")
    end)
    vim.keymap.set("n", "<leader>m", function()
        functions.open_overlay("mason")
    end)
end

return M
