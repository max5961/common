-- removes background colors so that terminal transparency is not overridden

return {
	"xiyaowong/transparent.nvim",
	config = function()
		-- require("transparent").setup({
		-- 	groups = {
		-- 		"Normal",
		-- 		"NormalNC",
		-- 		"Comment",
		-- 		"Constant",
		-- 		"Special",
		-- 		"Identifier",
		-- 		"Statement",
		-- 		"PreProc",
		-- 		"Type",
		-- 		"Underlined",
		-- 		"Todo",
		-- 		"String",
		-- 		"Function",
		-- 		"Conditional",
		-- 		"Repeat",
		-- 		"Operator",
		-- 		"Structure",
		-- 		"LineNr",
		-- 		"NonText",
		-- 		"SignColumn",
		-- 		"StatusLine",
		-- 		"StatusLineNC",
		-- 		"EndOfBuffer",
		-- 	},
		-- 	extra_groups = {
		-- 		"NormalFloat", -- plugins which have float panel such as Lazy, Mason, LspInfo
		-- 		"NeoTreeFloatNormal",
		-- 		"NeoTreeNormalNC",
		-- 		"NeoTreeNormal",
		-- 		"FloatBorder", -- removing this adds an wide border on nvim-cmp windows
		-- 		"NvimTreeNormal", -- NvimTree
		-- 		"TelescopeNormal",
		-- 		"TelescopeBorder",
		-- 		"TelescopePromptNormal",
		-- 	},
		-- 	exclude_groups = {
		-- 		"NeoTreeCursorLine",
		-- 		"CursorLine",
		-- 		"CursorLineNr",
		-- 	},
		-- })

		vim.keymap.set("n", "<leader>T", vim.cmd.TransparentToggle, { desc = "Toggle transparency" })

		vim.cmd.TransparentEnable()
	end,
}

-- commands
-- :TransparentEnable
-- :TransparentDisable
-- :TransparentToggle
