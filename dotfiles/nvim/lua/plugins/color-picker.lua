-- https://github.com/uga-rosa/ccc.nvim
-- https://github.com/uga-rosa/ccc.nvim/blob/main/doc/ccc.txt

return {
    {
        "uga-rosa/ccc.nvim",
        config = function()
            require("ccc").setup {}
            vim.api.nvim_set_keymap("n", "<leader>cp", "<cmd>CccPick<CR>", { noremap = true, silent = true })
            vim.api.nvim_set_keymap("n", "<leader>cc", "<cmd>CccConvert<CR>", { noremap = true, silent = true })
        end
    },
    -- {
    --     "ziontee113/color-picker.nvim",
    --     config = function()
    --         vim.api.nvim_set_keymap("n", "<leader>cp", "<cmd>PickColor<CR>", { noremap = true, silent = true })
    --     end
    -- },
    -- {
    --     "max397574/colortils.nvim",
    -- }
}
