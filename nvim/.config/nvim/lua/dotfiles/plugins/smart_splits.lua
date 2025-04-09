local M = {
    "mrjones2014/smart-splits.nvim",
    keys = {
        -- resizing splits
        {
            "<A-Left>",
            function()
                require("smart-splits").resize_left()
            end,
            desc = "Resize split left",
        },
        {
            "<A-Down>",
            function()
                require("smart-splits").resize_down()
            end,
            desc = "Resize split down",
        },
        {
            "<A-Up>",
            function()
                require("smart-splits").resize_up()
            end,
            desc = "Resize split up",
        },
        {
            "<A-Right>",
            function()
                require("smart-splits").resize_right()
            end,
            desc = "Resize split right",
        },

        -- moving between splits
        {
            "<C-Left>",
            function()
                require("smart-splits").move_cursor_left()
            end,
            desc = "Move left by one split",
        },
        {
            "<C-Down>",
            function()
                require("smart-splits").move_cursor_down()
            end,
            desc = "Move down by one split",
        },
        {
            "<C-Up>",
            function()
                require("smart-splits").move_cursor_up()
            end,
            desc = "Move up by one split",
        },
        {
            "<C-Right>",
            function()
                require("smart-splits").move_cursor_right()
            end,
            desc = "Move right by one split",
        },
    },
}

return M
