return {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,   -- load immediately so <leader>pv works from startup
    config = function()
        require("oil").setup({
            -- ThePrimeagen style — show as a buffer, not a float
            default_file_explorer = true,
            columns = {
                "icon",
                "size",
                "mtime",
            },
            view_options = {
                show_hidden = true,
            },
            keymaps = {
                ["g?"] = "actions.show_help",
                ["<CR>"] = "actions.select",
                ["<C-v>"] = "actions.select_vsplit",
                ["<C-s>"] = "actions.select_split",
                ["-"] = "actions.parent",
                ["_"] = "actions.open_cwd",
                ["`"] = "actions.cd",
                ["q"] = "actions.close",
                ["<leader>pv"] = "actions.close",
            },
            -- Skip large dirs
            skip_confirm_for_simple_edits = true,
        })
    end,
}
