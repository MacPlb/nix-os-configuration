-- Colors generated from modules/theme/colors.nix (~/.config/nvim/lua/theme.lua) and a transparent
-- editor. Kitty only makes its default background see-through, not colors nvim paints, so these
-- groups drop their background. Popups (pickers, completion, hover) stay solid over code.
local M = {}

local transparent_groups = {
  "Normal", "NormalNC", "EndOfBuffer", "MsgArea", "WinSeparator", "TabLineFill", "StatusLineNC",
  "SignColumn", "FoldColumn", "LineNr", "LineNrAbove", "LineNrBelow",
  "GitSignsAdd", "GitSignsChange", "GitSignsDelete",
}
local solid = {} -- the theme's backgrounds, to switch back to

function M.apply_transparency()
  for _, group in ipairs(transparent_groups) do
    local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
    if solid[group] == nil then solid[group] = hl.bg or false end
    if vim.g.transparent == false then hl.bg = solid[group] or nil else hl.bg = nil end
    vim.api.nvim_set_hl(0, group, hl)
  end
end

-- LazyVim's colorscheme.
function M.load()
  local theme = require("theme")
  require("mini.base16").setup({ palette = theme.base16 })
  vim.g.colors_name = "theme"
  vim.api.nvim_set_hl(0, "Cursor", theme.cursor)
  vim.api.nvim_set_hl(0, "Visual", theme.visual)
  solid = {}
  M.apply_transparency()
end

return M
