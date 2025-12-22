return {
    "stevearc/conform.nvim",

    event = { "BufWritePre" },
    cmd = { "ConformInfo" },

    keys = {
        {
            "<leader>f",

            mode = "",
            desc = "Format Current Buffer",

            function()
                require("conform").format({
                    async = true,
                    lsp_format = "fallback",
                })
            end,
        },
    },

    opts = {
        format_on_save = function(buffer)
            local disable_filetypes = {}

            if disable_filetypes[vim.bo[buffer].filetype] then
                return nil
            else
                return {
                    timeout_ms = 500,
                    lsp_format = "fallback",
                }
            end
        end,

        formatters_by_ft = {
            c = { "clang-format" },
            lua = { "stylua" },
            python = {
                "ruff_fix",
                "ruff_format",
                "ruff_organize_imports",
            },
        },

        notify_no_formatters = false,
    },
}
