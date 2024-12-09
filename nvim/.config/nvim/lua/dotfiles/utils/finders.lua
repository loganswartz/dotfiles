local M = {}

---@param path string
---@param args table|nil
function M.find_files_in(path, args)
    if vim.fn.isdirectory(path) == 0 then
        vim.notify('No directory exists at "' .. path .. '"', vim.log.levels.WARN)
        return
    end

    require('telescope.builtin').find_files(vim.tbl_extend('force', {
        prompt_title = 'Find files in ' .. path,
        cwd = path,
    }, args or {}))
end

---@param path string
---@param args table|nil
function M.grep_in(path, args)
    if vim.fn.isdirectory(path) == 0 then
        vim.notify('No directory exists at "' .. path .. '"', vim.log.levels.WARN)
        return
    end

    require('telescope.builtin').live_grep(vim.tbl_extend('force', {
        prompt_title = 'Grep files in ' .. path,
        cwd = path,
    }, args or {}))
end

return M
