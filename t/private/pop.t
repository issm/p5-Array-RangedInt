use strict;
use warnings;
use Test::More;
use t::Util;

my $a = new();

is_deeply [$a->_pop()], [];
is_deeply [$a->_pop(undef)], [];
is_deeply [$a->_pop(1)], [1];
is_deeply [$a->_pop(-1)], [-1];
is_deeply [$a->_pop('1-2')], [2, 1];
is_deeply [$a->_pop('-2:-1')], [-1, -2];
is_deeply [$a->_pop('1-3')], [3, '1-2'];
is_deeply [$a->_pop('-3:-1')], [-1, '-3--2'];

done_testing;

