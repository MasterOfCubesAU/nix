-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Indenting
vim.opt.tabstop = 4
vim.opt.softtabstop = -1
vim.opt.shiftwidth = 0
vim.opt.expandtab = true

-- Indent where possible
vim.opt.autoindent = true

-- Split default to right and down rather than left and up
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Disable line wrapping
vim.opt.wrap = false

vim.opt.spelllang = "en_au"

-- Auto-resize splits when the window is resized
vim.api.nvim_create_autocmd('VimResized', {
  command = 'wincmd =',
})

-- Use system clipboard
vim.opt.clipboard = "unnamedplus"

-- Fix cursor to center of screen
vim.opt.scrolloff = 999

vim.opt.virtualedit = "block"

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Show replacements (such as :%s/) in a preview
vim.opt.inccommand = "split"

-- Ignore casing in VIM commands (incl. autocomplete)
vim.opt.ignorecase = true

-- Allow full range of colours in terminal
vim.opt.termguicolors = true

-- Signs
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "",
    },
  },
})

-- Remve default status line
vim.opt.showmode = false

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Searching
-- vim.opt.hlsearch = false
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
