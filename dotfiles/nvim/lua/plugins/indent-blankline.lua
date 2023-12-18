-- https://github.com/lukas-reineke/indent-blankline.nvim
-- guidelines on indents

return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
    config = function()
        require("ibl").setup({
            indent = {
                char = "▏",
            }
        })
    end
}
