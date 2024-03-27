local utils = require('dotfiles.utils.helpers')

---@class Collection
---@field _items {[string]: {[string]: boolean}}
---@field new fun(self: Collection, ...: {[string]: {[string]: boolean}}): Collection Create a new instance of the class.
---@field filter fun(self: Collection, filter_by: {[string]: boolean}): Collection Filter the collection by the given key-value pairs.

---@type Collection
local M = {
    _items = nil,

    new = function(self, items)
        local obj = {
            _items = items,
        }

        setmetatable(obj, self)

        return obj
    end,

    filter = function(self, filter_by)
        filter_by = filter_by or {}

        local filtered = {}
        for name, params in pairs(self._items) do
            local include = utils.every(filter_by, function(key, value)
                return params[key] == value
            end);

            if include then
                table.insert(filtered, name)
            end
        end

        return filtered
    end,
}
M.__index = M

return M
