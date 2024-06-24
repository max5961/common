return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>"),
	},
}
