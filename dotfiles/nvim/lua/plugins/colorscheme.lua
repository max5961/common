function SetColorScheme(color)
	vim.cmd("colorscheme " .. color)
end

return {
	{
		"rose-pine/neovim",
		name = "rose-pine",
		priority = 1000,
	},
	{
		"ellisonleao/gruvbox.nvim",
		name = "gruvbox",
		priority = 999,
	},
	{
		"EdenEast/nightfox.nvim",
		name = "nightfox",
		priority = 998,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 997,
	},
	{
		"shaunsingh/nord.nvim",
		name = "nord",
		priority = 996,
	},
	{
		"rebelot/kanagawa.nvim",
		name = "kanagawa",
		priority = 995,
	},
	{
		"neanias/everforest-nvim",
		version = false,
		lazy = false,
		priority = 994,
		config = function()
			require("everforest").setup({
				background = "hard",
				ui_contrast = "high",
			})
		end,
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 993,
		opts = {},
	},
}
