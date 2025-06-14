-- Not exclusive to LSP servers
vim.keymap.set("n", "<leader>d", "<cmd>lua vim.diagnostic.open_float()<cr>")
vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>")
vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>")

vim.api.nvim_create_autocmd("LspAttach", {
	desc = "LSP actions",
	callback = function(event)
		-- TypeScript LSP was giving two options for gd class defs (name and constructor)
		-- and multiple options are also generally annoying. (leader gd as a fallback
		-- to the normal gd function)
		local function pick_first()
			vim.lsp.buf.definition({
				on_list = function(t)
					local loc = t.items[1].user_data
					vim.lsp.util.show_document(loc, "utf-8")
				end,
			})
		end

		local opts = { buffer = event.buf }

		-- these will be buffer-local keybindings
		-- because they only work if you have an active language server

		vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover({border = 'rounded'})<cr>", opts)
		vim.keymap.set("n", "gd", pick_first, opts)
		vim.keymap.set("n", "<leader>gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
		vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
		vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
		-- vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
		-- vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
		-- vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
		-- vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
		-- vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
		-- vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
	end,
})

vim.diagnostic.config({
	virtual_text = true,
	float = {
		border = "rounded",
	},
})

local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

require("mason").setup()
require("mason-lspconfig").setup({

	-- list of language servers
	-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
	ensure_installed = {
		"lua_ls",
		"ts_ls", -- was "tsserver"
		"eslint",
		"html",
		"cssls",
		"emmet_language_server",
		"emmet_ls",
		"bashls",
		"clangd",
		"pylsp",
		"stylelint_lsp",
	},
	handlers = {
		function(server_name)
			require("lspconfig")[server_name].setup({ capabilities = lsp_capabilities })
		end,
		stylelint_lsp = function() end,
		cssls = function()
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
			})
		end,
	},
})

local function setup_lang_servers()
	vim.lsp.config("lua_ls", {
		capabilities = lsp_capabilities,
		settings = {
			Lua = {
				runtime = {
					version = "LuaJIT",
				},
				diagnostics = {
					-- Still does not work to recognize the 'vim' global...
					globals = { "vim" },
				},
				workspace = {
					library = {
						vim.env.VIMRUNTIME,
					},
				},
			},
		},
	})

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

	local function css_lang_server_setup()
		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		local cssCapabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities.textDocument.completion.completionItem.snippetSupport = true

		require("lspconfig").cssls.setup({
			capabilities = cssCapabilities,
			filetypes = { "css", "scss" },

			-- to get css completions, you need to have stylelint-lsp installed LOCALLY
			-- for some reason
			cmd = { "vscode-css-language-server", "--stdio" },
		})
	end
	css_lang_server_setup()
end

setup_lang_servers()

local cmp = require("cmp")
local cmp_autopairs = require("nvim-autopairs.completion.cmp")

-- adds parentheses to the end of completions when applicable
-- https://github.com/windwp/nvim-autopairs/blob/master/doc/nvim-autopairs.txt
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

-- <A-j> and <A-k> move up/down in drop down menu
-- Tab to complete highlighted selection
-- the first item is always preselected
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
