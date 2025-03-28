local env = require('dotfiles.utils.env')

local M = {}

-- Setup an LSP, allowing for server-specific modifications
function M.setup_lsp(lsp, options)
    local lspconfig_setup = require("lspconfig")[lsp].setup

    -- Overrides for certain LSPs.
    -- We pass in the setup method and our options, which allows us to do things before AND after setup.
    local overrides = {
        -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#lua_ls
        lua_ls = function(setup, opts)
            return setup(vim.tbl_deep_extend("force", opts, {
                settings = {
                    Lua = {
                        runtime = {
                            version = 'LuaJIT'
                        },
                        -- Make the server aware of Neovim runtime files
                        workspace = {
                            checkThirdParty = false,
                            library = {
                                vim.env.VIMRUNTIME,
                                -- inject my own dotfiles
                                env.dotfiles_lua_runtime_root(),
                                "${3rd}/luv/library",
                            }
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
                    }
                }
            }))
        end,
        -- phpactor = function(setup, opts)
        --     return setup(vim.tbl_deep_extend("force", opts, {
        --         init_options = {
        --             ["language_server_phpstan.enabled"] = true,
        --             -- phpactor runs the bin with a PHP binary, so a regular script will not work
        --             ["language_server_phpstan.bin"] = env.mason_pkg_dir('phpstan') .. 'phpstan.phar',
        --             ["language_server_psalm.enabled"] = false,
        --             ["language_server_psalm.bin"] = env.mason_bin('psalm'),
        --         }
        --     }))
        -- end,
    }

    local override = overrides[lsp]
    if override == nil then
        return lspconfig_setup(options)
    else
        return override(lspconfig_setup, options)
    end
end

M.get_relative_path = function(file_path)
    local plenary_path = require('plenary.path')
    local parsed_path, _ = file_path:gsub('file://', '')
    local path = plenary_path:new(parsed_path)
    local relative_path = path:make_relative(vim.fn.getcwd())
    return './' .. relative_path
end

return M
