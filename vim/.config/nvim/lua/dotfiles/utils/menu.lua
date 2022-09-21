local M = {}

function M.createMenu(config)
    local popup_options = {
        position = "50%",
        border = {
            style = "rounded",
            text = {
                top = config.title,
                top_align = "center",
            },
        },
        win_options = {
            winhighlight = "Normal:Normal",
        }
    }

    local Menu = require("nui.menu")

    return Menu(popup_options, {
        lines = config.lines,
        max_width = 30,
        keymap = {
            focus_next = { "j", "<Down>", "<Tab>" },
            focus_prev = { "k", "<Up>", "<S-Tab>" },
            close = { "<Esc>", "<C-c>" },
            submit = { "<CR>", "<Space>" },
        },
        on_submit = function(item)
            item:callback()
        end,
    })
end

return M
