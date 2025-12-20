local key = vim.keymap.set

key("n", "<Left>", '<Cmd>echo "Use h to move!"<CR>')
key("n", "<Right>", '<Cmd>echo "Use l to move!"<CR>')
key("n", "<Up>", '<Cmd>echo "Use k to move!"<CR>')
key("n", "<Down>", '<Cmd>echo "Use j to move!"<CR>')

key("n", "<Esc>", "<Cmd>nohlsearch<CR>", { desc = "Clear Highlights" })

key("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit Terminal Mode" })

key("n", "<C-h>", "<C-w><C-h>", { desc = "Move Focus to the Left Window" })
key("n", "<C-l>", "<C-w><C-l>", { desc = "Move Focus to the Right Window" })
key("n", "<C-j>", "<C-w><C-j>", { desc = "Move Focus to the Lower Window" })
key("n", "<C-k>", "<C-w><C-k>", { desc = "Move Focus to the Upper Window" })

key("n", "<C-S-h>", "<C-w>H", { desc = "Move Window to the Left" })
key("n", "<C-S-l>", "<C-w>L", { desc = "Move Window to the Right" })
key("n", "<C-S-j>", "<C-w>J", { desc = "Move Window to the Lower" })
key("n", "<C-S-k>", "<C-w>K", { desc = "Move Window to the Upper" })
