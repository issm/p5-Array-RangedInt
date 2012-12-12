use strict;
use warnings;
use Test::More;
use t::Util;

my $a = new(1, 2, '5-7', 9, '10:12');
is $a->pop(), 12;
is $a->pop(), 11;
is $a->pop(), 10;
is $a->pop(), 9;
is $a->pop(), 7;
is $a->pop(), 6;
is $a->pop(), 5;
is $a->pop(), 2;
is $a->pop(), 1;
is $a->pop(), undef;
is $a->pop(), undef;

done_testing;
