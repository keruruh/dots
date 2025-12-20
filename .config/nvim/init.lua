vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = true

require("modules.lazy")
require("modules.settings")
require("modules.welcome")

vim.cmd([[colorscheme gruvbox]])
