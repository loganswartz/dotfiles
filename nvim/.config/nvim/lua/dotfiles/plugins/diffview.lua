local M = {
    "sindrets/diffview.nvim",
    opts = {
        file_panel = {
            win_config = {
                position = "bottom",
                height = 14,
            },
        },
    },
    keys = {
        {
            "<leader>dv",
            function()
                require("diffview").open({})
            end,
            desc = "Open diffview for local changes (base: HEAD)",
        },
        {
            "<leader>db",
            function()
                local base = vim.system({ "git", "merge-base", "--fork-point", "origin/HEAD", "HEAD" }):wait()
                if base == nil then
                    vim.notify("Unable to determine merge base!")
                    return
                end
                local ref = vim.fn.trim(base.stdout)

                require("diffview").open({ ref })
            end,
            desc = "Open diffview for entire branch (base: branch merge base)",
        },
        {
            "<leader>dc",
            function()
                require("diffview").close()
            end,
            desc = "Close diffview",
        },
    },
}

return M
