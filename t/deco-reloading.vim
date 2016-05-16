runtime! plugin/**/*.vim
runtime! t/helpers/**/*.vim

let s:decos1 = [
\   {'chars': ['<', '>'], 'objs': ['a<', 'i<'], 'keys': ['X']},
\   {'chars': ['{', '}'], 'objs': ['a{', 'i{'], 'keys': ['Y']},
\ ]

let s:decos2 = [
\   {'chars': ['[', ']'], 'objs': ['a[', 'i]'], 'keys': ['X']},
\   {'chars': ['(', ')'], 'objs': ['a(', 'i('], 'keys': ['Z']},
\ ]

describe 'g:operator_siege_decos'
  before
    new
  end

  after
    close!
    let g:operator_siege_decos = []
  end

  it 'is reloaded whenever operators are used after its change'
    Expect Do('fasiwX', 'foo bar baz') ==# "foo bar baz"
    Expect Do('fasiwY', 'foo bar baz') ==# "foo bar baz"
    Expect Do('fasiwZ', 'foo bar baz') ==# "foo bar baz"

    let g:operator_siege_decos = s:decos1

    Expect Do('fasiwX', 'foo bar baz') ==# "foo <bar> baz"
    Expect Do('fasiwY', 'foo bar baz') ==# "foo {bar} baz"
    Expect Do('fasiwZ', 'foo bar baz') ==# "foo bar baz"

    let g:operator_siege_decos = s:decos2

    Expect Do('fasiwX', 'foo bar baz') ==# "foo [bar] baz"
    Expect Do('fasiwY', 'foo bar baz') ==# "foo bar baz"
    Expect Do('fasiwZ', 'foo bar baz') ==# "foo (bar) baz"
  end
end
