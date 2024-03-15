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
WindowState = {}
ToggleState = {
    fullscreen = false,
    currId = nil
}

local function resetState()
    WindowState = {}
    ToggleState.fullscreen = false
    ToggleState.currId = nil
end

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

local function getLoadedBufsCount()
    local count = 0;

    for _, v in ipairs(vim.fn.getwininfo()) do
        if vim.api.nvim_buf_is_loaded(v.bufnr) then
            count = count + 1;
        end
    end

    return count;
end

local function makeCurrFullscreen()
    ToggleState.currId = vim.api.nvim_get_current_win()
    ToggleState.fullscreen = true

    local full_h_keys = vim.api.nvim_replace_termcodes("<C-w>_", true, false, true)
    local full_w_keys = vim.api.nvim_replace_termcodes("<C-w>|", true, false, true)

    vim.api.nvim_feedkeys(full_h_keys, "n", false)
    vim.api.nvim_feedkeys(full_w_keys, "n", false)
end


local function resizeToPreState()
    -- Resizing NEEDS to be done in ascending order for respective height / width
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
        if vim.api.nvim_win_is_valid(item.winid) then
            vim.api.nvim_win_set_height(item.winid, item.height)
        end
    end
    for _, item in ipairs(ascendingWidths) do
        if vim.api.nvim_win_is_valid(item.winid) then
            vim.api.nvim_win_set_width(item.winid, item.width)
        end
    end
end

local function removeAutoCmds()
    vim.api.nvim_clear_autocmds({ group = "FullScreenToggleAuGroup" })
end

local function createAutoCmds()
    local function handleEvent()
        resizeToPreState()
        resetState()
        removeAutoCmds()
    end

    -- BufLeave means anytime you to leave the current window, which means
    -- anytime the cursor is moved outside of the current window, a different
    -- file is opened in place of the current window, or a pop up window like
    -- telescope is prompted.  BufLeave is not triggered on a new split window
    local group = vim.api.nvim_create_augroup("FullScreenToggleAuGroup", { clear = true })
    vim.api.nvim_create_autocmd("BufLeave", {
        group = group,
        pattern = "*",
        callback = function()
            handleEvent()
        end
    })

    -- WinEnter is triggered after a split, but before the file is loaded;
    -- which is perfect because it allows the windows to resize back to normal
    -- first and then the split window can claim its height/width.  If it was
    -- reversed, the split window would get squished
    vim.api.nvim_create_autocmd("WinEnter", {
        group = group,
        pattern = "*",
        callback = function()
            handleEvent()
        end
    })
end


local function handleNotFs()
    if getLoadedBufsCount() < 2 then
        return
    end

    createAutoCmds()
    storePreState()
    makeCurrFullscreen()
end

local function handleRevertFs()
    resizeToPreState()
    resetState()
    removeAutoCmds()
end

-- if the toggling on a window OTHER THAN the window which is currently
-- fullscreened
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

-- COLOR PICKER
-- ----------------------------------------------------------------------------
-- need xcolor color picker for this to work
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
