" Carp
syn keyword perlStatementIOfunc carp cluck croak confess shortmess longmess

" List::Util
syn keyword perlStatementList first max maxstr min minstr reduce shuffle sum

" Test::More
syn keyword perlStatementTest use_ok require_ok ok is isnt diag like unlike
            \                 cmp_ok is_deeply skip can_ok isa_ok pass fail
            \                 plan done_testing subtest

" Test::Exception
syn keyword perlStatementTest dies_ok lives_ok throws_ok lives_and

hi def link perlStatementTest perlStatement
