runtime! plugin/**/*.vim
runtime! t/helpers/**/*.vim

let g:operator_siege_decos = [
\   {'chars': ["'", "'"], 'objs': ["a'", "i'"], 'keys': ['q']},
\   {'chars': ['"', '"'], 'objs': ['a"', 'i"'], 'keys': ['Q']},
\   {'chars': ['`', '`'], 'objs': ['a`', 'i`'], 'keys': ['x']},
\   {'chars': ['<<', '>>'], 'keys': ['a']},
\   {'chars': ['「', '」'], 'keys': ['jk']},
\ ]

describe 'g:operator_siege_decos'
  before
    new
  end

  after
    close!
  end

  it 'allows users to add new decorators'
    Expect Do('fosiwq', 'foo bar baz') ==# "'foo' bar baz"
    Expect Do('fads"', 'foo "bar" baz') ==# 'foo bar baz'
    Expect Do('fzcs"x', 'foo bar "baz"') ==# 'foo bar `baz`'
  end

  it 'allows users to replace default decorators'
    Expect Do('frsfba', 'foo bar baz') ==# 'foo ba<<r b>>az'
  end

  it 'supports two or more keys to specify a decorator'
    Expect Do('fasiwjk', 'foo bar baz') ==# 'foo 「bar」 baz'
  end

  it 'asks and expands placeholders in a decorator'
    " Note that vit at T in <xxx>T</xxx> targets the whole element instead of
    " the inner text.
    Expect Do("fbsiw<div\<Return>", 'foo bar baz') ==# 'foo <div>bar</div> baz'
    Expect Do('fodst', 'f<em>o</em>o') ==# 'foo'
    Expect Do('fodst', 'f<em>oo</em>l') ==# 'fool'
    Expect Do('focstB', 'f<em>o</em>o') ==# 'f{o}o'
    Expect Do('focstB', 'f<em>oo</em>l') ==# 'f{oo}l'
  end

  it 'accepts also a custom finisher to input replacements of placeholders'
    Expect maparg('>', 'c') ==# ''
    Expect Do("fbsiw<svg>\<Esc>", 'foo bar baz') ==# 'foo <svg>bar</svg> baz'

    cnoremap <buffer> >  QUX
    Expect Do("fbsiw<svg>\<Esc>", 'foo bar baz') ==# 'foo <svg>bar</svg> baz'
    Expect maparg('>', 'c') ==# 'QUX'
    Expect maparg('>', 'c', 0, 1).buffer to_be_true
  end
end
