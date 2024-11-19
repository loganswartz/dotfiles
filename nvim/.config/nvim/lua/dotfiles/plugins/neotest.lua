return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "loganswartz/neotest-phpunit",
        "nvim-neotest/neotest-python",
        "nvim-neotest/neotest-jest",
        "rouge8/neotest-rust",
    },
    --[[ event = 'VeryLazy', ]]
    keys = {
        { ',t', function() require('neotest').run.run() end, desc = 'Run single test under cursor' },
        {
            ',T',
            function()
                require('neotest').run.run(vim.fn.expand('%'))
            end,
            desc = 'Run all tests in file'
        },
    },
    config = function()
        require('neotest').setup({
            adapters = {
                require('neotest-python'),
                require('neotest-rust'),
                require('neotest-phpunit')({
                    phpunit_cmd = { 'docker', 'exec', '-i', 'terminal-php-1', 'vendor/bin/phpunit' },
                    test_pathmap = {
                        native = '/home/logans/development/projects/terminal',
                        remote = '/var/www',
                    },
                }),
                require('neotest-jest')({
                    jestCommand = "npm test --",
                    jestConfigFile = "custom.jest.config.ts",
                    env = { CI = true },
                    cwd = function(path)
                        return vim.fn.getcwd()
                    end,
                }),
            },
            icons = {
                failed = "✖",
                passed = "✔",
                running = "🗘",
                skipped = "ﰸ",
                unknown = "?"
            },
        })
    end
}
