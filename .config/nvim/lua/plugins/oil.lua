return {
    "stevearc/oil.nvim",

    dependencies = {
        { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_icons },
    },

    opts = {
        delete_to_trash = true,
        skip_confirm_for_simple_edits = true,
        watch_for_changes = true,

        view_options = {
            natural_order = true,
            show_hidden = true,
        },
    },
}
