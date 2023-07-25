local opts = { noremap = true, silent = true }

-- Shorten function name
local keymap = function(mode, lhs, rhs)
  vim.keymap.set(mode, lhs, rhs, opts)
end

--Remap space as leader key
keymap("", "<Space>", "<Nop>")
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

keymap('n', '<leader>cl', '<cmd>Lazy<cr>')

-- Normal --
-- Better window navigation
keymap("n", "<A-m>", "<C-w>h")
keymap("n", "<A-w>", "<C-w>j")
keymap("n", "<A-v>", "<C-w>k")
keymap("n", "<A-z>", "<C-w>l")

-- Navigate buffers
keymap("n", "<A-l>", ":bnext<CR>")
keymap("n", "<A-h>", ":bprevious<CR>")

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv")
keymap("v", ">", ">gv")

-- Visual --
-- Move text up and down
keymap("v", "J", ":move '>+1<CR>gv=gv")
keymap("v", "K", ":move '<-2<CR>gv=gv")
--
-- Edit file under cursor
keymap("n", "gf", ":edit <cfile><CR>")

-- show/hide highlights
keymap("n", "<leader>hh", ":set hlsearch!<CR>")
keymap("n", "<leader>hl", ":set cursorline!<CR>")

-- close window
keymap("n", "<leader>q", "<cmd>close<CR>")

-- keep buffer content when pasting
keymap("v", "p", '"_dP')

-- Keep cursor in place when joining lines
keymap("n", "J", "mzJ`z")

-- Keep cursor in middle when jumping half page
keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")

-- System clipboard
keymap({ 'n', 'v' }, '<leader>y', '\"+y')
keymap('n', '<leader>Y', '\"+Y')
keymap({ 'n', 'v' }, '<leader>d', '\"+d')
keymap({ 'n', 'v' }, '<leader>p', '\"+p')
keymap({ 'n', 'v' }, '<leader>P', '\"+P')

-- Diagnostics

keymap('n', 'gl', vim.diagnostic.open_float)        -- Show diagnostics in a floating window
keymap('n', '[d', vim.diagnostic.goto_prev)         -- Move to the previous diagnostic
keymap('n', ']d', vim.diagnostic.goto_next)         -- Move to the next diagnostic
keymap('n', '<leader>ll', vim.diagnostic.setloclist) -- TODO check other options
