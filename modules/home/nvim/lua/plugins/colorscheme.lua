return {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
        require("catppuccin").setup({
            flavour = "mocha",
            transparent_background = true,
            no_italic = false,
            no_bold = false,
            integrations = {
                gitsigns = true,
                harpoon = true,
                treesitter = true,
                telescope = { enabled = true },
                native_lsp = {
                    enabled = true,
                    underlines = {
                        errors = { "undercurl" },
                        hints = { "undercurl" },
                        warnings = { "undercurl" },
                        information = { "undercurl" },
                    },
                },
            },
            color_overrides = {
                mocha = {
                    -- Match Kitty terminal palette
                    base = "#1a1a2e",
                    mantle = "#151525",
                    crust = "#111120",
                    surface0 = "#2a2a3e",
                    surface1 = "#3b2964",
                    surface2 = "#44475a",
                    overlay0 = "#888888",
                    lavender = "#8c52ff",
                    mauve = "#bd93f9",
                    blue = "#8c52ff",
                    sapphire = "#8be9fd",
                    sky = "#a4ffff",
                    teal = "#8be9fd",
                    green = "#50fa7b",
                    yellow = "#f1fa8c",
                    peach = "#ffb86c",
                    red = "#ff5555",
                    maroon = "#ff6e6e",
                    pink = "#d6acff",
                    flamingo = "#a77bff",
                    rosewater = "#ffffff",
                    text = "#e0e0e0",
                    subtext1 = "#cccccc",
                    subtext0 = "#aaaaaa",
                },
            },
        })
        vim.cmd.colorscheme("catppuccin")
    end,
}
