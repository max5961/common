return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.4",
	-- or                              , branch = '0.1.x',
	dependencies = { "nvim-lua/plenary.nvim" },

	-- set remaps
	config = function()
		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
		vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
		vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
		vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})

		local telescope = require("telescope")
		telescope.setup({
			pickers = {
				find_files = {
					hidden = true,
				},
			},
			defaults = {
				borderchars = { "═", "║", "═", "║", "╔", "╗", "╝", "╚" },
				file_ignore_patterns = {
					".git",
					"node_modules",
					"dist/",
					"build/",
					"target/",
					"%.png",
					"%.jpg",
					"%.jpeg",
					"%.svg",
					"%.mp4",
					"%.mp3",
					"%.mkv",
					"%.webm",
					"%.o",
					"%.out",
					"%.zip",
					"%.tar",
					"%.gz",
				},
			},
		})

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "TelescopeResults",
			command = "setlocal nofoldenable",
		})
	end,
}
