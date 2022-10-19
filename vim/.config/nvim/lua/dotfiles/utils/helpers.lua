local M = {}

-- Create a table that loads a lua module when accessing an attribute.
function M.create_lookup(path)
    local mt = {
        __index = function(table, key)
            local ok, result = pcall(require, path .. '.' .. key)
            return ok and result or nil
        end
    }
    return setmetatable({}, mt)
end

---@alias FilterInput nil|string|integer|any[]|fun(value: any): boolean

-- Factory that takes a value, and return a closure that checks:
--   Is the closure input equivalent to the factory input? or...
--   Is the factory input a table that contains the closure input? or...
--   Is the factory input a function that returns true when passed the closure input? or...
--   Is the closure input nil? (this condition is configurable)
--
---@param filter FilterInput The filter the closure will evaluate.
---@param match_on_nil_filter ?boolean: Should the closure return true when the filter is nil?
function M.make_filter_closure(filter, match_on_nil_filter)
    local function as_func(func, input)
        local ok, result = pcall(func, input)
        return (ok and result)
    end

    local function table_contains(table, input)
        local function run()
            for _, value in ipairs(table) do
                if value == input then
                    return true
                end
            end

            return false
        end

        local ok, result = pcall(run)
        return (ok and result)
    end

    local function match(input)
        local no_filter = match_on_nil_filter ~= nil and match_on_nil_filter and input == nil
        local input_matches = input == filter

        return no_filter or input_matches or table_contains(filter, input) or as_func(filter, input)
    end

    return match
end

-- Register a function to run on LspAttach.
--
-- Useful for plugins that want you to set lspconfig.on_attach to the plugin-provided on_attach.
-- This way, you don't have to initialize the plugin while you initialize lspconfig.
--
---@param callback fun(client: vim.lsp.client, bufnr: integer) The on_attach function to run.
---@param filter ?FilterInput A filter to check if the callback should run.
function M.register_lsp_attach(callback, filter)
    local should_run = M.make_filter_closure(filter)

    vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            local bufnr = args.buf
            if should_run(client.name) then
                callback(client, bufnr)
            end
        end,
    })
end

function M.auto_open_diag_hover()
    local function is_float_window(id)
        return vim.api.nvim_win_get_config(id).relative ~= ''
    end

    local float_is_open = vim.tbl_count(vim.tbl_filter(is_float_window, vim.api.nvim_list_wins())) > 0
    if not float_is_open then
        vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
    end
end

function M.openLink(link)
    local Job = require('plenary.job')
    Job:new({ command = 'xdg-open', args = { link } }):start()
end

function M.collect(...)
    local arr = {}
    for v in ... do
        arr[#arr + 1] = v
    end
    return arr
end

function M.make_hover_callback(callback)
    --@see :h lsp-response
    return function(error, result, ctx, config)
        local body = result.contents[2]
        local header = result.contents.value

        return callback(body or header or '')
    end
end

return M
