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
