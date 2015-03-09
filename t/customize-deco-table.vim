runtime! plugin/**/*.vim
runtime! t/helpers/**/*.vim

let g:siege_decos = [
\   {'chars': ["'", "'"], 'objs': ["a'", "i'"], 'keys': ['q']},
\   {'chars': ['"', '"'], 'objs': ['a"', 'i"'], 'keys': ['Q']},
\   {'chars': ['`', '`'], 'objs': ['a`', 'i`'], 'keys': ['x']},
\   {'chars': ['<<', '>>'], 'keys': ['a']},
\   {'chars': ['「', '」'], 'keys': ['jk']},
\ ]

describe 'g:siege_decos'
  before
    new
    map <buffer> s  <Plug>(operator-siege-add)
    map <buffer> ds  <Plug>(siege-delete)
    map <buffer> cs  <Plug>(operator-siege-change)
  end

  after
    close!
  end

  it 'allows users to add new decorators'
    Expect Do('fosiwq', 'foo bar baz') ==# "'foo' bar baz"
    Expect Do('fads"', 'foo "bar" baz') ==# 'foo bar baz'
    Expect Do('fzcsi"x', 'foo bar "baz"') ==# 'foo bar `baz`'
  end

  it 'allows users to replace default decorators'
    Expect Do('frsfba', 'foo bar baz') ==# 'foo ba<<r b>>az'
  end

  it 'supports two or more keys to specify a decorator'
    Expect Do('fasiwjk', 'foo bar baz') ==# 'foo 「bar」 baz'
  end
end
