runtime! plugin/**/*.vim
runtime! t/helpers/**/*.vim

describe '<Plug>(operator-siege-delete)'
  before
    new
  end

  after
    close!
  end

  it 'deletes target decoration characters which enclose the cursor'
    Expect Do('dsb', '(foo) (bar) (baz)') ==# 'foo (bar) (baz)'
    Expect Do('fzdsb', '(foo) (bar) (baz)') ==# '(foo) (bar) baz'
  end

  context 'on empty-content target'
    it 'deletes a whole target characterwise if it seems to be characterwise'
      Expect Do('f(dsb', 'foo () bar') ==# 'foo  bar'
      Expect Do('f)dsb', 'foo () bar') ==# 'foo  bar'
      Expect Do('f(dsb', '(foo () bar)') ==# '(foo  bar)'
      Expect Do('f)dsb', '(foo () bar)') ==# '(foo  bar)'
      Expect Do('f"ds"', 'foo "" bar') ==# 'foo  bar'
      Expect Do('f"ds"', 'foo "".bar') ==# 'foo .bar'
      Expect Do('f"ds"', 'foo."" bar') ==# 'foo. bar'
    end

    it 'deletes a whole target linewise if it seems to be linewise'
      Expect Do('wdsB', [
      \   '{',
      \   '  {',
      \   '  }',
      \   '}',
      \ ]) ==# [
      \   '{',
      \   '}',
      \ ]
      Expect Do('wdsB', [
      \   '[',
      \   '  {',
      \   '  }',
      \   ']',
      \ ]) ==# [
      \   '[',
      \   ']',
      \ ]
    end
  end

  it 'deletes target linewise if decoration characters are placed linewise'
    Expect Do('dsB', [
    \   '{',
    \   '  {',
    \   '    foo',
    \   '  }',
    \   '}',
    \ ]) ==# [
    \   '  {',
    \   '    foo',
    \   '  }',
    \ ]
    Expect Do('jjdsB', [
    \   '{',
    \   '  {',
    \   '    foo',
    \   '  }',
    \   '}',
    \ ]) ==# [
    \   '{',
    \   '    foo',
    \   '}',
    \ ]
  end
end

