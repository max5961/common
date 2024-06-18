-- opens ~/notes directory and then opens a split window with selection
local function getNotesDirs()
    -- get dirs from ~/notes
    local dirs = {};
    local fd = vim.loop.fs_scandir(vim.loop.os_homedir() .. "/notes");
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
        vim.cmd("12split ~/notes/" .. sel .. "/notes.txt")
    end

    ListNotesInPopUp(opts, cb)
end

function CloseNotesPopUp()
    vim.api.nvim_win_close(Win_id, true)
end

vim.api.nvim_create_user_command("Notes", displayNotes, {});
