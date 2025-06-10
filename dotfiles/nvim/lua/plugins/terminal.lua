-- https://github.com/akinsho/toggleterm.nvim

return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require("toggleterm").setup({
			shade_terminals = false,
			size = 10,

			-- toggle terminal in normal mode
			open_mapping = [[<C-\>]],
			-- insert_mappings set to true allows toggling the terminal in insert mode
			insert_mappings = true,
		})

		-- set keymappings
		function _G.set_terminal_keymaps()
			local opts = { buffer = 0 }
			vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
			local modes = { "t", "n" }
			for i, mode in ipairs(modes) do
				vim.keymap.set(mode, "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
				vim.keymap.set(mode, "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
				vim.keymap.set(mode, "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
				vim.keymap.set(mode, "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
				vim.keymap.set(mode, "<C-w>", [[<C-\><C-n><C-w>]], opts)
			end
		end

		vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

		-- Map T<number> to ToggleTerm<number> which creates/kills terminals
		for num = 1, 5, 1 do
			vim.api.nvim_create_user_command("T" .. num, "ToggleTerm" .. num, {})
		end

		local Run_Commands = {}
		local Last_Cmd = nil
		local Terminal_Number = "1"

		-- Set a cached command to run the current file and execute it
		function Run_File(opts)
			local file_path = vim.api.nvim_buf_get_name(0)
			local dir = vim.fs.dirname(file_path)

			if Run_Commands[file_path] == nil or opts.set then
				local cmd = vim.fn.input("Set a run command: ")
				cmd = cmd:gsub("$file", file_path):gsub("$dir", dir)
				Run_Commands[file_path] = cmd
			end

			require("toggleterm").exec(Run_Commands[file_path])
		end

		-- Read input and run it in the term.  Optional @param input for reusing
		-- this function from other functions
		function Run_Input(input)
			local prompt = "Enter terminal command: "
			local cmd = input or vim.fn.input(prompt)

			if cmd ~= "!" then
				Last_Cmd = cmd
			end

			-- enter ! to change terminal that commands are sent to
			if cmd == "!" then
				Terminal_Number = vim.fn.input("Enter target terminal #: ")
				cmd = vim.fn.input(prompt)
			end

			local nvim_command = Terminal_Number .. "TermExec cmd=" .. "'" .. cmd .. "'"
			vim.cmd(nvim_command)
		end

		-- Run last cmd sent from Run_Input <leader>lc
		function Run_Last_Cmd()
			if Last_Cmd == nil then
				Last_Cmd = vim.fn.input("No previous command: ")
			else
				print("Executing Last Command: " .. Last_Cmd)
			end

			Run_Input(Last_Cmd)
		end

		vim.keymap.set("n", "<leader>r", "<cmd>lua Run_File({set = nil})<CR>", { noremap = true, silent = true })
		vim.keymap.set("n", "<leader>R", "<cmd>lua Run_File({set = true})<CR>", { noremap = true, silent = true })
		vim.keymap.set("n", "<leader>t", "<cmd>lua Run_Input()<CR>", { noremap = true, silent = true })
		vim.keymap.set("n", "<leader>lc", "<cmd>lua Run_Last_Cmd()<CR>", { noremap = true, silent = true })
	end,
}
