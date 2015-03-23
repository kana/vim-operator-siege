#!/bin/bash

# Unfortunately, redo buffer is not correctly recorded for a command which is
# executed in Vim script.  So that input for tests on repeatability must be
# given as actual input to Vim process instead of emulated input by :normal.

./t/helpers/emulate-vim-session <(cat <<'END'
:"<Plug>(operator-siege-add)"
:put ='foo bar baz'
siwb2fb.
:
:"<Plug>(operator-siege-add-with-indent)"
:setlocal expandtab shiftwidth=2
:put ='foo bar baz'
SSBj.G
:
:"<Plug>(operator-siege-delete)"
:put ='(foo) (bar) (baz)'
dsb2fb.
:
:"<Plug>(operator-siege-change)"
:put ='(foo) (bar) (baz)'
csbB2fb.
END
) <(cat <<'END'

(foo) bar (baz)
{
  {
    foo bar baz
  }
}
foo (bar) baz
{foo} (bar) {baz}
END
)

# vim: filetype=sh
