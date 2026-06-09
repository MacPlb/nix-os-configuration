local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Indentation
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

-- No swap/backup — use persistent undo instead
opt.swapfile = false
opt.backup = false
opt.undodir = vim.fn.stdpath("data") .. "/undo"
opt.undofile = true

-- Search
opt.hlsearch = false
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- Appearance
opt.termguicolors = true
opt.signcolumn = "yes"
opt.colorcolumn = "80"
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Performance
opt.updatetime = 250
opt.timeoutlen = 300
opt.lazyredraw = false           -- keep UI responsive
opt.synmaxcol = 300              -- stop syntax highlighting on very long lines

-- Splits
opt.splitbelow = true
opt.splitright = true

-- Clipboard (system)
opt.clipboard = "unnamedplus"

-- Completion
opt.completeopt = { "menuone", "noselect" }

-- Disable netrw (oil.nvim replaces it)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Big file guard — disable slow features for huge files
vim.api.nvim_create_autocmd("BufReadPre", {
    callback = function(args)
        local max_size = 1.5 * 1024 * 1024 -- 1.5 MB
        local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(args.buf))
        if ok and stats and stats.size > max_size then
            vim.b[args.buf].large_buf = true
            vim.opt_local.syntax = "off"
            vim.opt_local.foldmethod = "manual"
            vim.opt_local.spell = false
            vim.opt_local.undofile = false
            vim.cmd("syntax clear")
        end
    end,
})
