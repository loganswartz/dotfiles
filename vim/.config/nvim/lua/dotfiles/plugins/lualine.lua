local M = {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function()
        require 'lualine'.setup {
            options = {
                icons_enabled = false,
                theme = "auto",
                component_separators = { left = '|', right = '|' },
                section_separators = { left = '', right = '' },
                disabled_filetypes = {},
                always_divide_middle = true,
            },
            sections = {
                lualine_a = { { 'mode', color = { gui = nil } } }, -- remove bold
                lualine_b = {
                    'branch',
                    'vim.opt.readonly._value and "RO" or ""',
                    { 'filename', file_status = false },
                    'vim.opt.mod._value and "+" or ""',
                },
                lualine_c = { require('plugwatch').get_statusline_indicator },
                lualine_x = {
                    { 'diagnostics', sources = { 'nvim_diagnostic', 'coc' } },
                    'fileformat',
                    'encoding',
                    'filetype',
                },
                lualine_y = { 'progress' },
                lualine_z = { { 'location', color = { gui = nil } } } -- remove bold
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { 'filename' },
                lualine_x = { 'location' },
                lualine_y = {},
                lualine_z = {}
            },
            tabline = {},
            extensions = {}
        }
    end,
}

return M
