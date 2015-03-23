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

runtime! plugin/operator/siege.vim
map s  <Plug>(operator-siege-add)
map S  <Plug>(operator-siege-add-with-indent)
nmap ds  <Plug>(operator-siege-delete)
nmap cs  <Plug>(operator-siege-change)
