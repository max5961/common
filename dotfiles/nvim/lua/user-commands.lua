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
vim.api.nvim_create_user_command(
    "Notes", function()
        local categories = { "bash", "css", "cpp", "typescript" }
        for _, v in ipairs(categories) do
            print(v)
        end
        print(" ")

        local category = vim.fn.input("Enter one of the above: ")

        if category == "cpp" then
            openSplitWindow("~/notes/cpp/cpp-tutorial/notes.txt");
        end
    end,
    {}
)
