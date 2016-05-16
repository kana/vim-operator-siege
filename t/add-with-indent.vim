runtime! plugin/**/*.vim
runtime! t/helpers/**/*.vim

describe '<Plug>(operator-siege-add-with-indent)'
  before
    new
  end

  after
    close!
  end

  it 'behaves the same as <Plug>(operator-siege-add) on characterwise region'
    Expect Do('Siwb', 'foo bar baz') ==# '(foo) bar baz'
    Expect Do('fzSiwb', 'foo bar baz') ==# 'foo bar (baz)'
  end

  it 'encloses target linewise region and indents it'
    setlocal shiftwidth=2

    " At the middle of a buffer.
    Expect Do('j^SjB', [
    \   '  foo',
    \   '    bar',
    \   '    baz',
    \   '  qux',
    \ ]) ==# [
    \   '  foo',
    \   '    {',
    \   '      bar',
    \   '      baz',
    \   '    }',
    \   '  qux',
    \ ]

    " At the beginning of a buffer.
    Expect Do('SjB', [
    \   '  foo',
    \   '    bar',
    \   '    baz',
    \   '  qux',
    \ ]) ==# [
    \   '  {',
    \   '    foo',
    \   '      bar',
    \   '  }',
    \   '    baz',
    \   '  qux',
    \ ]

    " At the end of a buffer.
    Expect Do('GSkB', [
    \   '  foo',
    \   '    bar',
    \   '    baz',
    \   '  qux',
    \ ]) ==# [
    \   '  foo',
    \   '    bar',
    \   '    {',
    \   '      baz',
    \   '    qux',
    \   '    }',
    \ ]
  end

  it 'indents according to the current options (shiftwidth != 0)'
    setlocal expandtab shiftwidth=2 tabstop=8
    Expect Do('VSB', 'foo') ==# [
    \   '{',
    \   '  foo',
    \   '}',
    \ ]

    setlocal noexpandtab shiftwidth=2 tabstop=8
    Expect Do('VSB', 'foo') ==# [
    \   '{',
    \   '  foo',
    \   '}',
    \ ]

    setlocal expandtab shiftwidth=2 tabstop=8
    Expect Do('VSB', '      foo') ==# [
    \   '      {',
    \   '        foo',
    \   '      }',
    \ ]

    setlocal noexpandtab shiftwidth=2 tabstop=8
    Expect Do('VSB', '      foo') ==# [
    \   '      {',
    \   "\tfoo",
    \   '      }',
    \ ]
  end

  it 'indents according to the current options (shiftwidth == 0)'
    if v:version < 703 || v:version == 703 && !has('patch694')
      SKIP 'Vim older than 7.3.694 do not allow to set shiftwidth to 0'
    endif

    setlocal expandtab shiftwidth=0 tabstop=8
    Expect Do('VSB', 'foo') ==# [
    \   '{',
    \   '        foo',
    \   '}',
    \ ]

    setlocal noexpandtab shiftwidth=0 tabstop=8
    Expect Do('VSB', 'foo') ==# [
    \   '{',
    \   "\tfoo",
    \   '}',
    \ ]
  end
end
