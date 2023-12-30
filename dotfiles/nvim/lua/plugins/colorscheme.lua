-- https://github.com/rose-pine/neovim

function SetColorScheme(color)
    vim.cmd("colorscheme " .. color)
    vim.cmd("!change-alacritty-theme " .. color)
end

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
