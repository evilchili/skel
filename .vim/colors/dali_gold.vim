" vim: tw=0 ts=4 sw=4
" Vim color file
" 
" Creator: evilchili@gmail.com
" Credits: modified version of golden.vim by Ryan Phillips (http://www.trolocsis.com/vim/golden.vim)
"

hi clear
set background=dark
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "dali_gold"
hi Normal		  ctermfg=lightgray guifg=#DDDDDD
hi Scrollbar	  ctermfg=lightgray guifg=#000000
hi Menu			  ctermfg=darkyellow guifg=#ffddaa  guibg=black
hi SpecialKey	  ctermfg=yellow term=bold  cterm=bold  guifg=#ffddaa 
hi NonText		  ctermfg=LightBlue term=bold  cterm=bold  gui=bold	guifg=#DAAC3B
hi Directory	  ctermfg=DarkYellow term=bold  cterm=bold  guifg=#ffddaa
hi ErrorMsg		  term=standout  cterm=bold  ctermfg=White  guifg=White
hi Search		  term=reverse	ctermfg=white  ctermbg=red	guifg=white  guibg=#333333
hi MoreMsg		  term=bold  cterm=bold  ctermfg=Yellow	gui=bold  guifg=#DDDDDD
hi ModeMsg		  term=bold  ctermfg=DarkYellow cterm=bold  gui=bold  guifg=#FFDDAA 
hi LineNr		  term=underline ctermfg=Brown cterm=bold guifg=#805725
hi Question		  term=standout  cterm=bold  ctermfg=Brown	gui=bold  guifg=#ffddaa guibg=#2E2E2E
hi Title		  term=bold  cterm=bold  ctermfg=brown  gui=bold	guifg=#DAAC3B
hi Visual		  term=reverse	cterm=reverse  gui=reverse
hi WarningMsg	  term=standout  cterm=bold  ctermfg=darkblue  guifg=White
hi Cursor		  guifg=bg	guibg=#FF5E06 ctermbg=Brown
hi Comment		  term=bold  cterm=bold ctermfg=brown  guifg=#805725
hi Constant		  term=underline  cterm=bold ctermfg=yellow  guifg=#FFFBAB
hi Special		  term=bold  cterm=bold ctermfg=red guifg=#A5652C
hi Identifier	  term=underline ctermfg=lightgray  guifg=#DAAC3B
hi Statement	  term=bold  cterm=bold ctermfg=lightgreen	gui=bold  guifg=#805725
hi PreProc		  term=underline  ctermfg=brown	guifg=#ffddaa
hi Type			  term=underline  cterm=bold ctermfg=lightgreen  gui=bold  guifg=#FFE13F
hi Error		  term=reverse	ctermfg=darkcyan  ctermbg=black  guifg=Red	guibg=Black
hi Todo			  term=standout  ctermfg=black	ctermbg=yellow  guifg=#FFE13F  guibg=#2E2E2E
hi VertSplit      guifg=#2E2E2E guibg=#805725 ctermfg=black ctermbg=darkgrey guibg=#DAAC3B
hi Folded		  guifg=orange  ctermfg=yellow guibg=#010101
hi FoldColumn	  guifg=orange  ctermfg=yellow guibg=#010101

"hi StatusLine	  term=reverse  cterm=bold ctermfg=Black ctermbg=DarkGrey gui=bold guifg=#805725 guibg=#2E2E2E
"hi StatusLineNC   term=reverse	ctermfg=white ctermbg=black guifg=grey guibg=#000000

hi MatchParen     cterm=NONE ctermbg=white ctermfg=white guibg=white
hi ColorColumn    cterm=NONE ctermbg=black  ctermfg=black guibg=#000000
hi OverLength    cterm=NONE ctermbg=black  ctermfg=black guibg=#000000

hi pythonComment  term=bold  cterm=bold ctermfg=brown  guifg=#777777
hi link pythonDocString pythonComment

hi link IncSearch		Visual
hi link String			Constant
hi link Character		Constant
hi link Number			Constant
hi link Boolean			Constant
hi link Float			Number
hi link Function		Identifier
hi link Conditional		Statement
hi link Repeat			Statement
hi link Label			Statement
hi link Operator		Statement
hi link Keyword			Statement
hi link Exception		Statement
hi link Include			PreProc
hi link Define			PreProc
hi link Macro			PreProc
hi link PreCondit		PreProc
hi link StorageClass	Type
hi link Structure		Type
hi link Typedef			Type
hi link Tag				Special
hi link SpecialChar		Special
hi link Delimiter		Special
hi link SpecialComment	Special
hi link Debug			Special
