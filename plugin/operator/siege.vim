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

if exists('g:loaded_operator_siege')
  finish
endif



call operator#user#define('siege-add', 'operator#siege#add',
\                         'call operator#siege#prepare_to_add(0)')
call operator#user#define('siege-add-with-indent', 'operator#siege#add',
\                         'call operator#siege#prepare_to_add(1)')

nmap <expr> <Plug>(operator-siege-change)  operator#siege#prepare_to_change()
vnoremap <Plug>(operator-siege-change)  <Nop>
onoremap <Plug>(operator-siege-change)  <Nop>
call operator#user#define('siege-%change', 'operator#siege#change')

nmap <expr> <Plug>(operator-siege-delete)  operator#siege#prepare_to_delete()
vnoremap <Plug>(operator-siege-delete)  <Nop>
onoremap <Plug>(operator-siege-delete)  <Nop>
call operator#user#define('siege-%delete', 'operator#siege#delete')




let g:loaded_operator_siege = 1

" __END__
" vim: foldmethod=marker
