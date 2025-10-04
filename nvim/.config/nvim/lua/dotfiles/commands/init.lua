local functions = require("dotfiles.commands.functions")

local M = {}

function M.setup()
    vim.api.nvim_create_user_command("HTerm", "new | terminal", {})
    vim.api.nvim_create_user_command("VTerm", "vnew | terminal", {})
    vim.api.nvim_create_user_command("Term", function()
        if functions.get_orientation() == "vertical" then
            vim.cmd("HTerm")
        else
            vim.cmd("VTerm")
        end
    end, {})

    vim.api.nvim_create_user_command("SP", function(args)
        if functions.get_orientation() == "vertical" then
            vim.cmd.sp({ args = args.fargs })
        else
            vim.cmd.vs({ args = args.fargs })
        end
    end, { nargs = "+", complete = "file" })

    vim.api.nvim_create_autocmd("TermOpen", {
        pattern = "*",
        command = "startinsert",
    })

    vim.api.nvim_create_autocmd("FileType", {
        pattern = "gitcommit",
        command = "setlocal cc=72",
    })
    -- set indicator at row 80 for easier compliance with PEP 8
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "python",
        command = [[ setlocal cc=80 ]],
    })
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        command = "setlocal cc=80 textwidth=80",
    })
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "sh", "bash", "yaml", "html", "css", "nix" },
        command = "setlocal tabstop=2 shiftwidth=2 softtabstop=2",
    })

    -- fix display issues
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "help",
        command = "setlocal nolist",
    })

    -- plugins
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "vim",
        command = [[ let b:argwrap_line_prefix = '\' ]],
    })
end

return M
