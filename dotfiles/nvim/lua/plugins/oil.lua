-- https://github.com/stevearc/oil.nvim?tab=readme-ov-file#quick-start

return {
	"stevearc/oil.nvim",
	opts = {},
	-- Optional dependencies
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("oil").setup({
			keymaps = {
				-- Disable <C-h,j,k,l> to nav between windows while in Oil
				["<C-h>"] = false,
				["<C-l>"] = false,

				-- Open parent directory in current window
				["<BS>"] = "actions.parent",
				["q"] = "actions.close",
				["s"] = { "actions.select", opts = { vertical = true }, desc = "Open the entry in a vertical split" },
				["S"] = {
					"actions.select",
					opts = { horizontal = true },
					desc = "Open the entry in a horizontal split",
				},
			},
			view_options = {
				show_hidden = true,
			},
			delete_to_trash = true,
		})

		-- Open Oil floating window (doesn't allow preview, but shows path)
		vim.keymap.set("n", "<leader>o", require("oil").toggle_float)

		vim.keymap.set("n", "<A-o>", function()
			local filetype = vim.o.filetype

			if filetype ~= "oil" then
				vim.cmd("Oil")

				-- wait until Oil is fully loaded
				vim.defer_fn(function()
					require("oil").open_preview()
				end, 100)
			else
				require("oil").close()
			end

			-- print(vim.inspect(require("oil")))
		end)
	end,
}
