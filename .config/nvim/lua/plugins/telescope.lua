return {
    "nvim-telescope/telescope.nvim",

    dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-telescope/telescope-ui-select.nvim" },
        { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
    },

    config = function()
        local telescope = require("telescope")
        local t_themes = require("telescope.themes")
        local t_builtin = require("telescope.builtin")

        telescope.setup({
            extensions = {
                ["ui-select"] = {
                    t_themes.get_dropdown(),
                },
            },
        })

        -- Enable Telescope extensions if they are installed.
        pcall(telescope.load_extension, "fzf")
        pcall(telescope.load_extension, "ui-select")

        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = buffer

            vim.keymap.set(mode, l, r, opts)
        end

        map("n", "<leader>sh", t_builtin.help_tags, { desc = "Search Help" })
        map("n", "<leader>sk", t_builtin.keymaps, { desc = "Search Keymaps" })
        map("n", "<leader>sf", t_builtin.find_files, { desc = "Search Files" })
        map("n", "<leader>ss", t_builtin.builtin, { desc = "Search Builtin" })
        map("n", "<leader>sw", t_builtin.grep_string, { desc = "Search String" })
        map("n", "<leader>sg", t_builtin.live_grep, { desc = "Search Grep" })
        map("n", "<leader>sd", t_builtin.diagnostics, { desc = "Search Diagnostics" })
        map("n", "<leader>sr", t_builtin.resume, { desc = "Resume Search" })
        map("n", "<leader>s.", t_builtin.oldfiles, { desc = "Search Recent" })
        map("n", "<leader><leader>", t_builtin.buffers, { desc = "Search Buffers" })

        map("n", "<leader>/", function()
            t_builtin.current_buffer_fuzzy_find(t_themes.get_dropdown({
                winblend = 10,
                previewer = false,
            }))
        end, { desc = "Search in Current Buffer" })

        map("n", "<leader>s/", function()
            t_builtin.live_grep({
                grep_open_files = true,
                prompt_title = "Live Grep in Open Files",
            })
        end, { desc = "Search in Open Files" })

        map("n", "<leader>sn", function()
            t_builtin.find_files({
                cwd = vim.fn.stdpath("config"),
            })
        end, { desc = "Search Neovim Config Files" })
    end,
}
