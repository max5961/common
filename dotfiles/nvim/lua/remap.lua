-- show all key mappings
-- :map, :nmap, :vmap, :imap, :cmap (all, n, v, i, cmd)

-- move between window splits
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")

-- move blocks of text in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- scroll faster - move x amount of lines up/down in n
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

-- toggle current window between fullscreen
Window_state = {}
vim.keymap.set(
    "n",
    "<leader>fs",
    function()
        local function makeWinNormal(win)
            vim.cmd("resize " .. Window_state[win].height)
            vim.cmd("vertical resize " .. Window_state[win].width)
        end

        local function makeWinFullScreen()
            local full_h_keys = vim.api.nvim_replace_termcodes("<C-w>_", true, false, true)
            local full_w_keys = vim.api.nvim_replace_termcodes("<C-w>|", true, false, true)
            vim.api.nvim_feedkeys(full_h_keys, "n", false)
            vim.api.nvim_feedkeys(full_w_keys, "n", false)
        end

        local win = vim.api.nvim_get_current_win();
        if not Window_state[win] then
            Window_state[win] = {}
            Window_state[win].is_fullscreen = false
        end

        if not Window_state[win].is_fullscreen then
            Window_state[win].is_fullscreen = true

            local height = vim.fn.winheight(0)
            local width = vim.fn.winwidth(0)
            Window_state[win].height = height
            Window_state[win].width = width

            makeWinFullScreen()
        else
            Window_state[win].is_fullscreen = false

            makeWinNormal(win)
        end
    end,
    { desc = "Toggle current window fullscreen" }
)
