-- :E
-- run after switching git branches
-- reloads the current buffer and restarts lsp
-- LSP errors persist on different git branches of the same file. Restart LSP to fix
vim.api.nvim_create_user_command(
    "E", function()
        vim.cmd("e!")         -- reload the buffer without saving
        vim.cmd("LspRestart") -- restart LSP
    end,
    {}
)

vim.api.nvim_create_user_command(
    "Source", function()
        vim.cmd("so ~/.config/nvim/lua/set.lua")
        vim.cmd("so ~/.config/nvim/lua/remap.lua")
        vim.cmd("so ~/.config/nvim/lua/user-commands.lua")
        vim.cmd("so ~/.config/nvim/lua/custom-fn-remaps.lua")
        vim.cmd("so ~/.config/nvim/lua/lsp-setup.lua")
        print("Sourced: set, remap, user-commands, custom-fn-reamps, lsp-setup")
    end,
    {}
)

-- vim.api.nvim_create_user_command(
--     "ClearBufs", function()
--         vim.cmd("%bd|e#")
--     end,
--     {}
-- )

-- clear (mostly) all bufs except currently opened
vim.api.nvim_create_user_command(
    "ClearBufs", function()
        local deletedCount = 0

        for _, i in ipairs(vim.api.nvim_list_bufs()) do
            local canDelete = true

            -- Don't delete any buffers that are currently open
            for _, j in ipairs(vim.fn.getwininfo()) do
                if i == j.bufnr then
                    canDelete = false
                end
            end

            -- Don't delete any hidden term buffers in case there are running processes
            local buftype = vim.api.nvim_get_option_value("buftype", { buf = i })
            if buftype == "terminal" then
                canDelete = false
            end

            -- Don't delete any buffers with unsaved changes
            if vim.api.nvim_get_option_value("modified", { buf = i }) then
                canDelete = false
            end


            if canDelete then
                -- nvim_list_bufs still list bufs that have already been deleted
                if (vim.api.nvim_buf_is_loaded(i)) then
                    vim.cmd("bdelete " .. i)
                    deletedCount = deletedCount + 1
                end
            end
        end

        print(deletedCount .. " buffers deleted")
    end,
    {}
)

-- used for user commands below
local function openSplitWindow(path)
    vim.cmd("12split " .. path)
end

-- opens a split window with a listing of keybinds I find useful and often forget
vim.api.nvim_create_user_command(
    "Help", function()
        openSplitWindow("~/common/dotfiles/nvim/doc/keybinds.txt")
    end,
    {}
)

-- opens ~/notes directory and then opens a split window with selection
local function getNotesDirs()
    -- get dirs from ~/notes
    local dirs = {};
    -- local fd = vim.loop.fs_scandir(vim.loop.os_homedir() .. "/notes");
    local fd = vim.loop.fs_scandir(".")
    if fd then
        while true do
            local name, typ = vim.loop.fs_scandir_next(fd)
            if typ == "directory" then
                table.insert(dirs, name);
            end
            if name == nil then
                break
            end
        end
    end

    -- print for dev
    return dirs
end

getNotesDirs()

-- make popup and populate
local popup = require("plenary.popup")

local Win_id

local function ListNotesInPopUp(opts, cb)
    -- if height exceeds 5 lines, height will grow to fit
    local height = 5
    local width = 30
    local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }

    Win_id = popup.create(opts, {
        title = "Notes",
        highlight = "NotesWindow",
        line = math.floor(((vim.o.lines - height) / 2) - 1),
        col = math.floor((vim.o.columns - width) / 2),
        minwidth = 30,
        minheight = 5,
        borderchars = borderchars,
        callback = cb,
    })

    local bufnr = vim.api.nvim_win_get_buf(Win_id)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "q", "<cmd>lua CloseNotesPopUp()<CR>", { silent = false })
end

local function displayNotes()
    local opts = getNotesDirs()

    local function cb(_, sel)
        openSplitWindow("~/notes/" .. sel .. "/notes.txt")
    end

    ListNotesInPopUp(opts, cb)
end

function CloseNotesPopUp()
    vim.api.nvim_win_close(Win_id, true)
end

vim.api.nvim_create_user_command("Notes", displayNotes, {});
