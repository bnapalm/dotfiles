local opts = { noremap = true, silent = true }

-- Shorten function name
local keymap = vim.keymap.set

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<A-l>", ":bnext<CR>", opts)
keymap("n", "<A-h>", ":bprevious<CR>", opts)

-- Move text up and down
keymap("n", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
keymap("n", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)

-- Insert --
-- Press jk fast to enter
-- keymap("i", "jk", "<ESC>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

keymap("n", "<leader>f", "<cmd>Telescope find_files<cr>", opts)
keymap("n", "<leader>t", "<cmd>Telescope live_grep<cr>", opts)
keymap("n", "<leader>b", "<cmd>Telescope buffers<cr>", opts)
keymap("n", "<leader>p", "<cmd>Telescope projects<cr>", opts)

-- Edit file under cursor
keymap("n", "gf", ":edit <cfile><CR>", opts)

keymap("n", "<leader>hh", ":set hlsearch!<CR>", opts)
keymap("n", "<leader>hl", ":set cursorline!<CR>", opts)
keymap("n", "<leader>hi", "<cmd>IndentBlanklineToggle<CR>", opts)

keymap("n", "<leader>x", "<cmd>Bdelete<CR>", opts)
keymap("n", "<leader>q", "<cmd>close<CR>", opts)
keymap("n", '\\', ":Neotree toggle reveal<CR>", opts)

-- Keep cursor in middle when jumping half page
keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")

-- keymap("n", "<leader>b", ":buffers<CR>:buffer<Space>", {noremap = true} )

-- Resize gui font
keymap({'n', 'i'}, "<C-+>", function() ResizeGuiFont(1)  end, opts)
keymap({'n', 'i'}, "<C-->", function() ResizeGuiFont(-1) end, opts)
keymap({'n', 'i'}, "<C-BS>", function() ResetGuiFont() end, opts)
