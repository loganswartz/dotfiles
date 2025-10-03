local M = {}

---@alias Orientation 'horizontal' | 'vertical'

---@return Orientation
function M.get_orientation()
    -- height / width of a single character, in pixels
    local CHAR_RATIO = 21 / 10

    local width = vim.api.nvim_win_get_width(0)
    local height = vim.api.nvim_win_get_height(0) * CHAR_RATIO

    if width > height then
        return "horizontal"
    else
        return "vertical"
    end
end

function M.toggle_split_direction()
    if M.get_orientation() == "vertical" then
        vim.cmd("wincmd K")
    else
        vim.cmd("wincmd H")
    end
end

function M.open_current_dir_in_split()
    local path = vim.fn.expand("%:h")
    if path == "" then
        path = vim.fn.getcwd()
    end
    vim.cmd("SP " .. path)
end

---@alias PluginOverlay 'lazy' | 'mason'

---@type table<PluginOverlay, {open: fun(), close: fun()}>
M.overlays = {
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

---@param except PluginOverlay|nil
function M.close_overlays(except)
    for key, app in pairs(M.overlays) do
        if (except == nil or key ~= except) and app.close then
            app.close()
        end
    end
end

---@param name PluginOverlay
function M.open_overlay(name)
    M.close_overlays(name)

    if M.overlays[name] then
        M.overlays[name].open()
    end
end

return M
