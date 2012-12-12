use strict;
use warnings;
use Test::More;
use t::Util;

my $a = new('-5:-3', '-2:1', 3, 5, '7-10');
is_deeply [$a->dump()], [-5..-3, -2..1, 3, 5, 7..10];

done_testing;
