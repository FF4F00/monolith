" ~/.config/nvim/colors/pm.vim

scriptencoding utf-8

set background=light
hi clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name="pm"

" Highlighting Function
fun! <sid>hi(group, fg, bg, attr)
  if !empty(a:fg)
    exec "hi " . a:group . " guifg=" . a:fg.gui . " ctermfg=" .  a:fg.cterm256
  endif
  if !empty(a:bg)
    exec "hi " . a:group . " guibg=" . a:bg.gui . " ctermbg=" .  a:bg.cterm256
  endif
  if a:attr != ""
    exec "hi " . a:group . " gui=" . a:attr . " cterm=" . a:attr
  endif
endfun

let s:clr = {'gui': 'NONE',    'cterm256': 'NONE'}
let s:blk = {'gui': '#484848', 'cterm256': '235' }
let s:gry = {'gui': '#C6C6C6', 'cterm256': '235' }
let s:wht = {'gui': '#EFECE9', 'cterm256': '255' }


let s:red = {'gui': '#DC2103', 'cterm256': '196' }
let s:org = {'gui': '#FF4F00', 'cterm256': '202' }
let s:ylw = {'gui': '#FBC124', 'cterm256': '220' }
let s:grn = {'gui': '#008F11', 'cterm256': '28'  }
let s:grn = {'gui': '#CEFF00', 'cterm256': '154' }
let s:blu = {'gui': '#007BFF', 'cterm256': '33'  }
let s:cyn = {'gui': '#00FF8B', 'cterm256': '48'  }

" Def       | GROUP        | FOREGROUND | BACKGROUND   | ATTRIBUTE |
call <sid>hi('ColorColumn',  s:blk,       s:clr,        'none')
call <sid>hi('Cursor',       s:blk,       s:clr,        'none')
call <sid>hi('CursorColumn', s:blk,       s:clr,        'none')
call <sid>hi('CursorLine',   s:clr,       s:clr,        'none')
call <sid>hi('CursorLineNr', s:blk,       s:clr,        'none')
call <sid>hi('Directory',    s:blk,       s:clr,        'none')
call <sid>hi('FoldColumn',   s:blk,       s:clr,        'none')
call <sid>hi('Folded',       s:blk,       s:clr,        'none')
call <sid>hi('IncSearch',    s:blk,       s:clr,        'none')
call <sid>hi('LineNr',       s:blk,       s:clr,        'none')
call <sid>hi('MatchParen',   s:blk,       s:clr,        'none')
call <sid>hi('Normal',       s:blk,       s:clr,        'none')
call <sid>hi('Pmenu',        s:blk,       s:clr,        'none')
call <sid>hi('PmenuSel',     s:blk,       s:clr,        'none')
call <sid>hi('Search',       s:blk,       s:clr,        'none')
call <sid>hi('SignColumn',   s:blk,       s:clr,        'none')
call <sid>hi('StatusLine',   s:blk,       s:clr,        'none')
call <sid>hi('StatusLineNC', s:blk,       s:clr,        'none')
call <sid>hi('VertSplit',    s:blk,       s:clr,        'none')
call <sid>hi('Visual',       s:blk,       s:clr,        'none')


" Winbar transparency
call <sid>hi('WinBar',       s:blk,       s:clr,        'none')
call <sid>hi('WinBarNC',     s:blk,       s:clr,        'none')




" General   | GROUP        | FOREGROUND | BACKGROUND   | ATTRIBUTE |
call <sid>hi('Boolean',      s:blk,       s:clr,        'none')
call <sid>hi('Character',    s:blk,       s:clr,        'none')
call <sid>hi('Comment',      s:blk,       s:clr,        'none')
call <sid>hi('Conditional',  s:blk,       s:clr,        'none')
call <sid>hi('Constant',     s:blk,       s:clr,        'none')
call <sid>hi('Define',       s:blk,       s:clr,        'none')
call <sid>hi('DiffAdd',      s:blk,       s:clr,        'none')
call <sid>hi('DiffChange',   s:blk,       s:clr,        'none')
call <sid>hi('DiffDelete',   s:blk,       s:clr,        'none')
call <sid>hi('DiffText',     s:blk,       s:clr,        'none')
call <sid>hi('ErrorMsg',     s:blk,       s:clr,        'none')
call <sid>hi('Float',        s:blk,       s:clr,        'none')
call <sid>hi('Function',     s:blk,       s:clr,        'none')
call <sid>hi('Identifier',   s:blk,       s:clr,        'none')
call <sid>hi('Keyword',      s:blk,       s:clr,        'none')
call <sid>hi('Label',        s:blk,       s:clr,        'none')
call <sid>hi('NonText',      s:blk,       s:clr,        'none')
call <sid>hi('Number',       s:blk,       s:clr,        'none')
call <sid>hi('Operator',     s:blk,       s:clr,        'none')
call <sid>hi('PreProc',      s:blk,       s:clr,        'none')
call <sid>hi('Special',      s:blk,       s:clr,        'none')
call <sid>hi('SpecialKey',   s:blk,       s:clr,        'none')
call <sid>hi('SpellBad',     s:blk,       s:clr,        'italic,undercurl')
call <sid>hi('SpellCap',     s:blk,       s:clr,        'italic,undercurl')
call <sid>hi('SpellLocal',   s:blk,       s:clr,        'undercurl')
call <sid>hi('Statement',    s:blk,       s:clr,        'none')
call <sid>hi('StorageClass', s:blk,       s:clr,        'none')
call <sid>hi('String',       s:blk,       s:clr,        'none')
call <sid>hi('Tag',          s:blk,       s:clr,        'none')
call <sid>hi('Title',        s:blk,       s:clr,        'bold')
call <sid>hi('Todo',         s:blk,       s:clr,        'inverse,bold')
call <sid>hi('Type',         s:blk,       s:clr,        'none')
call <sid>hi('Underlined',   s:blk,       s:clr,        'underline')
call <sid>hi('WarningMsg',   s:blk,       s:clr,        'none')


hi WinBar guibg=NONE
hi WinBarNC guibg=NONE

