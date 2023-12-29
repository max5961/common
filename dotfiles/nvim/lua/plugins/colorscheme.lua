-- https://github.com/rose-pine/neovim

return {
    {
        'rose-pine/neovim',
        name = 'rose-pine',
        priority = 1000,
        config = function()
            vim.cmd("colorscheme rose-pine")
        end,
    },
    {
        "ellisonleao/gruvbox.nvim",
        name = 'gruvbox',
        priority = 999,
        config = true,
    },
}
