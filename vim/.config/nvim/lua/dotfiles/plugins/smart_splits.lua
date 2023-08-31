local M = {
    'mrjones2014/smart-splits.nvim',
    keys = {
        -- resizing splits
        { '<A-Left>',  function() require('smart-splits').resize_left() end },
        { '<A-Down>',  function() require('smart-splits').resize_down() end },
        { '<A-Up>',    function() require('smart-splits').resize_up() end },
        { '<A-Right>', function() require('smart-splits').resize_right() end },

        -- moving between splits
        { '<C-Left>',  function() require('smart-splits').move_cursor_left() end },
        { '<C-Down>',  function() require('smart-splits').move_cursor_down() end },
        { '<C-Up>',    function() require('smart-splits').move_cursor_up() end },
        { '<C-Right>', function() require('smart-splits').move_cursor_right() end },
    },
}

return M
