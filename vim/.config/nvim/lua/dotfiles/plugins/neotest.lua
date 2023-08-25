return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "loganswartz/neotest-phpunit",
        "nvim-neotest/neotest-python",
    },
    config = function()
        require('neotest').setup({
            adapters = {
                require('neotest-python'),
                require('neotest-phpunit')({
                    phpunit_cmd = { 'docker', 'exec', '-i', 'terminal-php-1', 'vendor/bin/phpunit' },
                    test_pathmap = {
                        native = '/home/logans/development/projects/terminal',
                        remote = '/var/www',
                    },
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

        vim.keymap.set('n', ',t', require('neotest').run.run, {})
        vim.keymap.set('n', ',T', function()
            require('neotest').run.run(vim.fn.expand('%'))
        end, {})
    end
}
