return {
	"mason-org/mason-lspconfig.nvim",
	dependencies = {
		{
			"mason-org/mason.nvim",
			opts = {
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			},
		},
		"neovim/nvim-lspconfig",
	},
	opts = {},
	config = function()
		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				"bashls",
				"clangd",
				"ts_ls",
				"eslint",
				"html",
				"emmet_language_server",
				"emmet_ls",
				"pylsp",
				"stylelint_lsp",
				"marksman",
				"rust_analyzer",
			},

			automatic_enable = true,
			automatic_installation = true,
		})

		vim.keymap.set("n", "<leader>d", "<cmd>lua vim.diagnostic.open_float()<cr>")
		vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>")
		vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>")

		-- keep diagnostic sign column permanently visible
		-- ...otherwise neovim adds/removes the lsp diagnostic column every time
		-- you go in/out of insert
		vim.opt.signcolumn = "yes"
		vim.diagnostic.config({
			-- show diagnostic signs in sign column
			signs = true,
			-- show the floating virtual text next to diagnostic lines
			virtual_text = true,
		})

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
	end,
}
