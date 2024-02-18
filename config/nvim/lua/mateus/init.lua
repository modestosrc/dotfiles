require("mateus.set")
require("mateus.remap")
require("mateus.packer")
require("mateus.colorscheme")

vim.cmd.colorscheme "base16-gruvbox-dark-medium"
vim.cmd('set guifont=FiraCode:h12')
vim.opt.guicursor = {
    'n-v:hor20',
    'i-ci:ver25',
    'r-cr:hor20',
    'o:hor50'
}
