vim.g.mapleader = " "

-- Bootstrap Packer (déjà dans ton fichier)
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

-- Plugins avec Packer
require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use { 'nvim-telescope/telescope.nvim', requires = { {'nvim-lua/plenary.nvim'} } }
  use 'lewis6991/gitsigns.nvim'
  use 'neovim/nvim-lspconfig' -- LSP
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp' 
  if packer_bootstrap then
    require('packer').sync()
  end
end)

-- Configuration générale
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.termguicolors = true

-- Configuration Telescope
local telescope = require("telescope")
telescope.setup({
  defaults = {
    mappings = {
      i = {
        ["<C-j>"] = "move_selection_next",
        ["<C-k>"] = "move_selection_previous",
      },
    },
  },
})

-- Configuration LSP
local lspconfig = require('lspconfig')
lspconfig.clangd.setup {
  cmd = { "clangd", "--background-index" }, -- Indexation en arrière-plan
  filetypes = { "c", "cpp", "objc", "objcpp" }, -- Types de fichiers supportés
  root_dir = lspconfig.util.root_pattern("compile_commands.json", ".git"), -- Détecte le dossier racine
  capabilities = {
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = true -- Support des snippets (optionnel)
        }
      }
    }
  }
}

-- Raccourcis clavier
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Telescope
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", opts)
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", opts)
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", opts)
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", opts)

-- Navigation projet
map("n", "<leader>pv", "<cmd>Ex<CR>", opts)
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Sélection
vim.api.nvim_set_keymap('n', '<C-a>', 'ggVG', { noremap = true, silent = true })

-- Shell
map("n", "<leader>sh", "<cmd>terminal<CR>", opts)
map("t", "<Esc>", "<C-\\><C-n>", opts)

-- Raccourcis LSP
map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)        -- Aller à la définition
map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)       -- Lister les références
map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)             -- Afficher la doc (hover)
map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)   -- Renommer
map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts) -- Actions de code
map("n", "<leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts) -- Afficher les diagnostics
