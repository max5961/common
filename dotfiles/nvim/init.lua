vim.g.mapleader = " "
vim.gmaplocalleader = " "

require("config.lazy")
require("remap")
require("set")
require("colorscheme")

-- The same as requiring all the files in lua/custom directory
vim.cmd("runtime! lua/custom/*.lua")
