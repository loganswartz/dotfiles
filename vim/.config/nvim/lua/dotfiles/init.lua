local M = {}

local function get_packer_path()
    local subpath = '/site/pack/packer/start/packer.nvim'
    return vim.fn.stdpath('data') .. subpath
end

local function packer_installed()
    return not (vim.fn.empty(vim.fn.glob(get_packer_path())) > 0)
end

local function bootstrap_packer()
    if packer_installed() then
        return false
    end

    print('Installing packer.nvim....')
    vim.fn.system({
        'git',
        'clone',
        '--depth',
        '1',
        'https://github.com/wbthomason/packer.nvim',
        get_packer_path(),
    })
    vim.cmd 'packadd packer.nvim'
    return true
end

function M.setup()
    local plugins = require('dotfiles.plugins')
    local bootstrapped = bootstrap_packer()

    if packer_installed() then
        local only_packer = vim.env.ONLY_PACKER == "1"
        plugins.setup(only_packer)

        if bootstrapped then
            require('packer').sync()
        end
    end
end

return M
