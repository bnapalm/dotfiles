local options = {
  hidden         = true,
  fileencoding   = "utf-8",
  mouse          = "a",

  timeoutlen     = 500,
  updatetime     = 100,

  number         = true, -- set numbered lines
  relativenumber = true, -- set relative numbered lines
  numberwidth    = 2,    -- set number column width to 2 {default 4}
  cmdheight      = 2,    -- cmi line size

  splitbelow     = true, -- force all horizontal splits to go below current window
  splitright     = true, -- force all vertical splits to go to the right of current window

  expandtab      = true, -- convert tabs to spaces
  shiftwidth     = 2,    -- the number of spaces inserted for each indentation
  tabstop        = 2,    -- insert 2 spaces for a tab
  softtabstop    = 2,    -- insert 2 spaces for a tab

  smartindent    = true,

  swapfile       = false,
  backup         = false,
  undodir        = os.getenv("XDG_DATA_HOME") .. "/vim_undo_dir",
  undofile       = true,

  hlsearch       = true,
  incsearch      = true,
  ignorecase     = true, -- ignore case in search patterns
  cursorline     = true, -- highlight the current line

  termguicolors  = true,

  scrolloff      = 8,
  sidescrolloff  = 8,
  signcolumn     = "yes",
  wrap           = true,

  list           = true,
  listchars      = { tab = '  ', trail = '·', extends = '⇨', precedes = '⇦' },

  foldmethod     = "expr", -- Enable treesitter based folding
  foldexpr       = "nvim_treesitter#foldexpr()",
  foldlevel      = 5,
  conceallevel   = 2,

  laststatus     = 3,
}

vim.opt.iskeyword = vim.opt.iskeyword + "-"

for k, v in pairs(options) do
  vim.opt[k] = v
end
