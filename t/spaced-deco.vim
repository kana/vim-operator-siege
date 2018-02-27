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
    end

    it 'does not support deleting spaces'
      redir => messages
      Expect Do('fads  ', 'foo bar baz') ==# 'foo bar baz'
      redir END
      Expect messages =~# 'Deco " " cannot be used for deletion.'
    end
  end

  context 'change'
    it 'supports spaced deco for replacement'
      Expect Do('csb B', '(foo) (bar) (baz)') ==# '{ foo } (bar) (baz)'
      Expect Do('fzcsb  ', '(foo) (bar) (baz)') ==# '(foo) (bar)  baz '
    end

    it 'ignores spaced deco for target'
      redir => messages
      Expect Do('cs bB', '( foo ) (bar) (baz)') ==# '{ foo } (bar) (baz)'
      redir END
      Expect messages == ''
    end

    it 'does not support spaces for target'
      redir => messages
      Expect Do('fzcs  B', '(foo) (bar) ( baz )') ==# '(foo) (bar) ( baz )'
      redir END
      Expect messages =~# 'Deco " " cannot be used as target for change.'
    end
  end
end
