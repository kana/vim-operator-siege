" vim-operator-siege - Operator to besiege text
" Version: 0.0.0
" Copyright (C) 2015 Kana Natsuno <http://whileimautomaton.net/>
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
" Interface  "{{{1
function! operator#siege#add(motionwise)  "{{{2
  let deco = s:input_deco()
  if deco is 0
    return
  endif

  call s:add_deco(a:motionwise, deco)

  let s:first = 0
  let s:deco = deco
endfunction




function! operator#siege#change(motionwise)  "{{{2
  " TODO: Respect a:motionwise.
  let deco = s:input_deco()
  if deco is 0
    return
  endif

  call operator#siege#delete(a:motionwise)
  call s:add_deco(a:motionwise, deco)

  let s:first = 0
  let s:deco = deco
endfunction




function! operator#siege#delete(motionwise)  "{{{2
  " TODO: Respect a:motionwise.
  let rc = getreg('z')
  let rt = getregtype('z')

  normal! `[
  call search('\S', 'bW')
  normal! v
  normal! `]
  call search('\S', 'W')
  normal! "zy

  let matches = matchlist(@z, '\(\S\)\(.*\)\(\S\)')
  if has_key(s:undeco_table(), matches[1] . matches[3])
    let p = col('$') - 1 == col("'>") ? 'p' : 'P'
    normal! `<v`>"_d
    let @z = matches[2]
    execute 'normal!' '"z'.p.'`['
  endif

  call setreg('z', rc, rt)
endfunction








" Misc.  "{{{1
function! operator#siege#mark_as_first()  "{{{2
  let s:first = 1
endfunction




function! s:deco_table()  "{{{2
  if s:user_deco_table isnot g:siege_deco_table
    let s:user_deco_table = g:siege_deco_table
    let s:unified_deco_table = {}
    call extend(s:unified_deco_table, s:default_deco_table)
    call extend(s:unified_deco_table, s:user_deco_table)
  endif
  return s:unified_deco_table
endfunction

let s:unified_deco_table = {}

" TODO: Support at/it.
let s:default_deco_table = {
\   'b': ['(', ')'],
\   '(': ['(', ')'],
\   ')': ['(', ')'],
\   'a': ['<', '>'],
\   '<': ['<', '>'],
\   '>': ['<', '>'],
\   'r': ['[', ']'],
\   '[': ['[', ']'],
\   ']': ['[', ']'],
\   'B': ['{', '}'],
\   '{': ['{', '}'],
\   '}': ['{', '}'],
\   "'": ["'", "'"],
\   '"': ['"', '"'],
\   '`': ['`', '`'],
\ }

if !exists('g:siege_deco_table')
  let g:siege_deco_table = {}
endif
let s:user_deco_table = {}




function! s:undeco_table()  "{{{2
  let deco_table = s:deco_table()
  if s:_deco_table isnot deco_table
    let s:_deco_table = deco_table
    let s:undeco_table = {}
    for v in values(deco_table)
      let s:undeco_table[v[0] . v[1]] = 1
    endfor
  endif
  return s:undeco_table
endfunction

let s:_deco_table = {}




function! s:add_deco(motionwise, deco)  "{{{2
  " TODO: Respect a:motionwise.
  let rc = getreg('z')
  let rt = getregtype('z')

  let p = col('$') - 1 == col("']") ? 'p' : 'P'
  normal! `[v`]"zd
  let @z = a:deco[0] . @z . a:deco[1]
  execute 'normal!' '"z'.p.'`['

  call setreg('z', rc, rt)
endfunction




function! s:input_deco()  "{{{2
  if s:first
    " TODO: Support user input with two or more characters.
    return get(s:deco_table(), nr2char(getchar()), 0)
  else
    return s:deco
  endif
endfunction








" __END__  "{{{1
" vim: foldmethod=marker
