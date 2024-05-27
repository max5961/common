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
        -- config = function()
        --     vim.cmd("colorscheme rose-pine")
        -- end,
    },
    {
        "ellisonleao/gruvbox.nvim",
        name = 'gruvbox',
        priority = 999,
        -- config = function()
        --     vim.cmd("colorscheme gruvbox")
        -- end
    },
    {
        "EdenEast/nightfox.nvim",
        name = "nightfox",
        priority = 998,
        -- config = function()
        --     vim.cmd("colorscheme terafox")
        -- end
    },
    {
        "catppuccin/nvim",
        name = "catpuccin",
        priority = 997,
        config = function()
            vim.cmd("colorscheme catppuccin")
        end
    },
    {
        "shaunsingh/nord.nvim",
        name = "nord",
        priority = 996,
        -- config = function()
        --     vim.cmd("colorscheme nord")
        -- end
    },
    {
        "rebelot/kanagawa.nvim",
        name = "kanagawa",
        priority = 995,
        -- config = function()
        --     vim.cmd("colorscheme kanagawa")
        -- end

    }

}
