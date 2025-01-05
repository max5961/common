-- https://github.com/nvim-lualine/lualine.nvim
-- status line to replace the default bottom line

return {
	"nvim-lualine/lualine.nvim",
	opts = {
		options = {
			icons_enabled = false,
			-- theme = "rose-pine",
			-- theme = "terafox",
			component_separators = "|",
			selection_separators = "",
		},
	},
}
