-- see all key mappings
-- :map, :nmap, :vmap, :imap, :cmap (all, n, v, i, cmd)

-- move between window splits
vim.keymap.set("n", "<A-w>", "<C-w>w") -- quickly cycle windows
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")

-- move blocks of text in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- fast scroll: move X amount of lines up or down with capital J or K
local function fast_scroll(lines, down_mapping, up_mapping)
    vim.keymap.set(
        "n",
        down_mapping,
        function() vim.cmd("normal!" .. lines .. "j") end,
        { noremap = true, silent = true }
    )
    vim.keymap.set(
        "n",
        up_mapping,
        function() vim.cmd("normal!" .. lines .. "k") end,
        { noremap = true, silent = true }
    )
end
-- overwrite the default J/K keymaps which append lines of text to the next line
-- the default maps conflict with the visual J/K key maps as well
fast_scroll(5, "J", "K")
fast_scroll(20, "<A-j>", "<A-k>")

-- keep search terms in the middle
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- place cursor over a word and replace very instance of that word in the file
vim.keymap.set("n", "<leader>ca", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
