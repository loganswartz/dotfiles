local M = {}

function M.setup()
    vim.o.termguicolors = true
    vim.o.cursorline = true
    vim.o.number = true

    -- enable filetype-specific indenting
    vim.cmd.filetype("plugin indent on")

    vim.o.laststatus = 3
    -- disable mode indicator in statusbar (redundant with lualine)
    vim.o.showmode = false
    vim.o.showcmd = true

    vim.opt.listchars = { trail = "·", tab = "┆─", nbsp = "␣" }
    vim.o.list = true

    vim.o.foldmethod = "marker"
    vim.o.mouse = "a"

    -- Audible terminal bells are really annoying
    vim.o.visualbell = true

    -- when scrolling, always have at least 8 lines between the cursor and the edge
    -- of the screen for better context (and to avoid editing right at the edge)
    vim.o.scrolloff = 8
    vim.o.sidescrolloff = 8

    -- default to 4 spaces for tabs
    vim.o.breakindent = true
    vim.o.expandtab = true
    vim.o.smarttab = true
    vim.o.shiftwidth = 4
    vim.o.tabstop = 4
    vim.o.softtabstop = 4

    -- default direction to open splits
    vim.o.splitright = true
    vim.o.splitbelow = true

    vim.o.showmatch = true
    vim.o.hlsearch = true
    vim.o.incsearch = true
    vim.o.inccommand = "split"

    -- enable transparency
    vim.o.pumblend = 10
    vim.o.winblend = 20

    vim.o.undofile = true
    vim.o.updatetime = 250
end

return M
