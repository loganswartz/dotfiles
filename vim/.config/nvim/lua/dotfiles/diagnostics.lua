local M = {}

function M.setup()
    vim.diagnostic.config({
        float = { source = true },
        virtual_text = false,
        virtual_lines = {
            highlight_whole_line = true,
        },
    })
end

return M
