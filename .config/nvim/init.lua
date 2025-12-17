vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = true

require("modules.lazy")

require("modules.autos")
require("modules.keys")
require("modules.settings")

vim.cmd([[colorscheme gruvbox]])
