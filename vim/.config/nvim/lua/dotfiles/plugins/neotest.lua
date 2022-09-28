return {
    "nvim-neotest/neotest",
    requires = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        'olimorris/neotest-phpunit',
    },
    config = function()
        require('neotest').setup({
            adapters = {
                require('neotest-python'),
                require('neotest-phpunit'),
            }
        })
    end
}
