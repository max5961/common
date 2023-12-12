-- https://github.com/akinsho/toggleterm.nvim

return {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function()
        local builtin = require("toggleterm").setup{
            shade_terminals = false,
            size = 10,
            
            -- toggle terminal in normal mode
            open_mapping = [[<C-\>]],
            -- insert_mappings set to true allows toggling the terminal in insert mode
            insert_mappings = true
        }

        -- set keymappings
        function _G.set_terminal_keymaps()
            local opts = {buffer = 0}
            vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
            vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
            vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
            vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
            vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
            vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
        end

        -- remove *toggleterm# to have keybindings apply to all terminals
        vim.cmd('autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()')

        -- run scripts with <leader>r
        function run_script()
            local file_path = vim.api.nvim_buf_get_name(0)

            local file_ext = vim.bo.filetype

            local cmd = ""

            if file_ext == "javascript" or file_ext == "typescript" then
                cmd = "node " .. file_path
            else
                print("Cannot run run_script function on invalid file type")
                return
            end

            require("toggleterm").exec(cmd)
        end

        vim.api.nvim_set_keymap("n", "<leader>r", "<cmd>lua run_script()<CR>", {noremap = true, silent = true})

    end
}


















