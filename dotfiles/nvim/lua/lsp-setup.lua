local lsp_zero = require("lsp-zero")

lsp_zero.on_attach(function(client, bufnr)
	-- see :help lsp-zero-keybindings
	-- to learn the available actions
	lsp_zero.default_keymaps({ buffer = bufnr })
end)

require("mason").setup({})
require("mason-lspconfig").setup({

	-- list of language servers
	-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
	ensure_installed = {
		"ts_ls", -- was "tsserver"
		"eslint",
		"html",
		"cssls",
		"emmet_language_server",
		"emmet_ls",
		"bashls",
		"clangd",
		"pylsp",
		"lua_ls",
	},
	handlers = {
		lsp_zero.default_setup,
	},
})

-- configure lua_ls for nvim
local lsp = require("lsp-zero").preset({})
lsp.on_attach(function(client, bufnr)
	lsp.default_keymaps({ buffer = bufnr })
end)
require("lspconfig").lua_ls.setup(lsp.nvim_lua_ls())
lsp.setup()

require("lspconfig").stylelint_lsp.setup({
	filetypes = { "css", "scss" },
	root_dir = require("lspconfig").util.root_pattern("package.json", ".stylelintrc.json", ".git"),
	settings = {
		stylelintplus = {
			-- see available options in stylelint-lsp documentation
		},
	},
	on_attach = function(client)
		client.server_capabilities.document_formatting = false
	end,
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local cssCapabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- CSS Language Server
require("lspconfig").cssls.setup({
	capabilities = cssCapabilities,
	filetypes = { "css", "scss" },

	-- to get css completions, you need to have stylelint-lsp installed LOCALLY
	-- for some reason
	cmd = { "vscode-css-language-server", "--stdio" },
	-- cmd = { "stylelint-lsp", "--stdio" },
})

-- require("lspconfig").css_variables.setup({})

-- This wasn't being used and was possibly causing lag
-- CSS Modules Language Server (if additional configuration is needed)
-- Adjust as necessary based on the server's requirements
require("lspconfig").cssmodules_ls.setup({
	capabilities = capabilities,
	filetypes = { "css", "scss" },
	cmd = { "vscode-css-language-server", "--stdio" },
})

-- setup autocomplete
-- Alt + j or k to move up/down in drop down menu
-- Tab to complete highlighted selection
-- the first item is always preselected
local cmp = require("cmp")
local cmp_autopairs = require("nvim-autopairs.completion.cmp")

-- adds parentheses to the end of completions when applicable
-- https://github.com/windwp/nvim-autopairs/blob/master/doc/nvim-autopairs.txt
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

cmp.setup({
	-- always preselect the first item
	preselect = "item",
	completion = {
		completeopt = "menu,menuone,noinsert",
	},

	-- sources = {
	-- 	{ name = "nvim_lsp" },
	-- 	{ name = "luasnip" },
	-- 	{
	-- 		name = "scss",
	-- 		option = {
	-- 			folders = { "src/style" },
	-- 		},
	-- 	},
	-- },
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		-- { name = 'vsnip' }, -- For vsnip users.
		{ name = "luasnip" }, -- For luasnip users.
		-- { name = 'ultisnips' }, -- For ultisnips users.
		-- { name = 'snippy' }, -- For snippy users.
	}, {
		{ name = "buffer" },
	}),
	-- add border to the completion and documentation menu
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},

	-- define custom mappings while keeping the defaults
	mapping = {
		-- confirm selection
		["<C-y>"] = cmp.mapping.confirm({ select = false }),
		["<Tab>"] = cmp.mapping.confirm({ select = false }),

		["<C-e>"] = cmp.mapping.abort(),

		-- move up menu
		["<Up>"] = cmp.mapping.select_prev_item({ behavior = "select" }),
		["<A-k>"] = cmp.mapping.select_prev_item({ behavior = "select" }),
		-- move down menu
		["<Down>"] = cmp.mapping.select_next_item({ behavior = "select" }),
		["<A-j>"] = cmp.mapping.select_next_item({ behavior = "select" }),

		["<C-p>"] = cmp.mapping(function()
			if cmp.visible() then
				cmp.select_prev_item({ behavior = "insert" })
			else
				cmp.complete()
			end
		end),
		["<C-n>"] = cmp.mapping(function()
			if cmp.visible() then
				cmp.select_next_item({ behavior = "insert" })
			else
				cmp.complete()
			end
		end),
	},
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
})
