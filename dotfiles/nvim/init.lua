vim.g.mapleader = " "
vim.gmaplocalleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{
		import = "plugins",
	},
})

require("remap")
require("set")
require("lsp-setup")
require("colorscheme")

-- The same as requiring all the files in lua/custom directory
vim.cmd("runtime! lua/custom/*.lua")
