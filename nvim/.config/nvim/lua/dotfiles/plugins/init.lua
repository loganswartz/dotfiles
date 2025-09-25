return {
    -- LSP
    {
        "mrcjkb/rustaceanvim",
        lazy = false,
    },
    {
        "saecki/crates.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        main = "crates",
        config = true,
    },
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        opts = {
            settings = {
                tsserver_file_preferences = {
                    includeInlayEnumMemberValueHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayParameterNameHints = "all",
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayVariableTypeHints = true,
                },
                expose_as_code_action = "all",
            },
        },
    },
    {
        "gbprod/phpactor.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "neovim/nvim-lspconfig",
        },
        opts = {},
    },
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio",
        },
    },
    {
        "loganswartz/dap-path-mapper.nvim",
        dependencies = { "mfussenegger/nvim-dap" },
        config = true,
    },
    {
        "loganswartz/updoc.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        keys = {
            {
                "<leader>ds",
                function()
                    require("updoc").search()
                end,
                desc = "Search docs",
            },
            {
                "<leader>dl",
                function()
                    require("updoc").lookup()
                end,
                desc = "Lookup symbol",
            },
            {
                "<leader>dh",
                function()
                    require("updoc").show_hover_links()
                end,
                desc = "Show hover links",
            },
            {
                "<C-k>",
                function()
                    require("updoc").show_hover_links()
                end,
                desc = "Show hover links",
            },
        },
        config = true,
    },
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        opts = {
            suggestion = {
                auto_trigger = true,
                keymap = {
                    accept = "<C-l>",
                    next = "<C-n>",
                    prev = "<C-b>",
                    dismiss = "<C-]>",
                },
            },
        },
    },
    {
        "greggh/claude-code.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim", -- Required for git operations
        },
        opts = {
            window = {
                position = "float",
                float = {
                    width = "90%", -- Take up 90% of the editor width
                    height = "90%", -- Take up 90% of the editor height
                    row = "center", -- Center vertically
                    col = "center", -- Center horizontally
                    relative = "editor",
                    border = "double", -- Use double border style
                },
            },
            keymaps = {
                toggle = {
                    normal = "<leader>cc",
                    terminal = "<leader>cc",
                },
            },
        },
    },

    -- UI / Highlighting
    "princejoogie/dir-telescope.nvim",
    {
        "nvim-telescope/telescope-media-files.nvim",
        dependencies = { "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim" },
    },
    {
        "stevearc/dressing.nvim",
        event = "VeryLazy",
        opts = {
            select = {
                backend = { "telescope" },
            },
        },
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
    },
    {
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        enabled = vim.diagnostic.handlers["virtual_lines"] == nil,
    },
    {
        "lewis6991/hover.nvim",
        event = "VeryLazy",
        keys = {
            {
                "K",
                function()
                    require("hover").open()
                end,
                desc = "hover.nvim",
            },
            {
                "gK",
                function()
                    require("hover").select()
                end,
                desc = "hover.nvim (select)",
            },
            {
                "<C-p>",
                function()
                    require("hover").switch("previous")
                end,
                desc = "hover.nvim (previous source)",
            },
            {
                "<C-n>",
                function()
                    require("hover").switch("next")
                end,
                desc = "hover.nvim (next source)",
            },

            -- Mouse support
            {
                "<MouseMove>",
                function()
                    require("hover").hover_mouse()
                end,
                { desc = "hover.nvim (mouse)" },
            },
        },
        opts = {
            init = function()
                require("hover.providers.lsp")
                require("hover.providers.gh")
                require("hover.providers.gh_user")
                require("hover.providers.jira")
                require("hover.providers.man")
                -- require('hover.providers.dictionary')
            end,
            preview_opts = {
                border = "single",
                max_width = 100,
            },
            preview_window = false,
            title = true,
        },
    },
    "rafcamlet/nvim-luapad",
    {
        "LintaoAmons/scratch.nvim",
        event = "VeryLazy",
        opts = {
            file_picker = "telescope",
            filetype_details = {
                md = {},
                lua = {},
                php = {
                    content = { "<?php", "", "" },
                    cursor = {
                        location = { 3, 1 },
                        insert_mode = true,
                    },
                },
                sql = {},
                py = {},
                sh = {
                    content = { "#!/bin/bash", "" },
                    cursor = {
                        location = { 3, 1 },
                        insert_mode = true,
                    },
                },
                rs = {
                    content = { "fn main() {", "    ", "}" },
                    cursor = {
                        location = { 2, 5 },
                        insert_mode = true,
                    },
                },
                ts = {},
                tsx = {},
            },
        },
    },
    {
        "sudormrfbin/cheatsheet.nvim",
        dependencies = {
            "nvim-telescope/telescope.nvim",
            "nvim-lua/popup.nvim",
            "nvim-lua/plenary.nvim",
        },
        event = "VeryLazy",
    },
    {
        "alex-popov-tech/store.nvim",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
        },
        config = true,
    },
    {
        "nacro90/numb.nvim",
        main = "numb",
        config = true,
        event = "VeryLazy",
    },
    {
        "norcalli/nvim-colorizer.lua",
        main = "colorizer",
        config = true,
        event = "VeryLazy",
    },
    {
        "j-hui/fidget.nvim",
        opts = {
            notification = {
                override_vim_notify = true,
                -- default is bottom right, this is top right
                -- view = {
                --     stack_upwards = false,
                -- },
                -- window = {
                --     align = "top",
                -- },
            },
        },
    },
    "ryanoasis/vim-devicons",
    {
        "lukas-reineke/virt-column.nvim",
        config = function()
            require("virt-column").setup()
            vim.cmd([[ hi! link VirtColumn Comment ]])
        end,
    },
    "2KAbhishek/nerdy.nvim",
    "loganswartz/vim-squint",

    -- Completion
    {
        "ray-x/lsp_signature.nvim",
        opts = {
            hint_enable = false,
        },
    },
    {
        "kylechui/nvim-surround",
        event = "VeryLazy",
        config = true,
    },
    {
        "chrisgrieser/nvim-genghis",
        dependencies = "stevearc/dressing.nvim",
        lazy = false,
        config = true,
        keys = {
            {
                "<leader>ws",
                function()
                    require("genghis").duplicateFile()
                end,
            },
            {
                "<leader>ch",
                function()
                    require("genghis").chmodx()
                end,
            },
        },
    },
    "arthurxavierx/vim-caser",
    {
        "windwp/nvim-ts-autotag",
        dependencies = "nvim-treesitter/nvim-treesitter",
    },
    {
        "Wansmer/sibling-swap.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = true,
    },

    -- Formatting
    {
        "FooSoft/vim-argwrap",
        keys = {
            { "gw", ":ArgWrap<CR>" },
        },
        config = function()
            vim.g.argwrap_tail_comma = true
        end,
    },
    {
        "tibabit/vim-templates",
        config = function()
            vim.g.tmpl_search_paths = { vim.fn.stdpath("config") .. "/templates" }
        end,
    },
    {
        "nguyenvukhang/nvim-toggler",
        config = true,
    },

    -- Git
    "tpope/vim-fugitive",
    {
        "pwntester/octo.nvim",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
            -- OR 'ibhagwan/fzf-lua',
            "nvim-tree/nvim-web-devicons",
        },
        opts = {
            suppress_missing_scope = {
                projects_v2 = true,
            },
        },
        init = function()
            vim.treesitter.language.register("markdown", "octo")

            vim.api.nvim_create_user_command("ReviewPRs", function(args)
                local who = args.fargs[1]

                require("octo.commands").octo(
                    "pr",
                    "search",
                    "is:open",
                    "-review:approved",
                    -- "-reviewed-by:@me",
                    "draft:false",
                    who == nil and "-author:app/dependabot" or "author:" .. who
                )
            end, { nargs = "?" })
        end,
    },
    {
        "rhysd/git-messenger.vim",
        keys = {
            { "<leader>b", ":GitMessenger<CR>", silent = true, noremap = true },
        },
        config = function()
            vim.g.git_messenger_floating_win_opts = { border = "single" }
            vim.g.git_messenger_popup_content_margins = false
        end,
    },
    {
        "tveskag/nvim-blame-line",
        config = function()
            vim.g.blameLineGitFormat = " [%an • %as] %s"
            vim.keymap.set("n", "<leader>B", ":ToggleBlameLine<CR>", { silent = true, noremap = true })
        end,
    },
    {
        "linrongbin16/gitlinker.nvim",
        main = "gitlinker",
        config = true,
        keys = {
            {
                "<leader>gy",
                function()
                    require("gitlinker").link()
                end,
                silent = true,
                noremap = true,
                desc = "Copy git permlink to clipboard",
                mode = { "n", "v" },
            },
        },
    },
    {
        "2kabhishek/co-author.nvim",
        dependencies = {
            "stevearc/dressing.nvim",
            "nvim-telescope/telescope.nvim",
        },
        cmd = { "CoAuthor" },
    },

    -- Window Management
    "tpope/vim-vinegar",

    -- Navigation
    "wellle/targets.vim",
    {
        "joereynolds/place.vim",
        keys = {
            { "ga", "<Plug>(place-insert)", desc = "Place character at <motion>" },
            { "gb", "<Plug>(place-insert-multiple)", desc = "Place multiple characters at <motion>" },
        },
    },
    {
        "chrisgrieser/nvim-various-textobjs",
        lazy = false,
        opts = {
            keymaps = {
                useDefault = true,
                disabledDefaults = { "gw", "r" },
            },
        },
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        requires = "nvim-treesitter/nvim-treesitter",
        config = function()
            require("nvim-treesitter.configs").setup({
                textobjects = {
                    select = {
                        enable = true,
                        keymaps = {
                            -- Built-in captures.
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["it"] = "@type",
                        },
                    },
                    lsp_interop = {
                        enable = true,
                        border = "single",
                        floating_preview_opts = {},
                        peek_definition_code = {
                            ["<leader>K"] = "@function.outer",
                            -- ["<leader>dF"] = "@class.outer",
                        },
                    },
                },
            })
        end,
    },
    {
        "gbprod/substitute.nvim",
        config = true,
        keys = {
            {
                "sx",
                function()
                    require("substitute.exchange").operator()
                end,
                noremap = true,
            },
            {
                "sxx",
                function()
                    require("substitute.exchange").line()
                end,
                noremap = true,
            },
            {
                "X",
                mode = "x",
                function()
                    require("substitute.exchange").visual()
                end,
                noremap = true,
            },
            {
                "sxc",
                function()
                    require("substitute.exchange").cancel()
                end,
                noremap = true,
            },
        },
    },

    -- Colorschemes
    {
        "loganswartz/sunburn.nvim",
        dependencies = {
            "loganswartz/polychrome.nvim",
        },
        config = function()
            vim.cmd.colorscheme("sunburn")
        end,
    },
    {
        "loganswartz/selenized.nvim",
        dependencies = {
            "rktjmp/lush.nvim",
        },
        config = function()
            vim.g.selenized_variant = "bw"
        end,
    },

    -- Misc
    "dstein64/vim-startuptime",
    "lambdalisue/suda.vim",
    "jghauser/mkdir.nvim",
}
