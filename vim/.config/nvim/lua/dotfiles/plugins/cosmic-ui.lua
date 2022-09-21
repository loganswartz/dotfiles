local M = {
    'CosmicNvim/cosmic-ui',
    requires = {
        'MunifTanjim/nui.nvim',
        'nvim-lua/plenary.nvim',
        'ray-x/lsp_signature.nvim',
        'rcarriga/nvim-notify',
    },
    config = function()
        -- enable nvim-notify since cosmic-ui requires it
        vim.notify = require('notify')

        require('cosmic-ui').setup({
            border_style = 'rounded',
        })
    end,
    after = 'nvim-lspconfig',
}

return M
