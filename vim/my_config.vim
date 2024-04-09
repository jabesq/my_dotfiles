autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
nnoremap <silent> <F8> :TlistToggle<CR>

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
"set showcmd        " Show (partial) command in status line.
"set ignorecase     " Do case insensitive matching
"set smartcase      " Do smart case matching
"set incsearch      " Incremental search
set number
"set autowrite      " Automatically save before commands like :next and :make
set hidden          " Hide buffers when they are abandoned
set mouse=nv        " Enable mouse usage (all modes)
set statusline=%<%f%=%([%{Tlist_Get_Tagname_By_Line()}]%)
set title titlestring=%<%f\ %([%{Tlist_Get_Tagname_By_Line()}]%)
set cmdheight=1     " 2 doesn't seem to avoid 'press <Enter> to continue'
set shortmess=atI
set shm=at          " Short messages. Again, trying to avoid 'press <Enter>'
set laststatus=2    " Always show status line
set ruler           " Show column and line number in status line
set showmode        " Show insert, visual, or replace mode in cmd area
set scrolloff=4     " Scroll to show 4 lines above or below cursor
set sidescrolloff=5 " Always keep 5 lines after or before when side scrolling
set noerrorbells    " Don't beep at me
set visualbell      " Don't beep on error
set autoread
set cc=120

set shiftwidth=4    " Number of spaces for autoindent

" Search stuff:
set ignorecase      " Ignore case during search
set smartcase       " Be case sensitive if mixed-case search term
set incsearch
set matchtime=3     " ... during this time
set wildmenu
set ttyfast
set smartindent
set cursorline
set virtualedit=onemore

let Tlist_Process_File_Always = 1
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ "Unknown"   : "?"
    \ }

" Show long lines and trailing spaces
" CTRL-K -> for →
" CTRL-K .M for ·
" CTRL-K .3 for ⋯
" CTRL-K Tr for ▷
" CTRL-K >1 ›
" (use :dig for a list of diagraphs)
set list listchars=tab:››,extends:→,trail:·

" Indent guides
" https://github.com/nathanaelkane/vim-indent-guides
" Toggle with <Leader>ig
let g:indent_guides_auto_colors = 0
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=Grey25 ctermbg=3
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=Grey25 ctermbg=4
au VimEnter * IndentGuidesToggle


" MiniVim Good shortcut
let UseCustomKeyBindings = 1

""" Custom backup and swap files
let myVimDir = expand("$HOME/.vim")
let myBackupDir = myVimDir . '/backup'
let mySwapDir = myVimDir . '/swap'
function! EnsureDirExists (dir)
  if !isdirectory(a:dir)
    call mkdir(a:dir,'p')
  endif
endfunction
call EnsureDirExists(myVimDir)
call EnsureDirExists(myBackupDir)
call EnsureDirExists(mySwapDir)
set backup
set backupskip="/tmp/*"
set backupext=.bak
let &directory = mySwapDir
let &backupdir = myBackupDir
set writebackup


""" Key mappings

if UseCustomKeyBindings

" Helper functions
function! CreateShortcut(keys, cmd, where, ...)
  let keys = "<" . a:keys . ">"
  if a:where =~ "i"
    let i = (index(a:000,"noTrailingIInInsert") > -1) ? "" : "i"
    let e = (index(a:000,"noLeadingEscInInsert") > -1) ? "" : "<esc>"
    execute "imap " . keys . " " . e .  a:cmd . i
  endif
  if a:where =~ "n"
    execute "nmap " . keys . " " . a:cmd
  endif
  if a:where =~ "v"
    let k = (index(a:000,"restoreSelectionAfter") > -1) ? "gv" : ""
    let c = a:cmd
    if index(a:000,"cmdInVisual") > -1
      let c = ":<C-u>" . strpart(a:cmd,1)
    endif
    execute "vmap " . keys . " " . c . k
  endif
endfunction
function! TabIsEmpty()
    return winnr('$') == 1 && len(expand('%')) == 0 && line2byte(line('$') + 1) <= 2
endfunction
function! MyQuit()
  if TabIsEmpty() == 1
    q!
  else
    if &modified
      if (confirm("YOU HAVE UNSAVED CHANGES! Wanna quit anyway?", "&Yes\n&No", 2)==1)
        q!
      endif
    else
      q
    endif
  endif
endfunction
function! OpenLastBufferInNewTab()
    redir => ls_output
    silent exec 'ls'
    redir END
    let ListBuffers = reverse(split(ls_output, "\n"))
    for line in ListBuffers
      let title = split(line, "\"")[1]
      if title !~  "\[No Name"
        execute "tabnew +" . split(line, " ")[0] . "buf"
        break
      endif
    endfor
endfunction
function! ToggleColorColumn()
    if &colorcolumn != 0
        windo let &colorcolumn = 0
    else
        windo let &colorcolumn = 80
    endif
endfunction
function! MyPasteToggle()
  set invpaste
  echo "Paste" (&paste) ? "On" : "Off"
endfunction
function! MenuNetrw()
  let c = input("What to you want to do? (M)ake a dir, Make a (F)ile, (R)ename, (D)elete : ")
  if (c == "m" || c == "M")
    normal d
  elseif (c == "f" || c == "F")
    normal %
  elseif (c == "r" || c == "R")
    normal R
  elseif (c == "d" || c == "D")
    normal D
  endif
endfunction

" Ctrl S - Save
call CreateShortcut("C-s", ":w<enter>", "nv", "cmdInVisual", "restoreSelectionAfter")
call CreateShortcut("C-s", ":w<enter>i<right>", "i", "notrailingiininsert")

" Ctrl Down - Pagedown
call CreateShortcut("C-Down", "20j", "inv")

" Ctrl Up - Pageup
call CreateShortcut("C-Up", "20k", "inv")

" Ctrl Right - Next Word
call CreateShortcut("C-Right", "w", "nv")

" Ctrl Left - Previous Word
call CreateShortcut("C-Left", "b", "nv")

" Tab - Indent
call CreateShortcut("Tab", ">>", "n")
call CreateShortcut("Tab", ">", "v", "restoreSelectionAfter")

" Shift Tab - UnIndent
call CreateShortcut("S-Tab", "<<", "in")
call CreateShortcut("S-Tab", "<", "v", "restoreSelectionAfter")

" Ctrl Z - Undo
call CreateShortcut("C-z", "u", "in")

" Ctrl R - Redo
call CreateShortcut("C-r", "<C-r>", "in")

" Alt Right - Next tab
call CreateShortcut("A-Right", "gt", "inv")

" Alt Left - Previous tab
call CreateShortcut("A-Left", "gT", "inv")

" F2 - Paste toggle
call CreateShortcut("f2",":call MyPasteToggle()<Enter>", "n")

" F3 - Line numbers toggle
call CreateShortcut("f3",":set nonumber!<Enter>", "in")

" F4 - Panic Button
call CreateShortcut("f4","mzggg?G`z", "inv")

" F6 - Toggle color column at 80th char
call CreateShortcut("f6",":call ToggleColorColumn()<Enter>", "inv")


endif " End custom key bindings


