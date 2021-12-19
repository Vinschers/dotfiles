vim.cmd [[
try
  set background=dark
  "colorscheme zephyr
  "colorscheme PaperColor
  colorscheme edge
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  set background=dark
endtry
]]
