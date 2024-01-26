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
