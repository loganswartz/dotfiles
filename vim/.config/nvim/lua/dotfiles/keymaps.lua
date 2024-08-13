local M = {}

local APPS = {
    lazy = {
        open = function() require('lazy').home() end,
        close = function()
            if require('lazy.view').visible() then
                require('lazy.view').view:close()
            end
        end,
    },
    mason = {
        open = function() require('mason.ui').open() end,
        close = function()
            local instance = require('mason.ui.instance')
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

function M.open_dotfiles_split()
    local function find_root()
        local root = debug.getinfo(2, "S").source:sub(2)
        return root:match("(.*/)")
    end

    local root = find_root()
    vim.fn.execute("SP " .. root)
end

function M.setup()
    vim.keymap.set('n', '<leader>l', function() M.open('lazy') end)
    vim.keymap.set('n', '<leader>m', function() M.open('mason') end)
    vim.keymap.set('n', '<leader>D', M.open_dotfiles_split)
end

return M
