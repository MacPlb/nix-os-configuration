-- Our colors (lua/config/colors.lua) and the harpoon tabline instead of bufferline.

-- Harpoon's files, numbered, along the top; the open one is highlighted.
function _G.HarpoonTabline()
  local ok, list = pcall(function() return require("harpoon"):list() end)
  if not ok then return "%#TabLineFill#" end
  local current = vim.api.nvim_buf_get_name(0)
  local parts = {}
  for i = 1, list:length() do
    local item = list:get(i)
    if item and item.value and item.value ~= "" then
      local name = vim.fn.fnamemodify(item.value, ":t"):gsub("%%", "%%%%")
      local active = vim.fn.fnamemodify(item.value, ":p") == current
      table.insert(parts, (active and "%#TabLineSel#" or "%#TabLine#") .. " " .. i .. " " .. name .. " ")
    end
  end
  if #parts == 0 then return "%#TabLineFill# 󰛢 no hooked files (<Space>H adds one)" end
  return "%#TabLineFill# 󰛢 " .. table.concat(parts, "%#TabLineFill# ") .. "%#TabLineFill#"
end

return {
  { "LazyVim/LazyVim", opts = { colorscheme = function() require("config.colors").load() end } },
  { "nvim-mini/mini.base16", lazy = true },
  { "folke/tokyonight.nvim", enabled = false },
  { "catppuccin/nvim", enabled = false },
  { "akinsho/bufferline.nvim", enabled = false },

  -- The `:` command line at the bottom, as in stock nvim, instead of noice's floating command
  -- palette that LazyVim puts near the top of the screen.
  {
    "folke/noice.nvim",
    opts = {
      cmdline = { view = "cmdline" },
      presets = { command_palette = false },
    },
  },

  {
    "ThePrimeagen/harpoon",
    lazy = false, -- the tabline reads its list from the start
    init = function()
      vim.o.showtabline = 2
      vim.o.tabline = "%!v:lua.HarpoonTabline()"
    end,
    config = function(_, opts)
      vim.fn.mkdir(vim.fn.stdpath("data"), "p") -- harpoon can't save before it exists
      local harpoon = require("harpoon")
      harpoon:setup(opts)
      local redraw = function() vim.cmd.redrawtabline() end
      harpoon:extend({ ADD = redraw, REMOVE = redraw, LIST_CHANGE = redraw })
    end,
  },
}
