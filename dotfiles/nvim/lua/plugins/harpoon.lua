-- https://github.com/ThePrimeagen/harpoon
-- quickly add, delete, and move between files in a buffer
local M = {}

-- These are added in the config function
-- M.mark = require("harpoon.mark")
-- M.ui = require("harpoon.ui")

M.wrapper = function(cb)
	local buffer = vim.api.nvim_get_option_value("buftype", { buf = vim.fn.getwininfo().bufnr })

	if buffer ~= "terminal" then
		cb()
	else
		print("Harpoon doesn't work well with terminal buffers")
	end
end

M.addFile = function()
	M.wrapper(function()
		M.mark.add_file()
		print("File added to Harpoon menu")
	end)
end

M.toggleQuickMenu = function()
	M.wrapper(M.ui.toggle_quick_menu)
end

M.navNext = function()
	M.wrapper(M.ui.nav_next)
end

M.navPrev = function()
	M.wrapper(M.ui.nav_prev)
end

M.navBufNum = function(num)
	return function()
		M.wrapper(function()
			if M.mark.valid_index(num) then
				M.ui.nav_file(num)
				print("Switched to harpoon buf: " .. num)
			else
				print("Invalid harpoon buf: " .. num)
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
