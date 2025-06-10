-- show key mappings (:map shows all, :nmap shows normal mode, :vmap visual mode....)
-- :map :nmap :vmap :imap, :cmap

-- Override tmux prefix key
vim.keymap.set("n", "<F1>", "<Nop>", { noremap = true, silent = true })
vim.keymap.set("v", "<F1>", "<Nop>", { noremap = true, silent = true })
vim.keymap.set("i", "<F1>", "<Nop>", { noremap = true, silent = true })

-- move between window splits
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")

-- move blocks of text in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- keep search terms in the middle
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- place cursor over a word and replace very instance of that word in the file
vim.keymap.set("n", "<leader>ca", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- keep visual selection when moving selections right/left
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- same as default J keymap, but keep cursor in same position
vim.keymap.set("n", "J", "mzJ`z")

-- easier mark navigation
vim.keymap.set("n", ";", "`")

-- resize split windows with arrow keys
-- increase/decrease height
vim.keymap.set("n", "<C-Up>", function()
	vim.cmd("resize +1")
end)
vim.keymap.set("n", "<C-Down>", function()
	vim.cmd("resize -1")
end)
-- increase decrease width
vim.keymap.set("n", "<C-Right>", function()
	vim.cmd("vertical resize +1")
end)
vim.keymap.set("n", "<C-Left>", function()
	vim.cmd("vertical resize -1")
end)

-- Add border to hover lsp-info, which used to be the default
-- global winborder opt is too broad (distracting when applied to scrollbars)
-- vim.keymap.set("n", "K", function()
-- 	vim.lsp.buf.hover({ border = "rounded" })
-- end)
