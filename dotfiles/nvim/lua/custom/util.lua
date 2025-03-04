-- :E
-- Run after switching git branches
-- Reloads the current buffer and restarts lsp
-- LSP errors persist on different git branches of the same file. Restart LSP to fix
vim.api.nvim_create_user_command("E", function()
	vim.cmd("e!") -- reload the buffer without saving
	vim.cmd("LspRestart") -- restart LSP
end, {})

vim.api.nvim_create_user_command("Source", function()
	vim.cmd("so ~/.config/nvim/lua/set.lua")
	vim.cmd("so ~/.config/nvim/lua/remap.lua")
	vim.cmd("so ~/.config/nvim/lua/user-commands.lua")
	vim.cmd("so ~/.config/nvim/lua/custom-fn-remaps.lua")
	vim.cmd("so ~/.config/nvim/lua/lsp-setup.lua")
	print("Sourced: set, remap, user-commands, custom-fn-reamps, lsp-setup")
end, {})

vim.api.nvim_create_user_command("Help", function()
	vim.cmd("12split " .. "~/common/dotfiles/nvim/doc/keybinds.txt")
end, {})

-- Open current buffer in VsCode
vim.api.nvim_create_user_command("Code", function()
	local currFile = vim.api.nvim_buf_get_name(0)
	local cwd = vim.fn.getcwd()
	os.execute("rm -rf ~/.config/Code/Backups")
	os.execute("rm -rf ~/.config/Code/blob_storage")
	os.execute("rm -rf ~/.config/Code/Cache")
	os.execute("rm -rf ~/.config/Code/CachedData")
	os.execute("rm -rf ~/.config/Code/CachedProfilesData")
	os.execute("rm -rf ~/.config/Code/Code\\sCache")
	os.execute("rm -rf ~/.config/Code/Session\\sStorage")
	-- os.execute("code --disable-workspace-trust " .. cwd .. " " .. currFile)
	os.execute("code --disable-workspace-trust --disable-feature=sidebar " .. cwd .. " " .. currFile)
end, {})

vim.keymap.set("n", "<leader>d", function()
	vim.cmd("lua vim.diagnostic.open_float()")
end, { desc = "Toggle current window fullscreen" })

vim.keymap.set("n", "<leader>ll", function()
	vim.api.nvim_set_current_line(string.rep("-", 80))
end, { desc = "Add a line (for text files)" })
