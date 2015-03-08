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
endfunction




function! operator#siege#change(motionwise)  "{{{2
endfunction




function! operator#siege#delete(motionwise)  "{{{2
endfunction








" Misc.  "{{{1
function! operator#siege#mark_as_first()  "{{{2
  let s:first = 1
endfunction




function! s:input_deco()  "{{{2
  if s:first
    " TODO: Support user input with two or more characters.
    return get(s:deco_table, nr2char(getchar()), 0)
  else
    return s:deco
  endif
endfunction








" __END__  "{{{1
" vim: foldmethod=marker
