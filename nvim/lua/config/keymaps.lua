vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- LSP
vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<CR>", { noremap = true, silent = true })
vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>",
    { noremap = true, silent = true })
vim.keymap.set("n", "<F4", "<cmd>lua vim.lsp.buf.code_action()<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "J", "<cmd>lua vim.diagnostic.open_float()<CR>", { noremap = true, silent = true })

-- UndoTree
vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<CR>", { noremap = true, silent = true })

-- TodoComments
vim.keymap.set("n", "<leader>d", "<cmd>TodoTelescope<CR>", { noremap = true, silent = true })

-- Movimentando entre janelas
vim.keymap.set("n", "<leader>h", "<C-w>h", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>j", "<C-w>j", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>k", "<C-w>k", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>l", "<C-w>l", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>q", "<C-w>c", { noremap = true, silent = true })

-- Harpoon
vim.keymap.set("n", "<leader>a", function()
    require("harpoon.mark").add_file()
end, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>e", function()
    require("harpoon.ui").toggle_quick_menu()
end, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>1", function()
    require("harpoon.ui").nav_file(1)
end, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>2", function()
    require("harpoon.ui").nav_file(2)
end, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>3", function()
    require("harpoon.ui").nav_file(3)
end, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>4", function()
    require("harpoon.ui").nav_file(4)
end, { noremap = true, silent = true })

-- Telescope
vim.keymap.set("n", "<leader>f", function()
    require("telescope.builtin").find_files()
end, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>s", function()
    require("telescope.builtin").live_grep()
end, { noremap = true, silent = true })

-- Oil
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Neogit
vim.keymap.set("n", "<leader>g", "<cmd>Neogit<CR>", { noremap = true, silent = true })
