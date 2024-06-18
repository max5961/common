-- Need xcolor color picker for this to work
-- https://github.com/Soft/xcolor/tree/master
local function colorPicker()
    local color = vim.fn.system("xcolor")
    color = color:gsub("%s+", "")
    color = color .. ";"
    vim.api.nvim_put({ color }, "", true, true);
end

vim.keymap.set(
    "n",
    "<leader>xc",
    function()
        colorPicker()
    end
)
