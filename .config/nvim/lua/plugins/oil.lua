return {
    "stevearc/oil.nvim",

    config = function()
        local oil = require("oil")

        oil.setup({
            keymaps = {
                ["~"] = "<Cmd>edit $HOME<CR>",
                ["<Leader>ff"] = {
                    mode = "n",
                    desc = "Find files in the current directory",
                    nowait = true,

                    function()
                        require("telescope.builtin").find_files({
                            cwd = oil.get_current_dir()
                        })
                    end,
                },
            },

            view_options = {
                show_hidden = true,
            },
        })

        vim.keymap.set("n", "-", oil.open)
    end,
}
