return {
    "folke/todo-comments.nvim",

    dependencies = { "nvim-lua/plenary.nvim" },

    config = function()
        local todo = require("todo-comments")

        -- Call the setup function explicitly since we are defining the keybinds here
        -- and we are not using "opts = {}".
        todo.setup({})

        vim.keymap.set("n", "]t", todo.jump_next, { desc = "Next TODO Comment" })
        vim.keymap.set("n", "[t", todo.jump_prev, { desc = "Previous TODO Comment" })
    end,
}
