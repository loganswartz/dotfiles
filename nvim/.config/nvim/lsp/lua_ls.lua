local env = require("dotfiles.utils.env")

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#lua_ls
return {
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME,
                    -- inject my own dotfiles
                    env.dotfiles_lua_runtime_root(),
                    "${3rd}/luv/library",
                },
            },
            hint = {
                enable = true,
            },
            format = {
                enable = true,
                ---@see https://github.com/CppCXY/EmmyLuaCodeStyle/blob/master/docs/format_config_EN.md
                ---@see https://github.com/CppCXY/EmmyLuaCodeStyle/blob/master/lua.template.editorconfig
                defaultConfig = {
                    indent_style = "space",
                    indent_size = 4,
                    trailing_table_separator = "smart",
                    align_function_params = false,
                    align_continuous_assign_statement = "when_extra_space",
                    align_continuous_rect_table_field = "when_extra_space",
                },
            },
        },
    },
}
