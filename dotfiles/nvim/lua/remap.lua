-- show key mappings (:map shows all, :nmap shows normal mode, :vmap visual mode....)
-- :map :nmap :vmap :imap, :cmap

-- move between window splits
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")

-- move blocks of text in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- scroll faster - move x amount of lines up/down in normal mode
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

-- keep search terms in the middle
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- place cursor over a word and replace very instance of that word in the file
vim.keymap.set("n", "<leader>ca", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gIc<Left><Left><Left><Left>]])

-- same as default J keymap, but keep cursor in same position
vim.keymap.set("n", "J", "mzJ`z")

-- resize split windows with arrow keys
-- increase/decrease height
vim.keymap.set("n", "<C-Up>", function() vim.cmd("resize +1") end)
vim.keymap.set("n", "<C-Down>", function() vim.cmd("resize -1") end)
-- increase decrease width
vim.keymap.set("n", "<C-Right>", function() vim.cmd("vertical resize +1") end);
vim.keymap.set("n", "<C-Left>", function() vim.cmd("vertical resize -1") end);


-- toggle window fullscreen
-- When the terminal window is maximized this successfully toggles windows
-- fullscreen and returns all windows back to their original size.  While a
-- window is fullscreen, usually there is a single line for all other windows
-- and these can be toggled fullscreen as well.
--
-- Behavior becomes less predictable when the terminal window is not fullscreen
-- or if the monitor is squishes text at all.  Also, if a new buffer is opened
-- while in fullscreen this causes unpredictable behavior as well, which could
-- be possibly fixed with an autocmd for the right Event
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
            WindowState[v.winid].winid = v.winid
            WindowState[v.winid].height = v.height
            WindowState[v.winid].width = v.width
            WindowState[v.winid].is_fullscreen = false
        end
    end
end

local function makeCurrFullscreen()
    local full_h_keys = vim.api.nvim_replace_termcodes("<C-w>_", true, false, true)
    local full_w_keys = vim.api.nvim_replace_termcodes("<C-w>|", true, false, true)
    vim.api.nvim_feedkeys(full_h_keys, "n", false)
    vim.api.nvim_feedkeys(full_w_keys, "n", false)
end

local function resizeToPreState()
    for k, _ in pairs(WindowState) do
        local winid = WindowState[k].winid
        local height = WindowState[k].height
        local width = WindowState[k].width
        vim.api.nvim_win_set_height(winid, height)
        vim.api.nvim_win_set_width(winid, width)
    end
end

-- make the current buffer fullscreen
local function handleNotFs()
    storePreState()
    makeCurrFullscreen()
    ToggleState.currId = vim.api.nvim_get_current_win()
    ToggleState.fullscreen = true
end

-- make the current buffer not fullscreen
local function handleRevertFs()
    resizeToPreState()
    ToggleState.fullscreen = false
    ToggleState.currId = nil
end

-- if ToggleState.fullscreen, make the current buffer fullscreen
-- and update ToggleState.currId to the new buffer
local function handleMakeOtherFs()
    makeCurrFullscreen()
    ToggleState.currId = vim.api.nvim_get_current_win()
end

-- rather than simply have two conditions to check for (fullscreen vs not
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
