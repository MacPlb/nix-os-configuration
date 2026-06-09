return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    config = function()
        local harpoon = require("harpoon")
        harpoon:setup({
            settings = {
                save_on_toggle = true,
                sync_on_ui_close = true,
            },
        })

        -- Add file to harpoon list
        vim.keymap.set("n", "<leader>a", function()
            harpoon:list():add()
            local item = harpoon:list():get(harpoon:list():length())
            local name = item and item.value or "file"
            vim.notify("Harpooned: " .. name, vim.log.levels.INFO)
        end, { desc = "Harpoon: add file" })

        -- Toggle harpoon menu (shows file names)
        vim.keymap.set("n", "<C-e>", function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end, { desc = "Harpoon: toggle menu" })

        -- Navigate to harpooned files with Ctrl+1/2/3/4
        vim.keymap.set("n", "<C-1>", function()
            harpoon:list():select(1)
        end, { desc = "Harpoon: file 1" })

        vim.keymap.set("n", "<C-2>", function()
            harpoon:list():select(2)
        end, { desc = "Harpoon: file 2" })

        vim.keymap.set("n", "<C-3>", function()
            harpoon:list():select(3)
        end, { desc = "Harpoon: file 3" })

        vim.keymap.set("n", "<C-4>", function()
            harpoon:list():select(4)
        end, { desc = "Harpoon: file 4" })

        -- Alternative leader-key bindings (in case terminal eats Ctrl+number)
        vim.keymap.set("n", "<leader>1", function()
            harpoon:list():select(1)
        end, { desc = "Harpoon: file 1" })

        vim.keymap.set("n", "<leader>2", function()
            harpoon:list():select(2)
        end, { desc = "Harpoon: file 2" })

        vim.keymap.set("n", "<leader>3", function()
            harpoon:list():select(3)
        end, { desc = "Harpoon: file 3" })

        vim.keymap.set("n", "<leader>4", function()
            harpoon:list():select(4)
        end, { desc = "Harpoon: file 4" })
    end,
}
