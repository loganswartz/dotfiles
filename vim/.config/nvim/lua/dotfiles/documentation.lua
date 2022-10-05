local helpers = require('dotfiles.utils.helpers')

local M = {}

function M.findDocLinks(value)
    if not value then
        vim.notify("Unable to parse docs!")
    end

    local pattern = "https?://[%w-_%.%?%.:/%+=&]+"
    local matches = helpers.iteratorToArray(string.gmatch(value, pattern))

    if #matches == 0 then
        vim.notify("No links found!")
        return
    elseif #matches == 1 then
        helpers.openLink(matches[1])
    else
        local lines = {}

        for _, link in pairs(matches) do
            lines[#lines + 1] = require('nui.menu').item(link, {
                callback = function() helpers.openLink(link) end,
            })
        end

        local menu = require('dotfiles.utils.menu').createMenu({
            title = "[Links Found]",
            lines = lines,
        })

        menu:mount()
    end
end

function M.showDocLinks()
    vim.lsp.buf_request(0, 'textDocument/hover', vim.lsp.util.make_position_params(),
        helpers.make_hover_callback(M.findDocLinks))
end

return M
