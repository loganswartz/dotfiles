local M = {}

---@class MenuOption
---@field name string
---@field callback fun(): nil

---@param options MenuOption[]
function M.createMenu(title, options)
    return function()
        vim.ui.select(
            options,
            {
                prompt = title,
                ---@param option MenuOption
                format_item = function(option)
                    return option.name
                end,
            },
            ---@param option MenuOption
            function(option)
                if option == nil then return end
                option.callback()
            end
        )
    end
end

return M
