local map = vim.keymap.set

map("n", "<Left>", '<Cmd>echo "Use h to move!"<CR><CR>')
map("n", "<Right>", '<Cmd>echo "Use l to move!"<CR><CR>')
map("n", "<Up>", '<Cmd>echo "Use k to move!"<CR><CR>')
map("n", "<Down>", '<Cmd>echo "Use j to move!"<CR><CR>')

map("n", "<Esc>", "<Cmd>nohlsearch<CR>", { desc = "Clear Highlights" })

map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit Terminal Mode" })

map("n", "<C-h>", "<C-w><C-h>", { desc = "Move Focus to the Left Window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move Focus to the Right Window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move Focus to the Lower Window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move Focus to the Upper Window" })

map("n", "<C-S-h>", "<C-w>H", { desc = "Move Window to the Left" })
map("n", "<C-S-l>", "<C-w>L", { desc = "Move Window to the Right" })
map("n", "<C-S-j>", "<C-w>J", { desc = "Move Window to the Lower" })
map("n", "<C-S-k>", "<C-w>K", { desc = "Move Window to the Upper" })
