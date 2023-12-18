-- https://github.com/ThePrimeagen/harpoon
-- quickly add, delete, and move between files in a buffer

return {
    "ThePrimeagen/harpoon",
    dependencies = {
        "nvim-lua/plenary.nvim"
    },
    config = function()
        local mark = require("harpoon.mark")
        local ui = require("harpoon.ui")

        vim.keymap.set(
            "n",
            "<leader>a",
            function()
                mark.add_file()
                print("File added to Harpoon menu")
            end
        )
        vim.keymap.set("n", "<leader>e", ui.toggle_quick_menu)

        vim.keymap.set("n", "<A-n>", function() ui.nav_next() end)
        vim.keymap.set("n", "<A-p>", function() ui.nav_prev() end)
        vim.keymap.set("n", "<A-1>", function() ui.nav_file(1) end)
        vim.keymap.set("n", "<A-2>", function() ui.nav_file(2) end)
        vim.keymap.set("n", "<A-3>", function() ui.nav_file(3) end)
        vim.keymap.set("n", "<A-4>", function() ui.nav_file(4) end)
        vim.keymap.set("n", "<A-5>", function() ui.nav_file(5) end)
        vim.keymap.set("n", "<A-6>", function() ui.nav_file(6) end)
    end
}
