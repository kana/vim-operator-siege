function! Do(command, text)
  put =a:text
  execute 'normal' a:command
  return getline('.')
endfunction
