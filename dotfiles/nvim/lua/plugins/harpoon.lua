-- https://github.com/ThePrimeagen/harpoon
-- quickly add, delete, and move between files in a buffer

local M = {}

-- These are added in the config function
-- M.mark = require("harpoon.mark")
-- M.ui = require("harpoon.ui")

M.switchedMsg = function(num, invalid)
	if invalid == true then
		print("Invalid buf: " .. num)
	else
		local str = "buf: "
		for idx = 1, M.mark.get_length() do
			if idx == num then
				str = str .. "[" .. idx .. "]"
			else
				str = str .. " " .. idx .. " "
			end
			-- local name = string.sub(M.mark.get_marked_file_name(idx), -25)
			-- if idx == num then
			-- 	str = str .. "[" .. name .. "]"
			-- else
			-- 	str = str .. " " .. name .. " "
			-- end
		end

		if M.mark.get_length() == 0 then
			print(str .. "There are no Harpoon bufs")
		else
			print(str)
		end
	end
end

M.wrapper = function(cb)
	local buffer = vim.api.nvim_get_option_value("buftype", { buf = vim.fn.getwininfo().bufnr })

	if buffer ~= "terminal" then
		cb()
		return true
	else
		print("Harpoon doesn't work well with terminal buffers")
		return false
	end
end

M.switchWrapper = function(cb)
	if M.wrapper(cb) then
		M.switchedMsg(M.mark.get_current_index())
	end
end

M.addFile = function()
	M.wrapper(function()
		M.mark.add_file()
		print("File added to Harpoon menu " .. "(" .. M.mark.get_length() .. " bufs)")
	end)
end

M.toggleQuickMenu = function()
	M.wrapper(M.ui.toggle_quick_menu)
end

M.navNext = function()
	M.switchWrapper(function()
		M.wrapper(M.ui.nav_next)
	end)
end

M.navPrev = function()
	M.switchWrapper(function()
		M.wrapper(M.ui.nav_prev)
	end)
end

M.navBufNum = function(num)
	return function()
		M.wrapper(function()
			if M.mark.valid_index(num) then
				M.ui.nav_file(num)
				M.switchedMsg(num)
			else
				M.switchedMsg(num, true)
			end
		end)
	end
end

return {
	"ThePrimeagen/harpoon",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local mark = require("harpoon.mark")
		local ui = require("harpoon.ui")

		M.mark = mark
		M.ui = ui

		vim.keymap.set("n", "<leader>a", M.addFile)
		vim.keymap.set("n", "<leader>e", M.toggleQuickMenu)
		vim.keymap.set("n", "<A-n>", M.navNext)
		vim.keymap.set("n", "<A-p>", M.navPrev)
		vim.keymap.set("n", "<leader>1", M.navBufNum(1))
		vim.keymap.set("n", "<leader>2", M.navBufNum(2))
		vim.keymap.set("n", "<leader>3", M.navBufNum(3))
		vim.keymap.set("n", "<leader>4", M.navBufNum(4))
		vim.keymap.set("n", "<leader>5", M.navBufNum(5))
		vim.keymap.set("n", "<leader>6", M.navBufNum(6))
	end,
}
