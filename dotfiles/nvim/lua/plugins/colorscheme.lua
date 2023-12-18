-- https://github.com/rose-pine/neovim

local function set_colors(color)
    vim.cmd("colorscheme " .. color)
end

return {
    {
        'rose-pine/neovim',
        name = 'rose-pine',
        priority = 1000,
        config = function()
            set_colors("rose-pine")
        end,
    },
    {
        "ellisonleao/gruvbox.nvim",
        name = 'gruvbox',
        priority = 999,
        config = true,
    },
}
