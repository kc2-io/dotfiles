-- =============================================================================
-- init.lua — Neovim configuration
-- =============================================================================

-- Leader key (set before lazy plugins)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- =============================================================================
-- Options
-- =============================================================================
local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- UI
opt.cursorline = true
opt.scrolloff = 8
opt.signcolumn = "yes"
opt.termguicolors = true
opt.showmode = false

-- Splits
opt.splitbelow = true
opt.splitright = true

-- Performance
opt.updatetime = 250
opt.timeoutlen = 300

-- Files
opt.swapfile = false
opt.backup = false
opt.undofile = true

-- Clipboard (use system clipboard)
opt.clipboard = "unnamedplus"

-- =============================================================================
-- Keymaps
-- =============================================================================
local keymap = vim.keymap.set

-- Clear search highlighting
keymap("n", "<Esc>", ":nohlsearch<CR>", { silent = true })

-- Quick save / quit
keymap("n", "<leader>w", ":w<CR>", { silent = true, desc = "Save file" })
keymap("n", "<leader>q", ":q<CR>", { silent = true, desc = "Quit" })

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Move lines up/down in visual mode
keymap("v", "J", ":m '>+1<CR>gv=gv", { silent = true })
keymap("v", "K", ":m '<-2<CR>gv=gv", { silent = true })

-- =============================================================================
-- Plugin manager (lazy.nvim) — uncomment to enable
-- =============================================================================
-- local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- if not vim.loop.fs_stat(lazypath) then
--     vim.fn.system({
--         "git", "clone", "--filter=blob:none",
--         "https://github.com/folke/lazy.nvim.git",
--         "--branch=stable", lazypath,
--     })
-- end
-- vim.opt.rtp:prepend(lazypath)
-- require("lazy").setup({
--     -- Add plugins here
-- })
