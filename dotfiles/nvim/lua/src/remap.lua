-- move between window splits
-- <A-w> to quickly cycle between windows
vim.keymap.set("n", "<A-w>", "<C-w>w")
vim.keymap.set("n", "<leader>h", "<C-w>h")
vim.keymap.set("n", "<leader>l", "<C-w>l")
vim.keymap.set("n", "<leader>j", "<C-w>j")
vim.keymap.set("n", "<leader>k", "<C-w>k")

-- move blocks of text in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- fast scroll: move X amount of lines up or down with capital J or K
function fast_scroll(lines, down_mapping, up_mapping)
    vim.keymap.set("n", down_mapping, function() vim.cmd("normal!" .. lines .. "j") end, { noremap = true, silent = true })
    vim.keymap.set("n", up_mapping, function() vim.cmd("normal!" .. lines .. "k") end, { noremap = true, silent = true })
end

fast_scroll(5, "J", "K")
fast_scroll(20, "<C-j>", "<C-k>")


