-- https://github.com/xiyaowong/transparent.nvim
-- removes background colors so that terminal transparency is not overridden

return {
    "xiyaowong/transparent.nvim",
    config = function()
        vim.cmd "TransparentEnable"
        require("transparent").setup({
            groups = {
                'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
                'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
                'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
                'SignColumn', 'CursorLine', 'CursorLineNr', 'StatusLine', 'StatusLineNC',
                'EndOfBuffer',
            },
            extra_groups = {
                "NormalFloat",    -- plugins which have float panel such as Lazy, Mason, LspInfo
                -- "NeoTreeFloatNormal", -- adding this removes highlighting on neotree selections
                "FloatBorder",    -- removing this adds an ugly border on nvim-cmp windows
                "NvimTreeNormal", -- NvimTree
                "TelescopeNormal",
                "TelescopeBorder",
                "TelescopePromptNormal",
            },
            exclude_groups = {
                -- "NeoTreeNormal",
                -- "NeoTreeNormalNC",
                -- "NeoTreeFileName",
                -- "NeoTreeFloatBorder",
                -- "NeoTreePreview",
            },
        })
    end
}

-- commands
-- :TransparentEnable
-- :TransparentDisable
-- :TransparentToggle
