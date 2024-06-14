-- https://github.com/stevearc/oil.nvim?tab=readme-ov-file#quick-start

return {
    'stevearc/oil.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("oil").setup {
            keymaps = {
                -- Disable <C-h,j,k,l> to nav between windows while in Oil
                ["<C-h>"] = false,
                ["<C-l>"] = false,

                -- Open parent directory in current window
                ["<BS>"] = "actions.parent",
                ["q"] = "actions.close",
                ["s"] = { "actions.select", opts = { vertical = true }, desc = "Open the entry in a vertical split" },
                ["S"] = { "actions.select", opts = { horizontal = true }, desc = "Open the entry in a horizontal split" },
            },
            view_options = {
                show_hidden = true,
            },

        }

        -- Open Oil floating window (doesn't allow preview, but shows path)
        vim.keymap.set("n", "<leader>o", require("oil").toggle_float)

        -- Open oil in NON floating window (doesn't show path, but allows preview)
        vim.keymap.set("n", "<leader>O", "<CMD>Oil<CR>");
    end

}
