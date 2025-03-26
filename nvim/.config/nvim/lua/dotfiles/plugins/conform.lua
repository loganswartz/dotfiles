local function are_git_merging(bufnr)
    bufnr = bufnr or 0
    local file = vim.api.nvim_buf_get_name(bufnr)
    local dir = vim.fn.fnamemodify(file, ":h")

    local cmd = { "git", "-C", dir, "rev-parse", "-q", "--verify", "MERGE_HEAD" }
    return vim.system(cmd, { text = true }):wait().code == 0
end

local M = {
    "stevearc/conform.nvim",
    lazy = false,
    keys = {
        {
            "<leader>F",
            function()
                require("conform").format({ async = true })
            end,
            silent = true,
        },
    },
    opts = {
        default_format_opts = {
            lsp_format = "fallback",
            filter = function(client)
                return not vim.tbl_contains({ "ts_ls", "typescript-tools", "marksman" }, client.name)
            end,
        },
        -- https://github.com/stevearc/conform.nvim/blob/f9ef25a7ef00267b7d13bfc00b0dea22d78702d5/lua/conform/init.lua#L106
        format_on_save = function(bufnr)
            -- Don't autoformat when merging
            if are_git_merging(bufnr) then
                return
            end

            return {
                timeout_ms = 500,
            }
        end,
        formatters_by_ft = {
            go = { "goimports", "gofmt", "gofumpt" },
            json = { "jq" },
            http = { "kulala-fmt" },
            lua = { "stylua" },
            markdown = { "prettierd" },
            nginx = { "nginxfmt" },
            php = { "php_cs_fixer" },
            python = { "isort", "ruff_fix", "ruff_format" },
            sql = { "sqlfmt" },
            typescript = { "prettierd" },
            typescriptreact = { "prettierd" },
            ["_"] = { "trim_whitespace" },
        },
        formatters = {
            stylua = {
                prepend_args = { "--indent-type", "Spaces" },
            },
        },
    },
}

return M
