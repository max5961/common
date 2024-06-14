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

-- opens a split window of notes as a way to quick reference
local function openNotes()
    local categories = { "bash", "cpp", "css", "git", "javascript", "linux-ref", "nodejs", "react", "scss",
        "typescript", "vim" }
    for i, v in ipairs(categories) do
        print(i .. ": " .. v)
    end
    print(" ")

    local category = vim.fn.input("Enter one of the above: ")

    if "number" == type(tonumber(category)) then
        if categories[tonumber(category)] then
            openSplitWindow("~/notes/" .. categories[tonumber(category)] .. "/notes.txt")
        else
            print(" Invalid entry")
        end
    else
        local isValid = false
        for i, v in ipairs(categories) do
            if category == v then
                isValid = true
            end
        end
        if isValid then
            openSplitWindow("~/notes/" .. category .. "/notes.txt");
        else
            print(" Invalid entry")
        end
    end
end

vim.api.nvim_create_user_command("Notes", openNotes, {})
