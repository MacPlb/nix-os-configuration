return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    keys = {
        { "<leader>pf", "<cmd>Telescope find_files<CR>", desc = "Find files (cwd)" },
        { "<leader>ps", "<cmd>Telescope live_grep<CR>", desc = "Live grep (cwd)" },
        { "<leader>pb", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
        { "<leader>ph", "<cmd>Telescope help_tags<CR>", desc = "Help tags" },
        { "<C-p>", "<cmd>Telescope git_files<CR>", desc = "Git files" },

        -- Global search — search across the entire system from /
        {
            "<leader>sg",
            function()
                require("telescope.builtin").live_grep({ cwd = "/" })
            end,
            desc = "Global grep (whole PC)",
        },
        {
            "<leader>sf",
            function()
                require("telescope.builtin").find_files({ cwd = "/" })
            end,
            desc = "Global find files (whole PC)",
        },

        -- Local search — prompts for a directory, then searches within it
        {
            "<leader>sd",
            function()
                local dir = vim.fn.input("Search dir: ", "", "dir")
                if dir ~= "" then
                    require("telescope.builtin").live_grep({ cwd = dir })
                end
            end,
            desc = "Grep in directory",
        },
        {
            "<leader>fd",
            function()
                local dir = vim.fn.input("Find files in: ", "", "dir")
                if dir ~= "" then
                    require("telescope.builtin").find_files({ cwd = dir })
                end
            end,
            desc = "Find files in directory",
        },
    },
    config = function()
        require("telescope").setup({
            defaults = {
                file_ignore_patterns = { "node_modules", ".git/", "bin/", "obj/" },
                layout_strategy = "horizontal",
                layout_config = {
                    horizontal = { preview_width = 0.55 },
                },
            },
        })
    end,
}
