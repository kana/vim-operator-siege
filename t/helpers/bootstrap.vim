function s:bootstrap()
  let standard_paths = split(&runtimepath, ',')[1:-2]
  let non_standard_paths =
  \ reverse(
  \   map(
  \     ['.'] + split(glob('./.vim-flavor/deps/*/'), '\n'),
  \     'fnamemodify(v:val, ":p:h")'
  \   )
  \ )
  let all_paths = copy(standard_paths)
  for i in non_standard_paths
    let all_paths = [i] + all_paths + [i . '/after']
  endfor
  let &runtimepath = join(all_paths, ',')
endfunction
call s:bootstrap()


" MEMO:
"
"     function Rec()
"       let g:x = getpos('.')
"       return ''
"     endfunction
"     nmap <expr> rec  Rec()
"     put ='foo bar baz'
"     normal farec
"
" g:x equals [0, 2, 1, 0], not [0, 2, 6, 0].
" This problem occurs when the whole code is run non-interactively.
" <C-l> in the following mappings is to update the cursor information forcibly.
runtime! plugin/operator/siege.vim
map s  <Plug>(operator-siege-add)
map S  <Plug>(operator-siege-add-with-indent)
nmap ds  <C-l><Plug>(operator-siege-delete)
nmap cs  <C-l><Plug>(operator-siege-change)
