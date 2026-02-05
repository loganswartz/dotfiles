return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "loganswartz/neotest-phpunit",
        "nvim-neotest/neotest-python",
        "mrcjkb/rustaceanvim",
    },
    --[[ event = 'VeryLazy', ]]
    keys = {
        {
            ",t",
            function()
                require("neotest").run.run()
            end,
            desc = "Run single test under cursor",
        },
        {
            ",T",
            function()
                require("neotest").run.run(vim.fn.expand("%"))
            end,
            desc = "Run all tests in file",
        },
    },
    config = function()
        require("neotest").setup({
            adapters = {
                require("neotest-python"),
                require("rustaceanvim.neotest"),
                require("neotest-phpunit")(),
            },
            icons = {
                failed = "✖",
                passed = "✔",
                running = "🗘",
                skipped = "",
                unknown = "?",
            },
        })
    end,
}
