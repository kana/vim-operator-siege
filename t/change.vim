runtime! plugin/**/*.vim
runtime! t/helpers/**/*.vim

describe '<Plug>(operator-siege-change)'
  before
    new
    map <buffer> cs  <Plug>(operator-siege-change)
  end

  after
    close!
  end

  it 'changes decoration characters enclosing target region'
    Expect Do('csbB', '(foo) (bar) (baz)') ==# '{foo} (bar) (baz)'
    Expect Do('fzcsbB', '(foo) (bar) (baz)') ==# '(foo) (bar) {baz}'
  end

  it 'changes target linewise if decoration characters are placed linewise'
    Expect Do('csBa', [
    \   '{',
    \   '  {',
    \   '    foo',
    \   '  }',
    \   '}',
    \ ]) ==# [
    \   '<',
    \   '  {',
    \   '    foo',
    \   '  }',
    \   '>',
    \ ]
    Expect Do('jjcsBa', [
    \   '{',
    \   '  {',
    \   '    foo',
    \   '  }',
    \   '}',
    \ ]) ==# [
    \   '{',
    \   '  <',
    \   '    foo',
    \   '  >',
    \   '}',
    \ ]
  end
end

