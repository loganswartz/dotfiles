local M = {}

---@param items { [string]: fun(name: string): nil }
function M.createMenu(title, items)
    local options = {}
    for name, callback in pairs(items) do
        options[#options+1] = { name = name, callback = callback }
    end

    return function()
        vim.ui.select(
            options,
            {
                prompt = title,
                format_item = function(item)
                    return item.name
                end,
            },
            function(choice)
                if choice == nil then return end
                choice.callback()
            end
        )
    end
end

return M
