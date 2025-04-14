local env = require('dotfiles.utils.env')

return {
    init_options = {
        ["language_server_phpstan.enabled"] = true,
        -- phpactor runs the bin with a PHP binary, so a regular script will not work
        ["language_server_phpstan.bin"] = env.mason_pkg_dir('phpstan') .. 'phpstan.phar',
        ["language_server_psalm.enabled"] = false,
        ["language_server_psalm.bin"] = env.mason_bin('psalm'),
    }
}
