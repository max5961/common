-- https://github.com/akinsho/toggleterm.nvim

return {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function()
        require("toggleterm").setup {
            shade_terminals = false,
            size = 10,

            -- toggle terminal in normal mode
            open_mapping = [[<C-\>]],
            -- insert_mappings set to true allows toggling the terminal in insert mode
            insert_mappings = true,
        }

        -- set keymappings
        function _G.set_terminal_keymaps()
            local opts = { buffer = 0 }
            vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
            local modes = { "t", "n" }
            for i, mode in ipairs(modes) do
                vim.keymap.set(mode, '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
                vim.keymap.set(mode, '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
                vim.keymap.set(mode, '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
                vim.keymap.set(mode, '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
                vim.keymap.set(mode, '<C-w>', [[<C-\><C-n><C-w>]], opts)
            end
        end

        vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

        -- run scripts with <leader>r
        function Run_script()
            local file_path = vim.api.nvim_buf_get_name(0)
            local file_ext = vim.fn.expand("%:e");
            local cmd = ""

            -- js
            if file_ext == "js" then
                cmd = "node " .. file_path

                -- ts
            elseif file_ext == "ts" then
                local stripped_file_name = string.sub(file_path, 1, string.len(file_path) - 2)
                local js_file_name = stripped_file_name .. "js"
                cmd = "tsc " .. file_path .. " && node " .. js_file_name

                -- cpp
            elseif file_ext == "cpp" or file_ext == "c" then
                local file_dir = vim.fn.expand("%:p:h")
                local file_name = vim.fn.expand("%:t")
                local stripped_file_name = vim.fn.expand("%:t:r")

                local compiler = "";
                if file_ext == "cpp" then
                    compiler = "g++"
                else
                    compiler = "gcc"
                end

                cmd =
                    compiler ..
                    " -o " .. file_dir .. "/" .. stripped_file_name .. ".o " .. file_dir .. "/" .. file_name ..
                    " && " .. file_dir .. "/" .. stripped_file_name .. ".o"

                -- bash
            elseif file_ext == "sh" then
                cmd = "chmod +x " .. file_path .. " && " .. file_path

                -- python
            elseif file_ext == "py" then
                cmd = "python " .. file_path

                -- invalid file_ext/non-file buffer
            else
                if file_ext == nil or file_ext == "" then
                    file_ext = "current buffer is not a file"
                end

                print("Cannot run 'run_script' function on invalid file type: " .. file_ext)
                return
            end

            require("toggleterm").exec(cmd)
        end

        -- map command to Run_script
        vim.api.nvim_set_keymap("n", "<leader>r", "<cmd>lua Run_script()<CR>", { noremap = true, silent = true })

        -- send commands to the terminal with <leader>t
        Terminal_number = "1"
        function Send_command_to_terminal()
            local prompt = "Enter terminal command: "
            local terminal_cmd = vim.fn.input(prompt)

            -- enter ! to change terminal that commands are sent to
            if terminal_cmd == "!" then
                Terminal_number = vim.fn.input("Enter target terminal #: ")
                terminal_cmd = vim.fn.input(prompt)
            end

            local nvim_command = Terminal_number .. "TermExec cmd=" .. "'" .. terminal_cmd .. "'"
            vim.cmd(nvim_command)
        end

        vim.api.nvim_set_keymap("n", "<leader>t", "<cmd>lua Send_command_to_terminal()<CR>",
            { noremap = true, silent = true })

        -- to create a new terminal ToggleTerm<number>
        -- map T<number> to ToggleTerm<number>
        -- create/kill terminals with T<number>
        for num = 1, 5, 1 do
            vim.api.nvim_create_user_command("T" .. num, "ToggleTerm" .. num, {})
        end

        -- run lint
        function Run_lint()
            local file_path = vim.api.nvim_buf_get_name(0)
            local file_ext = vim.fn.expand("%:e");
            local cmd = ""

            if file_ext == "js" or file_ext == "ts" then
                cmd = "npx eslint " .. file_path
            end

            -- send lint command to ToggleTerm
            require("toggleterm").exec(cmd)
        end

        -- run function with :Run lint
        vim.api.nvim_create_user_command("RunLint", "lua Run_lint()<CR>", {})
    end
}
