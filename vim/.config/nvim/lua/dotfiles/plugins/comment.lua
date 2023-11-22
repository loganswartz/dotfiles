vim.g.skip_ts_context_commentstring_module = true

local M = {
    'numToStr/Comment.nvim',
    dependencies = {
        {
            'JoosepAlviste/nvim-ts-context-commentstring',
            main = 'ts_context_commentstring',
            opts = { enable_autocmd = false },
        }
    },
    config = function()
        require('Comment').setup({
            pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
        })
    end,
}

return M
