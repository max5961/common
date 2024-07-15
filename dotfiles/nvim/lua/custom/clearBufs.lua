-- This current implementation causes issues when reopening a buf which has
-- been deleted, so not usable at the moment

-- clear (mostly) all bufs except currently opened
vim.api.nvim_create_user_command("ClearBufs", function()
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
			if vim.api.nvim_buf_is_loaded(i) then
				vim.cmd("bdelete " .. i)
				deletedCount = deletedCount + 1
			end
		end
	end

	print(deletedCount .. " buffers deleted")
end, {})

-- vim.api.nvim_create_user_command(
--     "ClearBufs", function()
--         vim.cmd("%bd|e#")
--     end,
--     {}
-- )
