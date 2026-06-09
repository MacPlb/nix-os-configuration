return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
        local wk = require("which-key")
        wk.setup({
            delay = 300,
            icons = {
                breadcrumb = "»",
                separator = "➜",
                group = "+",
            },
            win = {
                border = "rounded",
                padding = { 1, 2 },
            },
        })

        -- Register group labels so the popup is organized
        wk.add({
            { "<leader>p", group = "Project / Files" },
            { "<leader>g", group = "Git" },
            { "<leader>h", group = "Hunk (git)" },
            { "<leader>s", group = "Search" },
            { "<leader>f", group = "Find" },
            { "<leader>r", group = "Refactor" },
            { "<leader>c", group = "Code" },
        })
    end,
}
