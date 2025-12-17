-- [GLOBAL KEYBINDS]

-- Disable arrow keys in normal mode.
vim.keymap.set("n", "<Left>", '<Cmd>echo "Use h to move!"<CR>')
vim.keymap.set("n", "<Right>", '<Cmd>echo "Use l to move!"<CR>')
vim.keymap.set("n", "<Up>", '<Cmd>echo "Use k to move!"<CR>')
vim.keymap.set("n", "<Down>", '<Cmd>echo "Use j to move!"<CR>')

vim.keymap.set("n", "<Esc>", "<Cmd>nohlsearch<CR>")
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>")

-- [PLUGIN-SPECIFIC KEYBINDS]

-- Open the parent directory.
vim.keymap.set("n", "-", "<Cmd>Oil<CR>")

-- Format the current buffer.
vim.keymap.set("", "<leader>f", function()
    require("conform").format({ async = true }, function(err)
        if not err then
            local mode = vim.api.nvim_get_mode().mode

            if vim.startswith(string.lower(mode), "v") then
                vim.api.nvim_feedkeys(
                    vim.api.nvim_replace_termcodes("<Esc>", true, false, true),
                    "n",
                    true)
            end
        end
    end)
end)

-- Cycle through all TODOs in the current buffer.
vim.keymap.set("n", "[t", function() require("todo-comments").jump_prev() end)
vim.keymap.set("n", "]t", function() require("todo-comments").jump_next() end)

local telescope = require("telescope.builtin")

vim.keymap.set("n", "<leader>sd", telescope.diagnostics)
vim.keymap.set("n", "<leader>sf", telescope.find_files)
vim.keymap.set("n", "<leader>sg", telescope.live_grep)
vim.keymap.set("n", "<leader>sh", telescope.help_tags)
vim.keymap.set("n", "<leader>ss", telescope.builtin)
vim.keymap.set("n", "<leader>sw", telescope.grep_string)
vim.keymap.set("n", "<leader>s.", telescope.oldfiles)
vim.keymap.set("n", "<leader><leader>", telescope.buffers)

-- Fuzzy find in the current buffer with a floating window.
vim.keymap.set("n", "<leader>/", function()
    telescope.current_buffer_fuzzy_find(
        require("telescope.themes").get_dropdown {
            winblend = 10,
            previewer = false,
        }
    )
end)

vim.keymap.set("n", "<leader>s/", function()
    telescope.live_grep {
        grep_open_files = true,
        prompt_title = "Live Grep in Open Files",
    }
end)

-- Search Neovim's config directory.
vim.keymap.set("n", "<leader>sn", function()
    telescope.find_files { cwd = vim.fn.stdpath "config" }
end)
