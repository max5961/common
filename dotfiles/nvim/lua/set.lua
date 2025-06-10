-- https://neovim.io/doc/user/options.html
-- :h set

-- tabs / indents
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- swapfile/backup/undo
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- split window preferences
vim.opt.splitright = true -- split vertical window to the right
-- vim.opt.splitbelow = true -- split horizontal window to the bottom

-- search
vim.opt.hlsearch = false
-- vim.opt.hlsearch = true
-- vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true -- makes the search case sensitive if it includes uppercase letters

-- formatting
vim.opt.wrap = false -- disable linewrap
vim.opt.colorcolumn = "80" -- text can extend past but add margin column as a guide
vim.opt.textwidth = 0 -- disable max width of text being inserted

-- other
vim.opt.scrolloff = 12 -- keeps at least x lines padding when scrolling up/down
vim.opt.clipboard = "unnamedplus" -- enable pasting yanked text outside of neovim
vim.opt.guicursor = "n:blinkon0" -- rectangle cursor, no blinking
vim.opt.mouse = "" -- disable mouse click
vim.opt.cmdheight = 1 -- remove gap for cmd line (cmdheight=0 is considered experimental)
vim.opt.cursorline = true
vim.opt.cursorlineopt = "both"
vim.opt.cursorcolumn = false
vim.opt.termguicolors = true
vim.opt.updatetime = 500
vim.opt.autoread = true
-- vim.opt.winborder = "rounded"

-- Adding 'alpha' to this list allows you to treat chars as integers so that
-- you can increment decrement them with ctrl-a/ctrl-x
vim.opt.nrformats = vim.opt.nrformats._value .. ",octal,alpha"

-- set options for textwidth, wrap, and backspace based on file type
-- note: backspace can only be set globally
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	pattern = { "*" },
	callback = function()
		local file_ext = vim.fn.expand("%:t"):match(".+%.(%w+)$")
		if file_ext == "txt" or file_ext == "md" then
			vim.opt_local.textwidth = 80
			vim.opt_local.wrap = true
			-- enable backspace functionality like you would expect in a normal text document
			vim.opt.backspace = { "indent", "eol", "start" }
		else
			vim.opt.backspace = { "indent", "start" } -- enable backspace but no backspace into the above line
		end
	end,
})
