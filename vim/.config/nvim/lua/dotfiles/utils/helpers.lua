local M = {}

local function has_attr(item, key, value)
    local ok, result = pcall(function()
        return item[key] == value
    end)
    return (ok and result)
end

function M.superset_of_factory(attrs)
    return function(_, value)
        return vim.iter(attrs):all(function(attr, expected)
            return has_attr(value, attr, expected)
        end)
    end
end

--- Filter an iterable, returning only key-value pairs where the value has all
--- the same attributes as the filter.
function M.where(iterable, filter)
    local items = vim.iter(pairs(iterable))
    local is_superset = M.superset_of_factory(filter)

    local filtered = items:filter(is_superset):fold({}, function(acc, key, value)
        acc[key] = value
        return acc
    end)

    return filtered
end

return M
