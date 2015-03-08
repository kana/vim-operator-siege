runtime! plugin/**/*.vim
runtime! t/helpers/**/*.vim

describe '<Plug>(operator-siege-add)'
  before
    new
    map <buffer> s  <Plug>(operator-siege-add)
  end

  after
    close!
  end

  it 'encloses target region with decoration characters'
    Expect Do('siwb', 'foo bar baz') ==# '(foo) bar baz'
    Expect Do('fzsiwb', 'foo bar baz') ==# 'foo bar (baz)'
  end

  it 'is repeatable'
    SKIP 'Redo buffer is not recorded correctly in a test script.'
    Expect Do('siwb2fb.', 'foo bar baz') ==# '(foo) bar (baz)'
  end
end
