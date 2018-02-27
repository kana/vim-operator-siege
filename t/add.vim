runtime! plugin/**/*.vim
runtime! t/helpers/**/*.vim

describe '<Plug>(operator-siege-add)'
  before
    new
  end

  after
    close!
  end

  it 'encloses target characterwise region with decoration characters'
    Expect Do('siwb', 'foo bar baz') ==# '(foo) bar baz'
    Expect Do('fzsiwb', 'foo bar baz') ==# 'foo bar (baz)'
  end

  it 'encloses target linewise region with decoration characters'
    " At the middle of a buffer.
    Expect Do('j^sjB', [
    \   '  foo',
    \   '    bar',
    \   '    baz',
    \   '  qux',
    \ ]) ==# [
    \   '  foo',
    \   '    {',
    \   '    bar',
    \   '    baz',
    \   '    }',
    \   '  qux',
    \ ]

    " At the beginning of a buffer.
    Expect Do('sjB', [
    \   '  foo',
    \   '    bar',
    \   '    baz',
    \   '  qux',
    \ ]) ==# [
    \   '  {',
    \   '  foo',
    \   '    bar',
    \   '  }',
    \   '    baz',
    \   '  qux',
    \ ]

    " At the end of a buffer.
    Expect Do('GskB', [
    \   '  foo',
    \   '    bar',
    \   '    baz',
    \   '  qux',
    \ ]) ==# [
    \   '  foo',
    \   '    bar',
    \   '    {',
    \   '    baz',
    \   '  qux',
    \   '    }',
    \ ]

    " Target the entier content of a buffer.
    Expect Do('VsB', 'foo') ==# [
    \   '{',
    \   'foo',
    \   '}',
    \ ]
  end

  it 'encloses target blockwise region as if characterwise at the moment'
    Expect Do("j^\<C-v>jlsr", [
    \   '  foo',
    \   '    bar',
    \   '    baz',
    \   '  qux',
    \ ]) ==# [
    \   '  foo',
    \   '    [bar',
    \   '    ba]z',
    \   '  qux',
    \ ]

    " TODO:
    " Expect Do("j^\<C-v>jksjr", [
    " \   '  foo',
    " \   '    bar',
    " \   '    baz',
    " \   '  qux',
    " \ ]) ==# [
    " \   '  foo',
    " \   '    [ba]r',
    " \   '    [ba]z',
    " \   '  qux',
    " \ ]
  end
end
