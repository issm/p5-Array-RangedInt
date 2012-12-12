use strict;
use warnings;
use Test::More;
use t::Util;

my $a = new();

is_deeply [$a->_shift()], [];
is_deeply [$a->_shift(undef)], [];
is_deeply [$a->_shift(1)], [1];
is_deeply [$a->_shift(-1)], [-1];
is_deeply [$a->_shift('1-2')], [1, 2];
is_deeply [$a->_shift('-2:-1')], [-2, -1];
is_deeply [$a->_shift('1-3')], [1, '2-3'];
is_deeply [$a->_shift('-3:-1')], [-3, '-2--1'];

done_testing;

