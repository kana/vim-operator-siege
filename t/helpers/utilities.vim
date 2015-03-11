function! Do(command, text)
  % delete _
  put =a:text
  1 delete _
  execute 'normal' a:command
  let lines = getline(1, '$')
  return len(lines) == 1 ? lines[0] : lines
endfunction
