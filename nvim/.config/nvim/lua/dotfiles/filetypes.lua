local M = {}

function M.setup()
    vim.filetype.add({
        filename = {
            [".env"] = "config",
        },
        pattern = {
            ["%.env%.[%w_.-]+"] = "config",
        },
        extension = {
            http = "http",
            neon = "neon",
            ["zsh-theme"] = "zsh",
        },
    })
end

return M
