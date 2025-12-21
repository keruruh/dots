return {
    cmd = { "nu", "--lsp" },
    filetypes = { "nu" },

    root_dir = function(buffer, on_dir)
        on_dir(
            vim.fs.root(buffer, { ".git" })
                or vim.fs.dirname(vim.api.nvim_buf_get_name(buffer))
        )
    end,
}
