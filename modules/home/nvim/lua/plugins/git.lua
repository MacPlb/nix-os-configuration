return {
    -- Lazygit integration
    {
        "kdheepak/lazygit.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            { "<leader>gg", "<cmd>LazyGit<CR>", desc = "Open LazyGit" },
        },
        config = function()
            vim.g.lazygit_floating_window_scaling_factor = 0.9
        end,
    },

    -- Git signs in gutter + blame
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("gitsigns").setup({
                signs = {
                    add          = { text = "│" },
                    change       = { text = "│" },
                    delete       = { text = "▁" },
                    topdelete    = { text = "▔" },
                    changedelete = { text = "~" },
                },
                current_line_blame = true,
                current_line_blame_opts = {
                    delay = 500,
                    virt_text_pos = "eol",
                },
                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns
                    local map = function(mode, l, r, desc)
                        vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
                    end
                    map("n", "]c", gs.next_hunk, "Next hunk")
                    map("n", "[c", gs.prev_hunk, "Prev hunk")
                    map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
                    map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
                    map("n", "<leader>hb", gs.blame_line, "Blame line")
                end,
            })
        end,
    },

    -- Diffview — git tree / log explorer
    {
        "sindrets/diffview.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        cmd = { "DiffviewOpen", "DiffviewFileHistory" },
        keys = {
            { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Git diff view" },
            { "<leader>gh", "<cmd>DiffviewFileHistory<CR>", desc = "Git file history (tree)" },
            { "<leader>gc", "<cmd>DiffviewClose<CR>", desc = "Close diff view" },
        },
        config = function()
            require("diffview").setup({
                enhanced_diff_hl = true,
            })
        end,
    },
}
