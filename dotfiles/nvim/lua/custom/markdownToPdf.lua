-- Convert md files to pdf (to-pdf is a bash script that creates a pdf with pandoc)
-- The converted md file will be in the same directory level as the md file
-- @params opts { logStdout: boolean, async: boolean }
local function convertToPdf(opts)
	local logStdout = opts.logStdout or true
	local async = opts.async or false

	local file = vim.api.nvim_buf_get_name(0)
	local ext = vim.fn.expand("%:e")

	if async == true then
		vim.loop.spawn("to-pdf", {
			args = { file, ">", "/dev/null 2>&1" },
			stdio = nil,
		})
		return
	end

	local function notify(msg, level)
		if logStdout == true then
			vim.notify(msg, level)
		end
	end

	local function convert()
		local exitCode = os.execute("to-pdf " .. file .. "> /dev/null 2>&1")
		return exitCode
	end

	if ext == "md" then
		notify("Converting md to pdf...", vim.log.levels.INFO)
		local exitCode = convert()
		if exitCode == true or exitCode == 0 then
			notify("Successfully converted " .. file .. " to pdf.", vim.log.levels.INFO)
		else
			notify("Error converting to pdf", vim.log.levels.ERROR)
		end
	else
		notify("Invalid file type.  Can only convert md files to pdf.", vim.log.levels.ERROR)
	end
end

-- Pdf command
vim.api.nvim_create_user_command("Pdf", function()
	convertToPdf({ logStdout = true })
end, {})

-- Pdf command keymap
vim.keymap.set("n", "<leader>p", function()
	vim.cmd("Pdf")
end)

M = { formatOnSave = true }

-- Format on save
vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = { "*.md" },
	callback = function()
		if M.formatOnSave then
			convertToPdf({ logStdout = false, async = true })
		end
	end,
})

vim.api.nvim_create_user_command("TogglePdfOnSave", function()
	M.formatOnSave = not M.formatOnSave
end, {})

vim.api.nvim_create_user_command("EnablePdfOnSave", function()
	M.formatOnSave = true
end, {})

vim.api.nvim_create_user_command("DisablePdfOnSave", function()
	M.formatOnSave = false
end, {})
