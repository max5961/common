return {
	{
		"hrsh7th/nvim-cmp",
		version = false, -- last release is way too old
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
		},
		-- Not all LSP servers add brackets when completing a function.
		-- To better deal with this, LazyVim adds a custom option to cmp,
		-- that you can configure. For example:
		--
		-- ```lua
		-- opts = {
		--   auto_brackets = { "python" }
		-- }
		-- ```
		opts = function()
			-- Register nvim-cmp lsp capabilities
			vim.lsp.config("*", { capabilities = require("cmp_nvim_lsp").default_capabilities() })

			vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
			local cmp = require("cmp")
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local defaults = require("cmp.config.default")()
			local auto_select = true

			-- add parentheses to the end of completions when applicable
			-- https://github.com/windwp/nvim-autopairs/blob/master/doc/nvim-autopairs.txt
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

			return {
				auto_brackets = {}, -- configure any filetype to auto add brackets
				completion = {
					completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
				},
				preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
				mapping = cmp.mapping.preset.insert({
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
				}),
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				sources = cmp.config.sources({
					{ name = "lazydev" },
					{ name = "nvim_lsp" },
					{ name = "path" },
				}, {
					{ name = "buffer" },
				}),
				formatting = {
					format = function(entry, item)
						-- local icons = LazyVim.config.icons.kinds
						-- if icons[item.kind] then
						-- 	item.kind = icons[item.kind] .. item.kind
						-- end

						local widths = {
							abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 40,
							menu = vim.g.cmp_widths and vim.g.cmp_widths.menu or 30,
						}

						for key, width in pairs(widths) do
							if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
								item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. "…"
							end
						end

						return item
					end,
				},
				experimental = {
					-- only show ghost text when we show ai completions
					ghost_text = vim.g.ai_cmp and {
						hl_group = "CmpGhostText",
					} or false,
				},
				sorting = defaults.sorting,
			}
		end,
		-- main = "lazyvim.util.cmp",
	},
}
