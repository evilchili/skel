" Embedded() is a function that will parse a text buffer 
" looking for embedded vim commands, and execute them.
" Call it with a range of lines to check, eg to check the whole 
" file:
" 
"  :%call Embedded() 
"
" Commands should be prefixed by the sequence :vim: .
"
function Embedded() range
    let n = a:firstline
    while n <= a:lastline
        let l = getline(n)
        let p = stridx(l,':vim:')
        if p > -1
            let p = p + 5 
            let c = strpart(l,p)
            execute c
        endif   
        let n = n + 1 
    endwhile 
endfunction
" call Embedded() whenever a file is loaded and 
" parse the entire file.  You may not want to do 
" this for *; maybe just your src tree or certain 
" file types or something.
autocmd BufWinEnter * %call Embedded()
autocmd BufNewFile,BufRead *.less set filetype=css

" Create nested folds on custom expressions, based 
" on the current buffer's filetype or syntax. 
"
let g:foldlevel = 0
let g:foldstartexpr = ''
let g:foldendexpr   = ''
function GetCustomFold()
	if getline(v:lnum) =~ g:foldstartexpr
		let g:foldlevel = g:foldlevel + 1
		return ">".g:foldlevel
	elseif getline(v:lnum) =~ g:foldendexpr
		let thislevel = g:foldlevel
		let g:foldlevel = g:foldlevel - 1 
		return "<".thislevel
	else 
		return g:foldlevel
	endif
endfunction
function SetFoldType()
	let f = &filetype ? &filetype : &syntax
	if f == 'mason'
		let g:foldstartexpr = '^\s*<\(script\|style\|%init\|%attr\|%once\|%args\|%flags\|%shared\|%def\)[^>]*>\s*$'
		let g:foldendexpr   = '^\s*</\(script\|style\|%init\|%attr\|%once\|%args\|%flags\|%shared\|%def\)[^>]*>\s*$'
	elseif f == 'perl'
		let g:foldstartexpr = '^sub.*{\s*$'
		let g:foldendexpr   = '^}\s*$'
	elseif f == 'javascript'
		let g:foldstartexpr = '^function.*{\s*$'
		let g:foldendexpr   = '^}\s*$'
	elseif f == 'css'
		let g:foldstartexpr = '^\/\*\*\*.*\*\/$'
		let g:foldendexpr   = '^\/\*.*\*\*\*/$'
	elseif f == 'sh'
		let g:foldstartexpr = '^function.*{\s*$'
		let g:foldendexpr   = '^}\s*$'
	elseif f == 'puppet'
		let g:foldstartexpr = '^.*{[^}]*$'
		let g:foldendexpr   = '}\s*\(->\s*\)\?$'
	else 
		return
	endif
	setlocal foldexpr=GetCustomFold()
	setlocal foldmethod=expr 
endfunction
autocmd BufWinEnter * %call SetFoldType()

function SetPerlIDE()
	" check perl code with :make
	setlocal makeprg=perl\ -c\ %\ $*
	setlocal errorformat=%f:%l:%m
	setlocal autowrite
	
	" comment/uncomment blocks of code (in vmode)
	map  :s/^/#/gi<Enter>
	map  :s/^#//gi<Enter>
	
	" my perl includes pod
	let perl_include_pod = 1
	
	" syntax color complex things like @{${"foo"}}
	let perl_extended_vars = 1
	
	" Tidy selected lines (or entire file) with _t:
	nnoremap <silent> _t :%!perltidy -q<Enter>
	vnoremap <silent> _t :!perltidy -q<Enter>

	" perlcritic selected lines (or entire file) with _p:
	nnoremap <silent> _p :%!perlcritic -q<Enter>
	vnoremap <silent> _p :!perlcritic -q<Enter>
endfunction
autocmd FileType perl call SetPerlIDE()

function SetPythonIDE()
	" reconfigure for python hackingses
	
	" use the builtins from the flake8 bundle
	let g:flake8_builtins="_,apply"

	" *weeps*
	set expandtab

	" automatically check style when writing a python file
	autocmd BufWritePost *.py call Flake8()

endfunction
autocmd FileType python call SetPythonIDE()

" map II :r ~/.vim/template.pod<CR>

map :sw :w !sudo tee %

set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
set number
set showmatch
set ruler
set backup
set lbr
set backupdir=~/.vim/backups
set directory=~/.vim/backups
set tags=~/.vim/tags
set shell=bash\ --login

set backupskip=/tmp/*,/private/tmp/*" 

set title
set titlestring=vim:\ %F

" turn on fold indicators
set foldcolumn=1
set fdc=2

" we get colors, we get lots and lots of colors
set bg=dark
set t_Co=256
colorscheme chili
let &colorcolumn=join(range(81,999),",")
syntax enable

call pathogen#infect()

" omnicompletion
filetype plugin indent on
set ofu=syntaxcomplete#Complete

" remap completion to control+space
inoremap <expr> <C-Space> pumvisible() \|\| &omnifunc == '' ?
\ "\<lt>C-n>" :
\ "\<lt>C-x>\<lt>C-o><c-r>=pumvisible() ?" .
\ "\"\\<lt>c-n>\\<lt>c-p>\\<lt>c-n>\" :" .
\ "\" \\<lt>bs>\\<lt>C-n>\"\<CR>"
imap <C-@> <C-Space>

" use the tab key as the tab key
let g:SuperTabMappingTabLiteral = '<tab>'

" Shell <somecommand>
function! s:ExecuteInShell(command, bang)
	let _ = a:bang != '' ? s:_ : a:command == '' ? '' : join(map(split(a:command), 'expand(v:val)'))

	if (_ != '')
		let s:_ = _
		let bufnr = bufnr('%')
		let winnr = bufwinnr('^' . _ . '$')
		silent! execute  winnr < 0 ? 'new ' . fnameescape(_) : winnr . 'wincmd w'
		setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap number
		silent! :%d
		let message = 'Execute ' . _ . '...'
		call append(0, message)
		echo message
		"silent! 2d | resize 1 | redraw
		silent! execute 'silent! %!'. _
		"silent! execute 'resize ' . line('$')
		silent! execute 'syntax on'
		silent! execute 'autocmd BufUnload <buffer> execute bufwinnr(' . bufnr . ') . ''wincmd w'''
		"silent! execute 'autocmd BufEnter <buffer> execute ''resize '' .  line(''$'')'
		silent! execute 'nnoremap <silent> <buffer> <CR> :call <SID>ExecuteInShell(''' . _ . ''', '''')<CR>'
		silent! execute 'nnoremap <silent> <buffer> <LocalLeader>r :call <SID>ExecuteInShell(''' . _ . ''', '''')<CR>'
		silent! execute 'nnoremap <silent> <buffer> <LocalLeader>g :execute bufwinnr(' . bufnr . ') . ''wincmd w''<CR>'
		"nnoremap <silent> <buffer> <C-W>_ :execute 'resize ' . line('$')<CR>
		silent! syntax on
	endif
endfunction

command! -complete=shellcmd -nargs=* -bang Shell call s:ExecuteInShell(<q-args>, '<bang>')
cabbrev shell Shell

" macvim options
if has("gui_running")
	set gfn=Menlo:h12
	set guioptions-=r
	set guioptions-=L
	set guioptions-=T
	set transparency=10
	macm Window.Select\ Previous\ Tab  key=<D-S-Left>
	macm Window.Select\ Next\ Tab	   key=<D-S-Right>
endif
