-- ~/.config/nvim/lua/config/options.lua

-----------------------------------------------------------------------
-- Basic options
-----------------------------------------------------------------------
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 30

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 2

vim.o.mouse = "a"

-----------------------------------------------------------------------
-- Folding & gutter UI: clean, clickable, and not ugly 🙂
-----------------------------------------------------------------------

-- Use Treesitter folding (you probably already have this above, keep it once)
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- No built-in fold column: we will draw icons ourselves in statuscolumn
vim.opt.foldcolumn = "0"

-- Stable sign column (for git/LSP signs)
vim.opt.signcolumn = "yes"

-- No dotted filler inside folds, no ~ at end of buffer
vim.opt.fillchars = vim.tbl_extend("force", vim.opt.fillchars:get(), {
  fold      = " ",
  foldopen  = " ",
  foldclose = " ",
  foldsep   = " ",
  eob       = " ",
})

-- Make sure mouse clicks in the gutter work
vim.o.mouse = "a"

-----------------------------------------------------------------------
-- Click handler: toggle fold for the line we clicked
-----------------------------------------------------------------------
function _G.FoldClick(minwid, clicks, button, mods)
  local mouse = vim.fn.getmousepos()
  if mouse.winid == 0 then
    return
  end
  vim.api.nvim_set_current_win(mouse.winid)
  vim.api.nvim_win_set_cursor(mouse.winid, { mouse.line, 0 })
  vim.cmd("normal! za")
end

-----------------------------------------------------------------------
-- Helper: decide which icon (if any) to show on this line
--   ▶  = closed fold start
--   ▼  = open fold start
--   " " = not a fold start
-----------------------------------------------------------------------
local function fold_icon_for_line(lnum)
  local closed_start = vim.fn.foldclosed(lnum)
  if closed_start == lnum then
    -- Top line of a CLOSED fold
    return "▶"
  end

  local level = vim.fn.foldlevel(lnum)
  if level > 0 then
    -- For OPEN folds, only show icon on the first line of the fold
    local prev_level = vim.fn.foldlevel(lnum - 1)
    if prev_level < level then
      return "▼"
    end
  end

  return " "
end

-----------------------------------------------------------------------
-- Statuscolumn: [signs][numbers][clickable ▶/▼]
-----------------------------------------------------------------------
function _G.FoldStatuscolumn()
  local lnum = vim.v.lnum

  -- 1) Signs (gitsigns, diagnostics, etc.)
  local signs = "%s"

  -- 2) Line / relative number (behaves like :set number relativenumber)
  local nu, rnu = vim.wo.number, vim.wo.relativenumber
  local cur = vim.fn.line(".")
  local num_txt = ""

  if nu or rnu then
    if rnu and lnum ~= cur then
      num_txt = tostring(math.abs(lnum - cur))
    else
      num_txt = tostring(lnum)
    end
  end

  local width = vim.wo.numberwidth
  num_txt = string.format("%" .. width .. "s", num_txt) .. " "

  -- 3) Fold icon (only on actual fold starts)
  local icon = fold_icon_for_line(lnum)
  local clickable_icon = "%@v:lua.FoldClick@" .. icon .. "%T "

  return signs .. num_txt .. clickable_icon
end

vim.o.statuscolumn = "%!v:lua.FoldStatuscolumn()"

-----------------------------------------------------------------------
-- Fold text & highlights: bold light-grey, no background, no dots
-----------------------------------------------------------------------
function _G.custom_fold_text()
  local raw = vim.fn.getline(vim.v.foldstart)

  -- Extract the indentation ONLY (spaces/tabs at the start of the line)
  local indent = raw:match("^%s*") or ""

  -- Extract the actual JSON/YAML/HCL content of the line
  local content = raw:match("^%s*(.*)") or raw

  local count = vim.v.foldend - vim.v.foldstart + 1

  -- No extra indentation padding — keep it tight
  return string.format("%s%s…(%d lines)", indent, content, count)
end

vim.opt.foldtext = "v:lua.custom_fold_text()"

-- Reapply our highlight tweaks whenever the colorscheme changes
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("MyFoldHighlights", { clear = true }),
  callback = function()
    -- Make sign & fold columns use the normal background (no grey strip)
    vim.api.nvim_set_hl(0, "SignColumn", { link = "Normal" })
    vim.api.nvim_set_hl(0, "FoldColumn", { link = "Normal" })

    -- Folded line: bold, comment-ish FG, transparent BG
    local ok, comment = pcall(vim.api.nvim_get_hl, 0, { name = "Comment", link = false })
    local fg = ok and comment.fg or nil
    vim.api.nvim_set_hl(0, "Folded", { fg = fg, bold = true, bg = "NONE" })
  end,
})

-- Apply once for the current colorscheme on startup
vim.cmd("doautocmd ColorScheme")
