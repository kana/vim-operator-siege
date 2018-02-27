runtime! plugin/**/*.vim
runtime! t/helpers/**/*.vim

describe 'operator-siege'
  before
    new
  end

  after
    close!
  end

  context 'add'
    it 'encloses target region with spaced decoration characters'
      Expect Do('siw b', 'foo bar baz') ==# '( foo ) bar baz'
      Expect Do('fzsiw b', 'foo bar baz') ==# 'foo bar ( baz )'
    end

    it 'encloses target region with spaces'
      Expect Do('ffsiw  ', '(foo) bar baz') ==# '( foo ) bar baz'
      Expect Do('fzsiw  ', 'foo bar (baz)') ==# 'foo bar ( baz )'
    end

    it 'adds inner blank lines instead of spaces for linewise target'
      Expect Do('Vs B', 'foo bar baz') ==# ['{', '', 'foo bar baz', '', '}']
      Expect Do('Vs  ', 'foo bar baz') ==# ['', 'foo bar baz', '']
    end
  end

  context 'delete'
    it 'ignores spaced flag'
      redir => messages
      Expect Do('fads b', 'foo( bar )baz') ==# 'foo bar baz'
      redir END
      Expect messages == ''

      redir => messages
      Expect Do('fads  ', 'foo bar baz') ==# 'foo bar baz'
      redir END
      Expect messages =~# 'Deco " " cannot be used for deletion.'
    end
  end
end
