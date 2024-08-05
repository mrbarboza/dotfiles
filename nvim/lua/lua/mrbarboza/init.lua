require("mrbarboza.set")
require("mrbarboza.remap")
require("mrbarboza.lazy")

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

vim.opt.listchars = { eol = "↵", tab = "→  ", trail = "·", extends = "$" }
vim.opt.list = true
