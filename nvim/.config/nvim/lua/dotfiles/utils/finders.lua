local M = {}

local function at_least_one_dir_exists(paths)
    for _, path in ipairs(paths) do
        if vim.fn.isdirectory(path) == 1 then
            return true
        end
    end

    return false
end

---@param what string
---@param args table
function M.find_files_for(what, args)
    local paths = args.search_dirs and args.search_dirs or { args.cwd }

    if not at_least_one_dir_exists(paths) then
        vim.notify('No directories exist for "' .. what .. '"', vim.log.levels.WARN)
        return
    end

    require("telescope.builtin").find_files(vim.tbl_extend("force", {
        prompt_title = "Search " .. what,
    }, args or {}))
end

---@param what string
---@param args table
function M.grep_for(what, args)
    local paths = args.search_dirs and args.search_dirs or { args.cwd }

    if not at_least_one_dir_exists(paths) then
        vim.notify('No directories exist for "' .. what .. '"', vim.log.levels.WARN)
        return
    end

    require("telescope.builtin").live_grep(vim.tbl_extend("force", {
        prompt_title = "Grep " .. what,
    }, args or {}))
end

return M
