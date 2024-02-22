-- https://github.com/nvim-neo-tree/neo-tree.nvim
-- ? in NeoTree buffer for list of mappings

-- disable netrw on open
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
        "3rd/image.nvim",              -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    config = function()
        vim.keymap.set("n", "<A-f>", ":Neotree toggle<CR>")

        require("neo-tree").setup({
            filesystem = {
                filtered_items = {
                    hide_dotfiles = false,
                    hide_gitignored = false,
                }
            },
            event_handlers = {
                symlink_target = {
                    enabled = false
                }
            },
            window = {
                mappings = {
                    ["s"] = { "open_rightbelow_vs" },
                }
            }
        })
    end
}
