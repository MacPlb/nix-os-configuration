return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = {
                "go", "gomod", "gosum",
                "python",
                "c_sharp",
                "lua",
                "nix",
                "json", "yaml", "toml",
                "markdown", "markdown_inline",
                "bash",
                "vim", "vimdoc",
                "gitcommit", "diff",
            },
            highlight = {
                enable = true,
                -- Disable highlighting on large files
                disable = function(_, buf)
                    return vim.b[buf].large_buf
                end,
            },
            indent = { enable = true },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<C-space>",
                    node_incremental = "<C-space>",
                    scope_incremental = false,
                    node_decremental = "<bs>",
                },
            },
        })
    end,
}
