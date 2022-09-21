local M = {
    'numToStr/Comment.nvim',
    requires = { 'JoosepAlviste/nvim-ts-context-commentstring' },
    config = function()
        require('Comment').setup({
            -- NOTE: The example below is a proper integration and it is RECOMMENDED.
            ---@param ctx Ctx
            pre_hook = function(ctx)
                local U = require('Comment.utils')

                -- Determine the location where to calculate commentstring from
                local location = nil
                if ctx.ctype == U.ctype.block then
                    location = require('ts_context_commentstring.utils').get_cursor_location()
                elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
                    location = require('ts_context_commentstring.utils').get_visual_start_location()
                end

                return require('ts_context_commentstring.internal').calculate_commentstring({
                    -- Determine whether to use linewise or blockwise commentstring
                    key = ctx.ctype == U.ctype.line and '__default' or '__multiline',
                    location = location,
                })
            end,
        })
    end
}

return M
