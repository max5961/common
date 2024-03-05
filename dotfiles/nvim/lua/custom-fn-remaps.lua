-- SCROLL FASTER
-- ----------------------------------------------------------------------------
-- move x amount of lines up/down in normal mode
local function fast_scroll(lines, down_mapping, up_mapping)
    vim.keymap.set(
        "n",
        down_mapping,
        function() vim.cmd("normal!" .. lines .. "j") end,
        { noremap = true, silent = true }
    )
    vim.keymap.set(
        "n",
        up_mapping,
        function() vim.cmd("normal!" .. lines .. "k") end,
        { noremap = true, silent = true }
    )
end
fast_scroll(10, "<A-j>", "<A-k>")


-- TOGGLE WINDOW FULLSCREEN
-- ----------------------------------------------------------------------------
-- While a window is fullscreen, usually there is a single line for all other
-- windows and these can be toggled fullscreen as well.
--
-- If a new window is opened while a window is toggled fullscreen, this causes
-- unpredictable behavior.  This could probably be fixed with the right autocmd
-- Event, but is not worth the trouble.
WindowState = {}
ToggleState = {
    fullscreen = false,
    currId = nil
}

local function storePreState()
    WindowState = {}
    for _, v in ipairs(vim.fn.getwininfo()) do
        if vim.api.nvim_buf_is_loaded(v.bufnr) then
            WindowState[v.winid] = {}
            WindowState[v.winid].bufnr = v.bufnr
            WindowState[v.winid].winid = v.winid
            WindowState[v.winid].height = v.height
            WindowState[v.winid].width = v.width
        end
    end
end

local function resizeToPreState()
    -- Resizing NEEDS to be done in ascending for respective height / width
    -- dimensions.  Otherwise, the growing of windows to fill dead space causes
    -- undesired effects.
    local ascendingHeights = {}
    local ascendingWidths = {}

    -- get the properties for each window
    for k, _ in pairs(WindowState) do
        if vim.api.nvim_buf_is_loaded(WindowState[k].bufnr) then
            local dict = {
                winid = WindowState[k].winid,
                bufnr = WindowState[k].bufnr,
                height = WindowState[k].height,
                width = WindowState[k].width,
            }
            table.insert(ascendingHeights, dict)
            table.insert(ascendingWidths, dict)
        end
    end

    -- sort the tables in ascending order
    table.sort(ascendingHeights, function(a, b)
        return a.height < b.height
    end)
    table.sort(ascendingWidths, function(a, b)
        return a.height < b.height
    end)

    -- iterate through the sorted lists and set the heights and widths of each
    -- window
    for _, item in ipairs(ascendingHeights) do
        vim.api.nvim_win_set_height(item.winid, item.height)
    end
    for _, item in ipairs(ascendingWidths) do
        vim.api.nvim_win_set_width(item.winid, item.width)
    end
end

local function makeCurrFullscreen()
    ToggleState.currId = vim.api.nvim_get_current_win()
    ToggleState.fullscreen = true

    local full_h_keys = vim.api.nvim_replace_termcodes("<C-w>_", true, false, true)
    local full_w_keys = vim.api.nvim_replace_termcodes("<C-w>|", true, false, true)

    vim.api.nvim_feedkeys(full_h_keys, "n", false)
    vim.api.nvim_feedkeys(full_w_keys, "n", false)
end

-- Make the current buffer fullscreen
local function handleNotFs()
    storePreState()
    makeCurrFullscreen()
end

-- Make the current buffer not fullscreen
local function handleRevertFs()
    resizeToPreState()
    ToggleState.fullscreen = false
    ToggleState.currId = nil
end

-- if ToggleState.fullscreen, make the current buffer fullscreen
-- and update ToggleState.currId to the new buffer
local function handleMakeOtherFs()
    makeCurrFullscreen()
end

-- Rather than simply have two conditions to check for (fullscreen vs not
-- fullscreen), there needs to be 3 to allow for other windows to be toggled
-- while another is already fullscreen.
local function toggleFullScreen()
    local currWindow = vim.api.nvim_get_current_win();

    if not ToggleState.fullscreen then
        handleNotFs()
    elseif ToggleState.currId == currWindow then
        handleRevertFs()
    else
        handleMakeOtherFs()
    end
end

vim.keymap.set(
    "n",
    "<leader>fs",
    function()
        toggleFullScreen()
    end,
    { desc = "Toggle current window fullscreen" }
)
