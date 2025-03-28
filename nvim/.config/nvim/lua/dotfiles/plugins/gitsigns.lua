local M = {
    "lewis6991/gitsigns.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "BufRead",
    opts = {
        signs = {
            add = { text = "+" },
            change = { text = "~" },
            delete = { text = "_" },
            topdelete = { text = "‾" },
            changedelete = { text = "~" },
        },
    },
    keys = {
        {
            "[h",
            function()
                require("gitsigns").nav_hunk("prev")
            end,
        },
        {
            "]h",
            function()
                require("gitsigns").nav_hunk("next")
            end,
        },
        {
            "[H",
            function()
                require("gitsigns").nav_hunk("first")
            end,
        },
        {
            "]H",
            function()
                require("gitsigns").nav_hunk("last")
            end,
        },
    },
}

return M
