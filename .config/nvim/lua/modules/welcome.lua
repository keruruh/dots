-- This simple Lua script has been adapted from:
-- https://github.com/SRCthird/minintro.nvim/
--
-- The code has been rewritten from scratch to include:
--  * Cleaner variable names.
--  * Simpler buffer creation and rendering functions.
--  * Make it so all the text is centered inside the welcome message.
--  * Allow disabling the welcome message entirely.

-- [CONFIG BEGIN]

-- Set to false to disable the welcome message.
local ENABLE_WELCOME = true

local WELCOME_MESSAGE = {
    "  .oooooo.      .oooooo.   oooooo   oooo oooooo     oooo ooooo ooo        ooooo ",
    " d8P'  `Y8b    d8P'  `Y8b   `888.   .8'   `888.     .8'  `888' `88.       .888' ",
    "888           888      888   `888. .8'     `888.   .8'    888   888b     d'888  ",
    "888           888      888    `888.8'       `888. .8'     888   8 Y88. .P  888  ",
    "888     ooooo 888      888     `888'         `888.8'      888   8  `888'   888  ",
    "`88.    .88'  `88b    d88'      888           `888'       888   8    Y     888  ",
    " `Y8bood8P'    `Y8bood8P'      o888o           `8'       o888o o8o        o888o ",
}

local WELCOME_COLOR = "#98c379"
local BUFFER_NAME = "WELCOME"

-- [CONFIG END]

local CONTENT = ENABLE_WELCOME and WELCOME_MESSAGE or {}
local CONTENT_HEIGHT = #CONTENT
local CONTENT_WIDTH = 0

for _, line in ipairs(CONTENT) do
    CONTENT_WIDTH = math.max(CONTENT_WIDTH, vim.fn.strdisplaywidth(line))
end

local AUTOCMD_GROUP = vim.api.nvim_create_augroup(BUFFER_NAME, {})
local NAMESPACE = vim.api.nvim_create_namespace(BUFFER_NAME)

local global_buffer = -1

local function set_buffer_options(buffer)
    vim.api.nvim_set_option_value("modifiable", false, { buf = buffer })
    vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buffer })
    vim.api.nvim_set_option_value("buftype", "nofile", { buf = buffer })
    vim.api.nvim_set_option_value("swapfile", false, { buf = buffer })
    vim.api.nvim_set_option_value("filetype", BUFFER_NAME, { buf = buffer })

    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.list = false
    vim.opt_local.fillchars = { eob = " " }
    vim.opt_local.colorcolumn = "0"
end

local function render_buffer()
    local window = vim.fn.bufwinid(global_buffer)

    if window == -1 then
        return
    end

    local win_width = vim.api.nvim_win_get_width(window)
    local win_height = vim.api.nvim_win_get_height(window) - vim.opt.cmdheight:get()

    local start_row = math.floor((win_height - CONTENT_HEIGHT) / 2)

    if start_row < 0 then
        start_row = 0
    end

    local lines = {}

    for _ = 1, start_row do
        lines[#lines + 1] = ""
    end

    for _, line in ipairs(CONTENT) do
        local line_width = vim.fn.strdisplaywidth(line)
        local start_col = math.floor((win_width - line_width) / 2)

        if start_col < 0 then
            start_col = 0
        end

        lines[#lines + 1] = string.rep(" ", start_col) .. line
    end

    vim.api.nvim_set_option_value("modifiable", true, { buf = global_buffer })
    vim.api.nvim_buf_set_lines(global_buffer, 0, -1, false, lines)
    vim.api.nvim_set_option_value("modifiable", false, { buf = global_buffer })

    vim.api.nvim_buf_clear_namespace(global_buffer, NAMESPACE, 0, -1)

    if CONTENT_HEIGHT > 0 then
        local first_line_col = math.floor((win_width - CONTENT_WIDTH) / 2)

        if first_line_col < 0 then
            first_line_col = 0
        end

        vim.api.nvim_buf_set_extmark(global_buffer, NAMESPACE, start_row, first_line_col, {
            end_row = start_row + CONTENT_HEIGHT,
            hl_group = "IntroLogo"
        })
    end
end

local function create_global_buffer()
    local current_buffer = vim.api.nvim_get_current_buf()
    local current_buffer_name = vim.api.nvim_buf_get_name(current_buffer)
    local current_buffer_filetype = vim.api.nvim_get_option_value("filetype", {
        buf = current_buffer
    })

    if current_buffer_name ~= "" and current_buffer_filetype ~= BUFFER_NAME then
        return
    end

    global_buffer = vim.api.nvim_create_buf(false, true)

    vim.api.nvim_buf_set_name(global_buffer, BUFFER_NAME)
    vim.api.nvim_set_current_buf(global_buffer)
    vim.api.nvim_buf_delete(current_buffer, { force = true })

    set_buffer_options(global_buffer)
    render_buffer()

    vim.api.nvim_create_autocmd({ "WinResized", "VimResized" }, {
        group = AUTOCMD_GROUP,
        buffer = global_buffer,
        callback = render_buffer
    })
end

vim.api.nvim_set_hl(NAMESPACE, "IntroLogo", { fg = WELCOME_COLOR })
vim.api.nvim_set_hl_ns(NAMESPACE)

vim.api.nvim_create_autocmd("VimEnter", {
    group = AUTOCMD_GROUP,
    callback = create_global_buffer,
    once = true
})
