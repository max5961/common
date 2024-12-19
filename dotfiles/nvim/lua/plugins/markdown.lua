-- https://github.com/MeanderingProgrammer/render-markdown.nvim?tab=readme-ov-file

return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {},
		config = function()
			-- leader + m to toggle
			vim.keymap.set("n", "<leader>m", function()
				require("render-markdown").toggle()
			end)

			-- enable by default
			vim.cmd("RenderMarkdown enable")
		end,
	},
}
