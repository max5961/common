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
-- vim.opt.splitright = true -- split vertical window to the right
-- vim.opt.splitbelow = true -- split horizontal window to the bottom

-- search
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- formatting
vim.opt.wrap = false       -- disable linewrap
vim.opt.colorcolumn = "80" -- text can extend past but add margin column as a guide
vim.opt.textwidth = 0      -- disable max width of text being inserted

-- other
vim.opt.scrolloff = 12                    -- keeps at least x lines padding when scrolling up/down
vim.opt.clipboard = "unnamedplus"         -- enable pasting yanked text outside of neovim
vim.opt.backspace = { "indent", "start" } -- enable backspace but no backspace into the above line
vim.opt.guicursor = ""                    -- rectangle cursor
vim.opt.mouse = ""                        -- disable mouse click
vim.opt.cmdheight = 0                     -- remove gap for cmd line (cmdheight=0 is considered experimental)
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.updatetime = 500
vim.opt.autoread = true
