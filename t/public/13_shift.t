use strict;
use warnings;
use Test::More;
use t::Util;

my $a = new(1, 2, '5-7', 9, '10:12');
is $a->shift(), 1;
is $a->shift(), 2;
is $a->shift(), 5;
is $a->shift(), 6;
is $a->shift(), 7;
is $a->shift(), 9;
is $a->shift(), 10;
is $a->shift(), 11;
is $a->shift(), 12;
is $a->shift(), undef;
is $a->shift(), undef;

$a = new('010-020');
is $a->shift(), 10;
is_deeply $a->{_items}, ['11-20'];

done_testing;
