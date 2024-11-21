local utils = require('dotfiles.utils.env')

---@param func_that_returns_path fun(): string
local function find_files_for(func_that_returns_path)
    return function()
        local path = func_that_returns_path()
        require('telescope.builtin').find_files({
            prompt_title = 'Find files in ' .. path,
            cwd = path,
        })
    end
end

---@param func_that_returns_path fun(): string
local function grep_for(func_that_returns_path)
    return function()
        local path = func_that_returns_path()
        require('telescope.builtin').live_grep({
            prompt_title = 'Grep files in ' .. path,
            cwd = path,
        })
    end
end

local M = {
    'nvim-telescope/telescope.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope-dap.nvim',
    },
    cmd = "Telescope",
    version = false,
    keys = {
        -- meta
        { '<leader>ft', require('telescope.builtin').builtin,          desc = 'Open Telescope' },
        -- files
        { '<leader>ff', require('telescope.builtin').find_files,       desc = 'Find files' },
        { '<leader>fg', require('telescope.builtin').live_grep,        desc = 'Live grep in current directory' },
        { '<leader>fs', require('telescope').extensions.dir.live_grep, desc = 'Live Grep in a subdirectory' },
        -- LSP
        { '<leader>fd', require('telescope.builtin').diagnostics,      desc = 'Show all diagnostics' },
        { '<leader>fq', require("telescope.builtin").quickfix,         desc = 'Show quickfix' },
        { '<leader>fl', require("telescope.builtin").loclist,          desc = 'Show location list' },
        { '<leader>fk', require("telescope.builtin").keymaps,          desc = 'Show all keymaps' },
        { '<leader>gd', require("telescope.builtin").lsp_definitions,  desc = 'Go to Definition' },
        {
            '<leader>gD',
            function()
                require("telescope.builtin").lsp_definitions({ jump_type = 'vsplit' })
            end,
            desc = 'Go to Definition in split'
        },
        { '<leader>gi', require("telescope.builtin").lsp_implementations,  desc = 'Go to Implementation' },
        { '<leader>gt', require("telescope.builtin").lsp_type_definitions, desc = 'Go to Definition' },
        { '<leader>gr', require("telescope.builtin").lsp_references,       desc = 'Go to References' },
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        --[[ { '<leader>gD', vim.lsp.buf.declaration,                           desc = 'LSP Type Declarations' }, ]]
        { '<leader>fa', vim.lsp.buf.code_action,                           desc = 'LSP Code Actions' },
        { '<leader>r',  vim.lsp.buf.rename,                                desc = 'LSP Rename' },
        {
            '<leader>fbd',
            function()
                require('telescope.builtin').diagnostics({ bufnr = 0 })
            end,
            desc = 'Show diagnostics for buffer'
        },
        -- vim
        { '<leader>fh',  require('telescope.builtin').help_tags,         desc = 'Search help tags' },
        { '<leader>fbb', require('telescope.builtin').buffers,           desc = 'Show open buffers' },
        -- git
        { '<leader>gs',  require('telescope.builtin').git_status,        desc = 'Show git status' },
        -- misc
        { '<leader>fl',  require('telescope.builtin').reloader,          desc = 'Reload lua modules' },

        { '<leader>df',  find_files_for(utils.dotfiles_root),            desc = 'Find files in dotfiles' },
        { '<leader>dg',  grep_for(utils.dotfiles_root),                  desc = 'Grep files in dotfiles' },
        { '<leader>vf',  find_files_for(utils.dotfiles_lua_module_root), desc = 'Find files in lua dotfiles' },
        { '<leader>vg',  grep_for(utils.dotfiles_lua_module_root),       desc = 'Grep files in lua dotfiles' },
    },
    config = function()
        local telescope = require('telescope')
        local previewers = require('telescope.previewers')
        local telescopeConfig = require("telescope.config")

        local rg_args = { "--hidden", "--trim", "--pcre2", "--glob", "!**/.git/*" }

        -- Clone the default Telescope configuration
        local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }
        vim.list_extend(vimgrep_arguments, rg_args)

        telescope.setup({
            defaults = {
                mappings = {
                    i = {
                        ["<C-u>"] = false
                    },
                },
                layout_strategy = "flex",
                layout_config = {
                    flex = {
                        flip_columns = 160,
                    },
                },
                set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
                file_previewer = previewers.vim_buffer_cat.new,
                grep_previewer = previewers.vim_buffer_vimgrep.new,
                qflist_previewer = previewers.vim_buffer_qflist.new,
                vimgrep_arguments = vimgrep_arguments,
            },
            pickers = {
                find_files = {
                    find_command = vim.list_extend({ "rg", "--files" }, rg_args),
                },
            },
        })

        telescope.load_extension('dap')
        telescope.load_extension('dir')
        telescope.load_extension('media_files')
    end
}

return M
