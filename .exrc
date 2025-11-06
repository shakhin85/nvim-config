let s:cpo_save=&cpo
set cpo&vim
inoremap <silent> <C-Bslash> <Cmd>ToggleTerm
cnoremap <silent> <Plug>(TelescopeFuzzyCommandSearch) e "lua require('telescope.builtin').command_history { default_text = [=[" . escape(getcmdline(), '"') . "]=] }"
inoremap <C-W> u
inoremap <C-U> u
nnoremap <silent>  :TmuxNavigateLeft
nnoremap 	 :BufferLineCycleNext
nnoremap <silent> <NL> :TmuxNavigateDown
nnoremap <silent>  :TmuxNavigateUp
nnoremap <silent>  :TmuxNavigateRight
nnoremap <silent>  <Nop>
nmap  d
tnoremap <silent>  
nnoremap <silent>  <Cmd>execute v:count . "ToggleTerm"
nnoremap  tp :TermExec cmd='python %' dir=getcwd()
nnoremap  t3 :3ToggleTerm
nnoremap  t2 :2ToggleTerm
nnoremap  t1 :1ToggleTerm
nnoremap  tv :ToggleTerm direction=vertical size=80
nnoremap  th :ToggleTerm direction=horizontal
nnoremap  tf :ToggleTerm direction=float
nnoremap  tt :ToggleTerm
nnoremap  ll :LazyGitFilterCurrentFile
nnoremap  lf :LazyGitFilter
nnoremap  lc :LazyGitCurrentFile
nnoremap  ah <Cmd>checkhealth sidekick
nnoremap  ws <Cmd>SessionSave
nnoremap  wr <Cmd>SessionRestore
xmap <nowait>  mn <Plug>(VM-Find-Subword-Under)
nmap <nowait>  mn <Plug>(VM-Find-Under)
nnoremap  z[ <Cmd>Telekasten toggle_todo
nnoremap  zi <Cmd>Telekasten paste_img_and_link
nnoremap  zm <Cmd>Telekasten preview_img
nnoremap  zr <Cmd>Telekasten rename_note
nnoremap  zp <Cmd>Telekasten panel
nnoremap  zl <Cmd>Telekasten insert_link
nnoremap  zW <Cmd>Telekasten find_weekly_notes
nnoremap  zw <Cmd>Telekasten goto_thisweek
nnoremap  zT <Cmd>Telekasten goto_thisweek
nnoremap  z# <Cmd>Telekasten show_tags
nnoremap  zt <Cmd>Telekasten show_tags
nnoremap  zI <Cmd>Telekasten insert_img_link
nnoremap  zb <Cmd>Telekasten show_backlinks
nnoremap  zc <Cmd>Telekasten show_calendar
nnoremap  zn <Cmd>Telekasten new_note
nnoremap  zz <Cmd>Telekasten follow_link
nnoremap  zd <Cmd>Telekasten goto_today
nnoremap  zg <Cmd>Telekasten search_notes
nnoremap  zf <Cmd>Telekasten find_notes
nnoremap  gs :LazyGit
nnoremap  xl <Cmd>Trouble loclist toggle
nnoremap  xq <Cmd>Trouble quickfix toggle
nnoremap  xd <Cmd>Trouble diagnostics toggle filter.buf=0
nnoremap  xw <Cmd>Trouble diagnostics toggle
nnoremap  xt <Cmd>Trouble todo toggle
nnoremap  ft <Cmd>TodoTelescope
nnoremap  fk <Cmd>Telescope keymaps
nnoremap  fc <Cmd>Telescope grep_string
nnoremap  fg <Cmd>Telescope live_grep
nnoremap  fr <Cmd>Telescope oldfiles
nnoremap  ff <Cmd>Telescope find_files
nnoremap  gB <Cmd>BlameToggle window
nnoremap  gb <Cmd>BlameToggle
nnoremap  lg :LazyGit
nnoremap  tcc :TermExec cmd='clear'
nnoremap  bs :ls
nnoremap  ba :bufdo bd
nnoremap  tF <Cmd>tabnew %
nnoremap  tP <Cmd>tabp
nnoremap  tn <Cmd>tabn
nnoremap  tx <Cmd>tabclose
nnoremap  to <Cmd>tabnew
nnoremap  sx <Cmd>close
nnoremap  se =
nnoremap  sh s
nnoremap  sv v
nnoremap  + 
nnoremap  nhl :nohl
xnoremap ! <Cmd>lua require('various-textobjs').diagnostic()
onoremap ! <Cmd>lua require('various-textobjs').diagnostic()
omap <silent> % <Plug>(MatchitOperationForward)
xmap <silent> % <Plug>(MatchitVisualForward)
nmap <silent> % <Plug>(MatchitNormalForward)
nnoremap & :&&
xnoremap . <Cmd>lua require('various-textobjs').emoji()
onoremap . <Cmd>lua require('various-textobjs').emoji()
xnoremap <silent> <expr> @ mode() ==# 'V' ? ':normal! @'.getcharstr().'' : '@'
xnoremap C <Cmd>lua require('various-textobjs').toNextClosingBracket()
onoremap C <Cmd>lua require('various-textobjs').toNextClosingBracket()
nnoremap <silent> H <Cmd>lua MiniMove.move_line('left')
xnoremap <silent> H <Cmd>lua MiniMove.move_selection('left')
nnoremap <silent> J <Cmd>lua MiniMove.move_line('down')
xnoremap <silent> J <Cmd>lua MiniMove.move_selection('down')
nnoremap <silent> K <Cmd>lua MiniMove.move_line('up')
xnoremap <silent> K <Cmd>lua MiniMove.move_selection('up')
nnoremap <silent> L <Cmd>lua MiniMove.move_line('right')
xnoremap <silent> L <Cmd>lua MiniMove.move_selection('right')
onoremap L <Cmd>lua require('various-textobjs').url()
onoremap Q <Cmd>lua require('various-textobjs').toNextQuotationMark()
xnoremap Q <Cmd>lua require('various-textobjs').toNextQuotationMark()
nnoremap Y y$
omap <silent> [% <Plug>(MatchitOperationMultiBackward)
xmap <silent> [% <Plug>(MatchitVisualMultiBackward)
nmap <silent> [% <Plug>(MatchitNormalMultiBackward)
xmap <nowait> \\c <Plug>(VM-Visual-Cursors)
nmap <nowait> \\gS <Plug>(VM-Reselect-Last)
nmap <nowait> \\/ <Plug>(VM-Start-Regex-Search)
nmap <nowait> \\\ <Plug>(VM-Add-Cursor-At-Pos)
xmap <nowait> \\a <Plug>(VM-Visual-Add)
xmap <nowait> \\f <Plug>(VM-Visual-Find)
xmap <nowait> \\/ <Plug>(VM-Visual-Regex)
xmap <nowait> \\A <Plug>(VM-Visual-All)
nmap <nowait> \\A <Plug>(VM-Select-All)
omap <silent> ]% <Plug>(MatchitOperationMultiForward)
xmap <silent> ]% <Plug>(MatchitVisualMultiForward)
nmap <silent> ]% <Plug>(MatchitNormalMultiForward)
xnoremap aI <Cmd>lua require('various-textobjs').indentation('outer', 'outer')
onoremap aI <Cmd>lua require('various-textobjs').indentation('outer', 'outer')
xnoremap ai <Cmd>lua require('various-textobjs').indentation('outer', 'inner')
onoremap ai <Cmd>lua require('various-textobjs').indentation('outer', 'inner')
xnoremap aq <Cmd>lua require('various-textobjs').anyQuote('outer')
onoremap aq <Cmd>lua require('various-textobjs').anyQuote('outer')
xnoremap ag <Cmd>lua require('various-textobjs').greedyOuterIndentation('outer')
onoremap ag <Cmd>lua require('various-textobjs').greedyOuterIndentation('outer')
xnoremap a_ <Cmd>lua require('various-textobjs').lineCharacterwise('outer')
onoremap a_ <Cmd>lua require('various-textobjs').lineCharacterwise('outer')
xnoremap am <Cmd>lua require('various-textobjs').chainMember('outer')
onoremap am <Cmd>lua require('various-textobjs').chainMember('outer')
xnoremap az <Cmd>lua require('various-textobjs').closedFold('outer')
onoremap az <Cmd>lua require('various-textobjs').closedFold('outer')
xnoremap aN <Cmd>lua require('various-textobjs').notebookCell('outer')
onoremap aN <Cmd>lua require('various-textobjs').notebookCell('outer')
xnoremap aF <Cmd>lua require('various-textobjs').filepath('outer')
onoremap aF <Cmd>lua require('various-textobjs').filepath('outer')
xnoremap aS <Cmd>lua require('various-textobjs').subword('outer')
onoremap aS <Cmd>lua require('various-textobjs').subword('outer')
xnoremap a# <Cmd>lua require('various-textobjs').color('outer')
onoremap a# <Cmd>lua require('various-textobjs').color('outer')
xnoremap av <Cmd>lua require('various-textobjs').value('outer')
onoremap av <Cmd>lua require('various-textobjs').value('outer')
xnoremap a, <Cmd>lua require('various-textobjs').argument('outer')
onoremap a, <Cmd>lua require('various-textobjs').argument('outer')
xnoremap ak <Cmd>lua require('various-textobjs').key('outer')
onoremap ak <Cmd>lua require('various-textobjs').key('outer')
xnoremap aD <Cmd>lua require('various-textobjs').doubleSquareBrackets('outer')
onoremap aD <Cmd>lua require('various-textobjs').doubleSquareBrackets('outer')
xnoremap ao <Cmd>lua require('various-textobjs').anyBracket('outer')
onoremap ao <Cmd>lua require('various-textobjs').anyBracket('outer')
xmap a% <Plug>(MatchitVisualTextObject)
xnoremap g; <Cmd>lua require('various-textobjs').lastChange()
onoremap g; <Cmd>lua require('various-textobjs').lastChange()
xnoremap gG <Cmd>lua require('various-textobjs').entireBuffer()
onoremap gG <Cmd>lua require('various-textobjs').entireBuffer()
xnoremap gW <Cmd>lua require('various-textobjs').restOfWindow()
onoremap gW <Cmd>lua require('various-textobjs').restOfWindow()
xnoremap gw <Cmd>lua require('various-textobjs').visibleInWindow()
onoremap gw <Cmd>lua require('various-textobjs').visibleInWindow()
omap <silent> g% <Plug>(MatchitOperationBackward)
xmap <silent> g% <Plug>(MatchitVisualBackward)
nmap <silent> g% <Plug>(MatchitNormalBackward)
onoremap <silent> gc <Cmd>lua MiniComment.textobject()
xnoremap iI <Cmd>lua require('various-textobjs').indentation('inner', 'inner')
onoremap iI <Cmd>lua require('various-textobjs').indentation('inner', 'inner')
xnoremap ii <Cmd>lua require('various-textobjs').indentation('inner', 'inner')
onoremap ii <Cmd>lua require('various-textobjs').indentation('inner', 'inner')
xnoremap iq <Cmd>lua require('various-textobjs').anyQuote('inner')
onoremap iq <Cmd>lua require('various-textobjs').anyQuote('inner')
xnoremap ig <Cmd>lua require('various-textobjs').greedyOuterIndentation('inner')
onoremap ig <Cmd>lua require('various-textobjs').greedyOuterIndentation('inner')
xnoremap i_ <Cmd>lua require('various-textobjs').lineCharacterwise('inner')
onoremap i_ <Cmd>lua require('various-textobjs').lineCharacterwise('inner')
xnoremap im <Cmd>lua require('various-textobjs').chainMember('inner')
onoremap im <Cmd>lua require('various-textobjs').chainMember('inner')
xnoremap iz <Cmd>lua require('various-textobjs').closedFold('inner')
onoremap iz <Cmd>lua require('various-textobjs').closedFold('inner')
xnoremap iN <Cmd>lua require('various-textobjs').notebookCell('inner')
onoremap iN <Cmd>lua require('various-textobjs').notebookCell('inner')
xnoremap iF <Cmd>lua require('various-textobjs').filepath('inner')
onoremap iF <Cmd>lua require('various-textobjs').filepath('inner')
xnoremap iS <Cmd>lua require('various-textobjs').subword('inner')
onoremap iS <Cmd>lua require('various-textobjs').subword('inner')
xnoremap i# <Cmd>lua require('various-textobjs').color('inner')
onoremap i# <Cmd>lua require('various-textobjs').color('inner')
xnoremap iv <Cmd>lua require('various-textobjs').value('inner')
onoremap iv <Cmd>lua require('various-textobjs').value('inner')
xnoremap i, <Cmd>lua require('various-textobjs').argument('inner')
onoremap i, <Cmd>lua require('various-textobjs').argument('inner')
xnoremap ik <Cmd>lua require('various-textobjs').key('inner')
onoremap ik <Cmd>lua require('various-textobjs').key('inner')
xnoremap iD <Cmd>lua require('various-textobjs').doubleSquareBrackets('inner')
onoremap iD <Cmd>lua require('various-textobjs').doubleSquareBrackets('inner')
xnoremap io <Cmd>lua require('various-textobjs').anyBracket('inner')
onoremap io <Cmd>lua require('various-textobjs').anyBracket('inner')
xnoremap n <Cmd>lua require('various-textobjs').nearEoL()
onoremap n <Cmd>lua require('various-textobjs').nearEoL()
xnoremap r <Cmd>lua require('various-textobjs').restOfParagraph()
xnoremap <silent> sa :lua MiniSurround.add('visual')
xnoremap | <Cmd>lua require('various-textobjs').column()
onoremap | <Cmd>lua require('various-textobjs').column()
nmap <nowait> <C-Down> <Plug>(VM-Add-Cursor-Down)
nmap <nowait> <C-Up> <Plug>(VM-Add-Cursor-Up)
nmap <nowait> <S-Right> <Plug>(VM-Select-l)
nmap <nowait> <S-Left> <Plug>(VM-Select-h)
nnoremap <silent> <Plug>(VM-Select-BBW) :call vm#commands#motion('BBW', v:count1, 1, 0)
nnoremap <silent> <Plug>(VM-Select-gE) :call vm#commands#motion('gE', v:count1, 1, 0)
nnoremap <silent> <Plug>(VM-Select-ge) :call vm#commands#motion('ge', v:count1, 1, 0)
nnoremap <silent> <Plug>(VM-Select-E) :call vm#commands#motion('E', v:count1, 1, 0)
nnoremap <silent> <Plug>(VM-Select-e) :call vm#commands#motion('e', v:count1, 1, 0)
nnoremap <silent> <Plug>(VM-Select-B) :call vm#commands#motion('B', v:count1, 1, 0)
nnoremap <silent> <Plug>(VM-Select-b) :call vm#commands#motion('b', v:count1, 1, 0)
nnoremap <silent> <Plug>(VM-Select-W) :call vm#commands#motion('W', v:count1, 1, 0)
nnoremap <silent> <Plug>(VM-Select-w) :call vm#commands#motion('w', v:count1, 1, 0)
nnoremap <silent> <Plug>(VM-Select-l) :call vm#commands#motion('l', v:count1, 1, 0)
nnoremap <silent> <Plug>(VM-Select-k) :call vm#commands#motion('k', v:count1, 1, 0)
nnoremap <silent> <Plug>(VM-Select-j) :call vm#commands#motion('j', v:count1, 1, 0)
nnoremap <silent> <Plug>(VM-Select-h) :call vm#commands#motion('h', v:count1, 1, 0)
nnoremap <silent> <Plug>(VM-Mouse-Column) :call vm#commands#mouse_column()
nmap <silent> <Plug>(VM-Mouse-Word) <Plug>(VM-Left-Mouse)<Plug>(VM-Find-Under)
nmap <silent> <Plug>(VM-Mouse-Cursor) <Plug>(VM-Left-Mouse)<Plug>(VM-Add-Cursor-At-Pos)
nnoremap <silent> <Plug>(VM-Left-Mouse) <LeftMouse>
xnoremap <silent> <Plug>(VM-Visual-Regex) :call vm#commands#find_by_regex(2):call feedkeys('/', 'n')
nnoremap <silent> <Plug>(VM-Slash-Search) @=vm#commands#find_by_regex(3)
nnoremap <silent> <Plug>(VM-Start-Regex-Search) @=vm#commands#find_by_regex(1)
nnoremap <silent> <Plug>(VM-Find-Under) :call vm#commands#ctrln(v:count1)
xnoremap <silent> <Plug>(VM-Visual-Reduce) :call vm#visual#reduce()
xnoremap <silent> <Plug>(VM-Visual-Add) :call vm#commands#visual_add()
xnoremap <silent> <Plug>(VM-Visual-Cursors) :call vm#commands#visual_cursors()
nnoremap <silent> <Plug>(VM-Select-All) :call vm#commands#find_all(0, 1)
nnoremap <silent> <Plug>(VM-Reselect-Last) :call vm#commands#reselect_last()
nnoremap <silent> <Plug>(VM-Select-Cursor-Up) :call vm#commands#add_cursor_up(1, v:count1)
nnoremap <silent> <Plug>(VM-Select-Cursor-Down) :call vm#commands#add_cursor_down(1, v:count1)
nnoremap <silent> <Plug>(VM-Add-Cursor-Up) :call vm#commands#add_cursor_up(0, v:count1)
nnoremap <silent> <Plug>(VM-Add-Cursor-Down) :call vm#commands#add_cursor_down(0, v:count1)
nnoremap <silent> <Plug>(VM-Add-Cursor-At-Word) :call vm#commands#add_cursor_at_word(1, 1)
nnoremap <silent> <Plug>(VM-Add-Cursor-At-Pos) :call vm#commands#add_cursor_at_pos(0)
xmap <silent> <expr> <Plug>(VM-Visual-Find) vm#operators#find(1, 1)
xmap <silent> <Plug>(MatchitVisualTextObject) <Plug>(MatchitVisualMultiBackward)o<Plug>(MatchitVisualMultiForward)
onoremap <silent> <Plug>(MatchitOperationMultiForward) :call matchit#MultiMatch("W",  "o")
onoremap <silent> <Plug>(MatchitOperationMultiBackward) :call matchit#MultiMatch("bW", "o")
xnoremap <silent> <Plug>(MatchitVisualMultiForward) :call matchit#MultiMatch("W",  "n")m'gv``
xnoremap <silent> <Plug>(MatchitVisualMultiBackward) :call matchit#MultiMatch("bW", "n")m'gv``
nnoremap <silent> <Plug>(MatchitNormalMultiForward) :call matchit#MultiMatch("W",  "n")
nnoremap <silent> <Plug>(MatchitNormalMultiBackward) :call matchit#MultiMatch("bW", "n")
onoremap <silent> <Plug>(MatchitOperationBackward) :call matchit#Match_wrapper('',0,'o')
onoremap <silent> <Plug>(MatchitOperationForward) :call matchit#Match_wrapper('',1,'o')
xnoremap <silent> <Plug>(MatchitVisualBackward) :call matchit#Match_wrapper('',0,'v')m'gv``
xnoremap <silent> <Plug>(MatchitVisualForward) :call matchit#Match_wrapper('',1,'v'):if col("''") != col("$") | exe ":normal! m'" | endifgv``
nnoremap <silent> <Plug>(MatchitNormalBackward) :call matchit#Match_wrapper('',0,'n')
nnoremap <silent> <Plug>(MatchitNormalForward) :call matchit#Match_wrapper('',1,'n')
nnoremap <silent> <C-Bslash> <Cmd>execute v:count . "ToggleTerm"
nnoremap <Plug>PlenaryTestFile :lua require('plenary.test_harness').test_file(vim.fn.expand("%:p"))
nnoremap <silent> <C-N> <Nop>
nnoremap <S-Tab> :BufferLineCyclePrev
nnoremap <M-k> +
nnoremap <M-j> -
nnoremap <M-l> >
nnoremap <M-h> <
nnoremap <silent> <C-K> :TmuxNavigateUp
nnoremap <silent> <C-J> :TmuxNavigateDown
nnoremap <silent> <C-H> :TmuxNavigateLeft
nmap <C-W><C-D> d
nnoremap <silent> <C-L> :TmuxNavigateRight
inoremap <expr>  v:lua.require'nvim-autopairs'.completion_confirm()
inoremap  u
inoremap  u
inoremap <silent>  <Cmd>ToggleTerm
inoremap [[ <Cmd>Telekasten insert_link
inoremap jk 
let &cpo=s:cpo_save
unlet s:cpo_save
set clipboard=unnamedplus
set expandtab
set fileformats=unix,dos
set grepformat=%f:%l:%c:%m
set grepprg=rg\ --vimgrep\ -uu\ 
set guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,t:block-blinkon500-blinkoff500-TermCursor,a:SmearCursorHideable
set helplang=en
set ignorecase
set noloadplugins
set packpath=~\\scoop\\apps\\neovim\\current\\share/nvim/runtime
set runtimepath=~\\AppData\\Local\\nvim,~\\AppData\\Local\\nvim-data\\lazy\\lazy.nvim,~/AppData/Local/nvim-data/lazy/nvim-autopairs,~\\AppData\\Local\\nvim-data\\lazy\\LuaSnip,~\\AppData\\Local\\nvim-data\\lazy\\friendly-snippets,~\\AppData\\Local\\nvim-data\\lazy\\blink.cmp,~\\AppData\\Local\\nvim-data\\lazy\\cmp-path,~\\AppData\\Local\\nvim-data\\lazy\\cmp-buffer,~\\AppData\\Local\\nvim-data\\lazy\\nvim-cmp,~\\AppData\\Local\\nvim-data\\lazy\\sidekick.nvim,~\\AppData\\Local\\nvim-data\\lazy\\smear-cursor.nvim,~\\AppData\\Local\\nvim-data\\lazy\\auto-session,~\\AppData\\Local\\nvim-data\\lazy\\nvim-notify,~\\AppData\\Local\\nvim-data\\lazy\\mini.comment,~\\AppData\\Local\\nvim-data\\lazy\\toggleterm.nvim,~\\AppData\\Local\\nvim-data\\lazy\\mini.move,~\\AppData\\Local\\nvim-data\\lazy\\dressing.nvim,~\\AppData\\Local\\nvim-data\\lazy\\mini.ai,~\\AppData\\Local\\nvim-data\\lazy\\lualine.nvim,~\\AppData\\Local\\nvim-data\\lazy\\flash.nvim,~\\AppData\\Local\\nvim-data\\lazy\\bufferline.nvim,~\\AppData\\Local\\nvim-data\\lazy\\which-key.nvim,~\\AppData\\Local\\nvim-data\\lazy\\nvim-various-textobjs,~\\AppData\\Local\\nvim-data\\lazy\\vim-visual-multi,~\\AppData\\Local\\nvim-data\\lazy\\copilot.lua,~\\AppData\\Local\\nvim-data\\lazy\\lazygit.nvim,~\\AppData\\Local\\nvim-data\\lazy\\alpha-nvim,~\\AppData\\Local\\nvim-data\\lazy\\refactoring.nvim,~\\AppData\\Local\\nvim-data\\lazy\\mason-tool-installer.nvim,~\\AppData\\Local\\nvim-data\\lazy\\mason-lspconfig.nvim,~\\AppData\\Local\\nvim-data\\lazy\\mason.nvim,~\\AppData\\Local\\nvim-data\\lazy\\vim-tmux-navigator,~\\AppData\\Local\\nvim-data\\lazy\\blame.nvim,~\\AppData\\Local\\nvim-data\\lazy\\telekasten.nvim,~\\AppData\\Local\\nvim-data\\lazy\\nvim-early-retirement,~\\AppData\\Local\\nvim-data\\lazy\\mini.surround,~\\AppData\\Local\\nvim-data\\lazy\\nvim-treesitter-textobjects,~\\AppData\\Local\\nvim-data\\lazy\\nvim-treesitter,~\\AppData\\Local\\nvim-data\\lazy\\fzf-lua,~\\AppData\\Local\\nvim-data\\lazy\\vim-rhubarb,~\\AppData\\Local\\nvim-data\\lazy\\vim-fugitive,~\\AppData\\Local\\nvim-data\\lazy\\trouble.nvim,~\\AppData\\Local\\nvim-data\\lazy\\todo-comments.nvim,~\\AppData\\Local\\nvim-data\\lazy\\nvim-web-devicons,~\\AppData\\Local\\nvim-data\\lazy\\telescope-fzf-native.nvim,~\\AppData\\Local\\nvim-data\\lazy\\telescope.nvim,~\\AppData\\Local\\nvim-data\\lazy\\advanced-git-search.nvim,~\\AppData\\Local\\nvim-data\\lazy\\plenary.nvim,~\\AppData\\Local\\nvim-data\\lazy\\harpoon,~\\AppData\\Local\\nvim-data\\lazy\\snacks.nvim,~\\AppData\\Local\\nvim-data\\lazy\\catppuccin,~\\scoop\\apps\\neovim\\current\\share\\nvim\\runtime,~\\scoop\\apps\\neovim\\current\\share\\nvim\\runtime\\pack\\dist\\opt\\netrw,~\\scoop\\apps\\neovim\\current\\share\\nvim\\runtime\\pack\\dist\\opt\\matchit,~\\scoop\\apps\\neovim\\current\\lib\\nvim,~\\AppData\\Local\\nvim-data\\lazy\\readme,~\\AppData\\Local\\nvim-data\\lazy\\cmp-path\\after,~\\AppData\\Local\\nvim-data\\lazy\\cmp-buffer\\after,~\\AppData\\Local\\nvim-data\\lazy\\mason-lspconfig.nvim\\after,~\\AppData\\Local\\nvim-data\\lazy\\catppuccin\\after
set shiftwidth=2
set showtabline=2
set smartcase
set splitbelow
set splitright
set statusline=%#lualine_transparent#
set noswapfile
set tabline=%!v:lua.nvim_bufferline()
set tabstop=2
set termguicolors
set window=36
" vim: set ft=vim :
