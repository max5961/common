return {
	-- manage lsp servers from inside neovim
	{ "williamboman/mason.nvim" },
	{ "williamboman/mason-lspconfig.nvim" },

	{ "VonHeikemen/lsp-zero.nvim", branch = "v3.x" },
	{ "neovim/nvim-lspconfig" },
	{ "hrsh7th/cmp-nvim-lsp" },

	-- Last working commit before bug involving $.  gh issue still open
	-- https://github.com/hrsh7th/nvim-cmp/issues/1877
	{ "hrsh7th/nvim-cmp", commit = "b356f2c", pin = true },
	{ "hrsh7th/cmp-path" },
	{ "L3MON4D3/LuaSnip" },
}
