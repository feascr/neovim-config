vim.g.have_nerd_font = true

vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.relativenumber = true

vim.schedule(function()
    vim.opt.clipboard = "unnamedplus"
end)

-- Enable break indent
-- vim.opt.smartindent = true
-- vim.opt.autoindent = true
vim.opt.breakindent = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 100

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10
vim.opt.signcolumn = "yes"

-- remove wrapping
vim.opt.wrap = true

-- create and use cache for undos
vim.opt.undodir = os.getenv("HOME") .. "/.nvim/undodir"
vim.opt.undofile = true

-- add true colors options
vim.opt.termguicolors = true

-- color 80th coluumn
vim.opt.colorcolumn = "80"

vim.g.netrw_banner = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
