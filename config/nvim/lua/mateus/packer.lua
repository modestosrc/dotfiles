vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)

    use {'folke/lsp-colors.nvim'}

    use {'nvim-tree/nvim-web-devicons'}

    use {'lukas-reineke/indent-blankline.nvim'}

    use {'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }}

    use {'wbthomason/packer.nvim'}

    use {'nvim-telescope/telescope.nvim', tag = '0.1.1',
        requires = { {'nvim-lua/plenary.nvim'}}}

    use {'maxmx03/dracula.nvim'}

    use {'olimorris/onedarkpro.nvim'}

    use {'catppuccin/nvim', as = 'catppuccin' }

    use {'marko-cerovac/material.nvim'}

    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}

    use {'theprimeagen/harpoon'}

    use {'mbbill/undotree'}

    use {'williamboman/mason.nvim',
    run = ":MasonUpdate"}

    use {'folke/trouble.nvim',
    requires = {{'nvim-tree/nvim-web-devicons'}}}

    use { 'tpope/vim-fugitive'}

    use {"folke/todo-comments.nvim",
    requires = {{ "nvim-lua/plenary.nvim" }},
    opts = {}}

    use {'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    requires = {
        {'neovim/nvim-lspconfig'},
        {'williamboman/mason.nvim',
        run = function()
            pcall(vim.cmd, 'MasonUpdate')
        end,
        },
        {'williamboman/mason-lspconfig.nvim'},
        {'hrsh7th/nvim-cmp'},
        {'hrsh7th/cmp-nvim-lsp'},
        {'L3MON4D3/LuaSnip'}}}

end)
