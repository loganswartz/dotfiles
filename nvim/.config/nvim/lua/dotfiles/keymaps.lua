local M = {}

local APPS = {
    lazy = {
        open = function()
            require("lazy").home()
        end,
        close = function()
            if require("lazy.view").visible() then
                require("lazy.view").view:close()
            end
        end,
    },
    mason = {
        open = function()
            require("mason.ui").open()
        end,
        close = function()
            local instance = require("mason.ui.instance")
            if instance.window and instance.window.is_open() then
                instance.window.close()
            end
        end,
    },
}

---@param except 'lazy' | 'mason' | nil
function M.close(except)
    for key, app in pairs(APPS) do
        if (except == nil or key ~= except) and app.close then
            app.close()
        end
    end
end

---@param name 'lazy' | 'mason'
function M.open(name)
    M.close(name)

    if APPS[name] then
        APPS[name].open()
    end
end

function M.setup()
    vim.keymap.set("n", "<leader>l", function()
        M.open("lazy")
    end)
    vim.keymap.set("n", "<leader>m", function()
        M.open("mason")
    end)
    -- center match in screen when going to next/previous match
    vim.keymap.set("n", "n", "nzz")
    vim.keymap.set("n", "N", "Nzz")
end

return M
