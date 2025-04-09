local finders = require("dotfiles.utils.finders")

local function get_http_dir(source, marker)
    local root = vim.fs.root(source or 0, marker or ".git")
    return vim.fs.joinpath(root, ".http")
end

return {
    "mistweaverco/kulala.nvim",
    init = function()
        vim.filetype.add({
            extension = {
                ["http"] = "http",
            },
        })
    end,
    config = function()
        require("kulala").setup()
    end,
    keys = {
        {
            "<localleader>e",
            function()
                require("kulala").set_selected_env()
            end,
        },
        {
            "<localleader><space>",
            function()
                require("kulala").run()
            end,
        },
        {
            "<localleader>rf",
            function()
                finders.find_files_for("HTTP files", { cwd = get_http_dir() })
            end,
        },
        {
            "<localleader>rg",
            function()
                finders.grep_for("HTTP files", { cwd = get_http_dir() })
            end,
        },
    },
}
