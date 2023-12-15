-- https://github.com/brenoprata10/nvim-highlight-colors?tab=readme-ov-file

return {
    "brenoprata10/nvim-highlight-colors",
    version = "*",
    config = function()
        require("nvim-highlight-colors").setup {
            render = "background", -- (background, foreground, first_column)
            enable_named_colors = true,
        }
        
        -- setup functions to toggle plugin
        local builtin = require("nvim-highlight-colors")
        function ToggleColors()
            builtin.toggle();
        end
        function TurnOffColors()
            builtin.turnOff()
        end
        function TurnOnColors()
            builtin.turnOn()
        end
    end
}
