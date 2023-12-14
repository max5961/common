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
            local file_ext = vim.fn.expand("%:e");
            local cmd = ""

            -- js/ts
            if file_ext == "js" or file_ext == "ts" then
                cmd = "node " .. file_path

            -- cpp
            elseif file_ext == "cpp" then
                local cwd = vim.fn.getcwd()
                local file_dir = vim.fn.expand("%:p:h")
                local file_name = vim.fn.expand("%:t")
                cmd = 
                    "g++ -o " .. file_dir .. "/compiled_" .. file_name .. " " .. file_dir .. "/" .. file_name ..
                    " && " .. file_dir .. "/compiled_" .. file_name
            else
                print("Cannot run run_script function on invalid file type: " .. file_ext)
                return
            end

            require("toggleterm").exec(cmd)
        end

        vim.api.nvim_set_keymap("n", "<leader>r", "<cmd>lua run_script()<CR>", {noremap = true, silent = true})

    end
}


















